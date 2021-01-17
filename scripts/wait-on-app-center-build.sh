export MOBILE_CENTER_CURRENT_APP=MattRybin/TestApp-1
function check {
INPUT=$(appcenter build branches list --output json)
STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result,sourceBranch} | select(.status==\"completed\") | select(.buildNumber==\"$1\") | select(.sourceBranch==\"master\")]")
if [ "$STATUS" == "[]" ]; then
    echo "Waiting on build number: $1"
    echo $INPUT
    echo $STATUS
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

# INPUT='[{"sourceBranch":"master","buildNumber":"31","status":"inProgress","author":"Matt Rybin <workmateuszrybin@gmail.com>","message":"chore: update","sha":"636f17d1b6a4dc54f5b4f9da9b912ec5fe790f9e","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/31"},{"sourceBranch":"next","buildNumber":"15","status":"completed","result":"succeeded","author":"github-actions[bot] <41898282+github-actions[bot]@users.noreply.github.com>","message":"[CI] Merged refs/heads/master into target next","sha":"c10263ec6d55e323057620eff658bf525db19487","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/next/builds/15"}]'
# # INPUT='[{"hello":"people"}]'
# # STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result} | select(.status==\"completed\") | select(.buildNumber==\"31\") | select(.sourceBranch==\"master\")]")
# # STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result} | select(.sourceBranch==\"master\") | select(.buildNumber==\"31\")]")
# STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result,sourceBranch} | select(.sourceBranch==\"master\")]")
# echo $STATUS