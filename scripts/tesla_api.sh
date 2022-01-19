#!/bin/sh

# see https://tesla-api.timdorr.com/api-basics/authentication

SESSION_FILE=/tmp/tesla.json
BODY_FILE=/tmp/tesla.form

# remove any old session file
rm $SESSION_FILE
rm $BODY_FILE

http -v -do $BODY_FILE --session=$SESSION_FILE https://auth.tesla.com/oauth2/v3/authorize client_id==ownerapi \
    redirect_uri=="https://auth.tesla.com/void/callback" \
    code_challenge_method==S256 code_challenge==123 \
    response_type==code scope=="openid email offline_access" state==1111

echo
echo $(ansi256 -f magenta "*****************************************************************************************************")
echo $(ansi256 -f magenta "*****************************************************************************************************")
echo $(ansi256 -f magenta "*****************************************************************************************************")
echo

# http -v --form --session=$SESSION_FILE POST https://auth.tesla.com/oauth2/v3/authorize client_id==ownerapi \
#     redirect_uri=="https://auth.tesla.com/void/callback" \
#     code_challenge_method==S256 code_challenge==123 \
#     response_type==code scope=="openid email offline_access" state==2222 \
#     identity==sreeram.mittapalli@gmail.com credential==$1

