#!/bin/bash

IDENTITY_DB="netcredit_identity_development"
PORTFOLIO_DB="netcredit_portfolio_development"
MEF_DB="mef_development"
MEF_PORT_DB="merge_mef_portfolio"

if [ $1 ]; then
  IDENTITY_DB=$1
  PORTFOLIO_DB=$1
  MEF_DB=$1
  MEF_PORT_DB=$1
fi

psql -U postgres $IDENTITY_DB -c "DROP VIEW ncv_credit_reports;"
psql -U postgres $IDENTITY_DB -c \
"CREATE VIEW ncv_credit_reports AS \
SELECT c.account_id, c.credit_report_id, t.credit_report_type, f.credit_report_field_id, \
f.credit_report_field, v.credit_report_value_id, v.value \
FROM identity.credit_report_fields f , identity.credit_report_values v, \
identity.credit_reports c, identity.credit_report_types t \
WHERE c.credit_report_type_id=t.credit_report_type_id AND \
f.credit_report_field_id=v.credit_report_field_id \
AND v.credit_report_id=c.credit_report_id \
ORDER BY account_id, credit_report_id, credit_report_type;"
 
psql -U postgres $IDENTITY_DB -c "DROP VIEW ncv_customer_PII;"
psql -U postgres $IDENTITY_DB -c \
"CREATE VIEW ncv_customer_PII AS \
SELECT a.account_id, a.login, p.person_id, p.first_name, p.last_name, \
p.date_of_birth, git.government_identifier_type, gi.identifier \
FROM identity.accounts a \
LEFT JOIN identity.people p \
ON a.person_id = p.person_id \
LEFT JOIN identity.government_identifiers gi \
ON a.account_id = gi.account_id \
LEFT JOIN identity.government_identifier_types git \
ON gi.government_identifier_type_id = git.government_identifier_type_id \
ORDER BY a.account_id DESC;"

psql -U postgres $IDENTITY_DB -c "DROP VIEW ncv_bank_accounts;"
psql -U postgres $IDENTITY_DB -c \
"CREATE VIEW ncv_bank_accounts AS \
SELECT bh.account_id, ba.* FROM identity.bank_accounts ba \
INNER JOIN identity.bank_account_history bh \
ON ba.bank_account_id = bh.bank_account_id;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_enabled_states;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_enabled_states AS \
SELECT region FROM portfolio.regions where region_id in \
(SELECT distinct region_id FROM portfolio.rule_sets where is_enabled = true and product_id in (1,2));"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_loan_offers;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_loan_offers AS \
SELECT lo.loan_offer_id, lo.account_id, lo.num_installments, lo.max_amount, lo.min_amount, \
lo.target_amount, lo.suitable, lo.reason_unsuitable, \
lo.loan_length, lo.underwriting_decision_id AS ud_id, lo.grandfather_loan_offer_id \
FROM portfolio.loan_offers lo \
ORDER BY loan_offer_id DESC;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_underwriting_decline_reasons;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_underwriting_decline_reasons AS \
SELECT la.account_id, la.loan_application_id, ud.underwriting_decision_id, \
r.region, ud.tier, uds.status, p.product, udr.underwriting_decision_reason \
FROM portfolio.underwriting_decisions ud \
LEFT JOIN portfolio.loan_applications la \
ON ud.loan_application_id = la.loan_application_id \
LEFT JOIN portfolio.regions r \
ON la.region_id = r.region_id \
LEFT JOIN portfolio.products p \
ON ud.product_id = p.product_id \
LEFT JOIN portfolio.underwriting_decision_statuses uds \
ON ud.underwriting_decision_status_id = uds.underwriting_decision_status_id \
LEFT JOIN portfolio.underwriting_decision_reasons_underwriting_decisions udrud \
ON udrud.underwriting_decision_id = ud.underwriting_decision_id \
LEFT JOIN portfolio.underwriting_decision_reasons udr \
ON udrud.underwriting_decision_reason_id = udr.underwriting_decision_reason_id \
ORDER BY la.loan_application_id DESC;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_loan_app_results;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_loan_app_results AS \
SELECT la.loan_application_id AS ln_app_id, la.account_id, \
las.loan_application_status AS ln_app_status, la.loan_agreement_id AS ln_agmnt_id, lag.loan_offer_id AS ln_offer_id, \
la.requested_loan_amount AS req_amount, la.loan_number AS ln_num, r.region, \
ud.underwriting_decision_id AS ud_id, uds.status AS ud_status, ud.underwriter_name, p.product, ud.tier, \
la.created_at \
FROM portfolio.loan_applications la \
LEFT JOIN portfolio.loan_application_statuses las \
ON la.loan_application_status_id = las.loan_application_status_id \
LEFT JOIN portfolio.regions r \
ON la.region_id = r.region_id \
LEFT JOIN portfolio.underwriting_decisions ud \
ON la.loan_application_id = ud.loan_application_id \
LEFT JOIN portfolio.underwriting_decision_statuses uds \
ON ud.underwriting_decision_status_id = uds.underwriting_decision_status_id \
LEFT JOIN portfolio.loan_agreements lag \
ON la.loan_agreement_id = lag.loan_agreement_id \
LEFT JOIN portfolio.products p \
ON ud.product_id = p.product_id \
ORDER BY la.loan_application_id DESC;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_loans;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_loans AS \
SELECT l.loan_id AS ln_id, l.loan_number AS ln_num, l.account_id AS acc_id, l.loan_agreement_id AS agmt_id, \
l.loan_status_id AS status, l.is_open AS open, l.amount AS amt, l.disbursement_amount AS disb_amt, \
l.disbursement_date AS disb_date, l.created_at AS created_at, l.updated_at AS updated_at, \
l.finance_charge_start_date AS finance_date, l.product_id AS product, \
l.region_id AS region, l.country_id AS country, l.interest_rate AS int_rate, \
l.repayment_method_id AS rpmt_meth, l.funding_method_id AS fund_meth \
FROM loans l;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_scheduled_payments;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_scheduled_payments AS \
SELECT sp.scheduled_payment_id AS sp_id, sp.loan_id, sp.loan_agreement_id AS ln_agmt_id, \
sp.re_presentment_of_id AS re_prsmt_of_id, sp.generated_by_system AS gen_by_sys, \
sp.portal_user_id AS portal_user_id, sp.account_id AS acc_id, \
sp.original_amount AS orig_amt, sp.amount AS amt, sp.override_amount AS override_amt, \
sp.original_due_date AS orig_due_date, sp.due_date AS due_date, sp.target_date AS target_date, \
sp.created_at AS created_at, sp.updated_at AS updated_at \
FROM scheduled_payments sp;"

