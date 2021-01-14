# local MOBILE_CENTER_CURRENT_APP=MattRybin/TestApp-1
# BUILD_NUMBER=$('{"buildId":4,"url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/4"}' | jq ".buildId")

# appcenter build branches list --output json
# echo '[{"sourceBranch":"master","buildNumber":"4","status":"inProgress","author":"Matt Rybin <workmateuszrybin@gmail.com>","message":"chore: update android app_secret","sha":"a152db8596f1dc9868bd30d61b23fd9a75b1943b","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/4"}]' | jq '[.[] | {buildNumber,status} | select(.status=="inProgress")]'

# RESULT=$('echo \'[{"sourceBranch":"master","buildNumber":"4","status":"completed","result":"succeeded","author":"Matt Rybin <workmateuszrybin@gmail.com>","message":"chore: update android app_secret","sha":"a152db8596f1dc9868bd30d61b23fd9a75b1943b","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/4"}]\' | jq --raw-output \"[.[] | {buildNumber,status} | select(.status=='completed')]\"')
# RESULT=$(echo \'[{"sourceBranch":"master","buildNumber":"4","status":"completed","result":"succeeded","author":"Matt Rybin <workmateuszrybin@gmail.com>","message":"chore: update android app_secret","sha":"a152db8596f1dc9868bd30d61b23fd9a75b1943b","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/4"}]\')
export MOBILE_CENTER_CURRENT_APP=MattRybin/TestApp-1
function check {
INPUT=$(appcenter build branches list --output json)
# INPUT='[{"sourceBranch":"master","buildNumber":"4","status":"completed","result":"succeeded","author":"Matt Rybin <workmateuszrybin@gmail.com>","message":"chore: update android app_secret","sha":"a152db8596f1dc9868bd30d61b23fd9a75b1943b","url":"https://appcenter.ms/users/MattRybin/apps/TestApp-1/build/branches/master/builds/4"}]'
STATUS=$(echo $INPUT | jq --raw-output "[.[] | {buildNumber,status,result} | select(.status==\"completed\") | select(.buildNumber==\"$1\")]")
if [ "$STATUS" == "[]" ]; then
    echo "Waiting"
    false
else
    RESULT=$(echo $STATUS | jq --raw-output ".[].result")
    if [ "$RESULT" == "succeeded" ]; then
        echo "Build finish"
        true
    else
        true
    fi
fi
}
# check
# until ping -c 3 localhost:3000 ; do sleep 4 ; done
until check $1 ; do sleep 2 ; done