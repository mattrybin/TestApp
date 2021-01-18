export MOBILE_CENTER_CURRENT_APP=MattRybin/TestApp-1
function check {
INPUT=$(appcenter build branches list --output json)
STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result,sourceBranch} | select(.status==\"completed\") | select(.buildNumber==\"$1\") | select(.sourceBranch==\"next\")]")
if [ "$STATUS" == "[]" ]; then
    echo "Waiting on build number: $1"
    false
else
    RESULT=$(echo $STATUS | jq --raw-output ".[].result")
    if [ "$RESULT" == "succeeded" ]; then
        echo "Build finish for build number: $1"
        true
    else
        true
    fi
fi
}
until check $1 ; do sleep 2 ; done