psql -U postgres $PORTFOLIO_DB -c "DROP VIEW ncv_payments;"
psql -U postgres $PORTFOLIO_DB -c \
"CREATE VIEW ncv_payments AS \
SELECT p.payment_id AS p_id, p.scheduled_payment_id AS sp_id, p.loan_id, \
pp.payment_purpose AS purpose, p.is_outgoing AS outgoing, p.is_retroactive AS retro, \
ps.payment_status AS status, p.portal_user_id AS portal_user_id, p.amount AS amount, \
p.effective_date AS eff_date, p.settlement_date AS settle_date, \
p.created_at AS created_at, p.updated_at AS updated_at, \
p.repayment_method_id AS repay_meth \
FROM payments p \
LEFT JOIN payment_purposes pp \
ON p.payment_purpose_id = pp.payment_purpose_id \
LEFT JOIN payment_statuses ps \
ON p.payment_status_id = ps.payment_status_id;"

psql -U postgres $MEF_DB -c "DROP VIEW ncv_equation_details"
psql -U postgres $MEF_DB -c \
"CREATE VIEW ncv_equation_details AS \
SELECT r.id AS result_id, r.answer, e.equation_name, v.variable_name \
FROM mef.results r \
LEFT JOIN mef.equations e \
ON r.equation_id = e.id \
LEFT JOIN mef.equation_variables ev \
ON ev.equation_id = e.id \
LEFT JOIN mef.variables v \
ON ev.variable_id = v.id \
ORDER BY result_id DESC;" 

psql -U postgres $MEF_DB -c "DROP VIEW ncv_results;"
psql -U postgres $MEF_DB -c \
"CREATE VIEW ncv_results AS \
SELECT r.id, r.inquiry_time, r.equation_id, e.equation_name, r.input_id, \
r.answer, r.raw_score, r.default_score, r.tier_score_raw, r.tier_score \
FROM mef.results r \
LEFT JOIN mef.equations e \
ON r.equation_id = e.id \
ORDER BY r.id desc;"

psql -U postgres $MEF_PORT_DB -c "DROP VIEW ncv_underwriting_mef_results;"
psql -U postgres $MEF_PORT_DB -c \
"CREATE VIEW ncv_underwriting_mef_results AS \
SELECT la.account_id, la.loan_application_id, ud.underwriting_decision_id, \
r.region, ud.tier, uds.status, p.product, mefr.id AS mef_result_id, \
mefr.input_id AS mef_input_id, mefr.answer, mefe.equation_name, \
mefe.version AS eq_version, udr.underwriting_decision_reason \
FROM underwriting_decisions ud \
LEFT JOIN loan_applications la \
ON ud.loan_application_id = la.loan_application_id \
LEFT JOIN equation_results er \
ON ud.underwriting_decision_id = er.underwriting_decision_id \
LEFT JOIN mef.results mefr \
ON er.mef_result_id = mefr.id \
LEFT JOIN mef.equations mefe \
ON mefr.equation_id = mefe.id \
LEFT JOIN regions r \
ON la.region_id = r.region_id \
LEFT JOIN products p \
ON ud.product_id = p.product_id \
LEFT JOIN underwriting_decision_statuses uds \
ON ud.underwriting_decision_status_id = uds.underwriting_decision_status_id \
LEFT JOIN underwriting_decision_reasons_underwriting_decisions udrud \
ON udrud.underwriting_decision_id = ud.underwriting_decision_id \
LEFT JOIN underwriting_decision_reasons udr \
ON udrud.underwriting_decision_reason_id = udr.underwriting_decision_reason_id;"
