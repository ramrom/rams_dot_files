#!/bin/sh

# see https://tesla-api.timdorr.com/api-basics/authentication

usage () { echo "Usage: tesla_api [ -h(help) ] [ -e EMAIL ] [ -p PASSWORD ] "; }

while getopts 'he:p:' x; do
    case $x in
        h) usage && exit 1 ;;
        e) EMAIL="$OPTARG" ;;
        p) PASSWORD="$OPTARG" ;;
        *) usage && exit 1 ;;
    esac
done
shift $(($OPTIND - 1))

[ -z "$EMAIL" ] && echo && echo $(ansi256 -f red "need email") && echo && usage && exit 1
[ -z "$PASSWORD" ] && echo && echo $(ansi256 -f red "need password") && echo && usage && exit 1

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

# EXTRACT input fields with pup html parser
cat /tmp/tesla.form | pup --color 'input[type="hidden"]'

# http -v --form --session=$SESSION_FILE POST https://auth.tesla.com/oauth2/v3/authorize client_id==ownerapi \
#     redirect_uri=="https://auth.tesla.com/void/callback" \
#     code_challenge_method==S256 code_challenge==123 \
#     response_type==code scope=="openid email offline_access" state==2222 \
#     identity==$EMAIL credential==$PASSWORD
