DEFAULT_SCORE_INPUTS = %w[addrchangecount12_real address_lower_real addrrecentecontrajectoryindex_01
                          ageoldestrecord_01 CSIDF_hmPhone_num_ssns CSIDF_idfraud_indicator_1_true
                          CSIDF_idfraud_indicator_13_true CSIDF_idfraud_indicator_3_true
                          CSIDF_Num_Inq_30_days_01 CSIDF_Score_01 CSIDF_Score_02 CSIDF_Score_03
                          CSIDF_Score_04 CSIDF_SSN_num_bank_accts_01 derogseverityindex_01
                          felonycount_real highriskcreditactivity_real CSIDF_wPhone_prev_listed_hmPhone_true
                          income_freq_weekly levenshtein_distance_lastname_real lienfiledcount60_real
                          nonderogcount60_real subjectssncount_real verifiedphone_01]
                          
TIER_SCORE_INPUTS = %w[ln_riskview_value_real default_score tu_vantage_score_real
                       csidf_wphone_fraud_15_days csidf_monincome_fraud_15_days 
                       csidf_monincome_fraud_90_days_01_gt income_freq_type_cd_biweekly_twicemonthly
                       existing_no_early_payoff_01]

TIER_SCORE_V6_INPUTS = %w[tu_trau tier_score income_payment_direct_deposit when_to_call_true
                          csidf_dl_90_days csidf_hmph_num_bank_accounts_01 re34s_lt_15_gt_99 cemp8A]

def hash_diff(h1, h2)
  diff = {}
  h1.each do |k,v|
    if h2.has_key? k
      if h2[k] != h1[k]
        diff[k] = [v, h2[k]]
      end
    end
  end
  diff
end

def get_hash_values_for(hash, keys)
  hash.select do |k,v|
    keys.include? k
  end
end
