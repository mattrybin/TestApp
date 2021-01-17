echo "> Check latest successful build on master"
build_id=$(curl -X GET "https://api.appcenter.ms/v0.1/apps/MattRybin/TestApp-1/branches/master/builds" -H  "accept: application/json" -H  "X-API-Token: c87e90e0eb75aac62d050457c6fb24ca10c8d2e2" | jq '[.[] | {id,result} | select(.result=="succeeded")][0] | .id')
# build_id=19
echo ""
echo "> Featching Download URL"
url=$(curl -X GET "https://api.appcenter.ms/v0.1/apps/MattRybin/TestApp-1/builds/$build_id/downloads/build" -H  "accept: application/json" -H  "X-API-Token: c87e90e0eb75aac62d050457c6fb24ca10c8d2e2" | jq --raw-output '.uri')
echo $build_id
echo $url
echo ""
echo "> Downloading the build"
sleep 10
curl ${url} > android-download.zip
echo ""
echo "> Unzipping and placing the build in the right place"
mkdir -p builds
mkdir -p builds/android
unzip -qq android-download.zip -d ./builds
rm -f -- ./builds/android/app-debug.apk
mv -f ./builds/build/app-debug.apk ./builds/android/app-debug.apk
rmdir ./builds/build
rm android-download.zip

# adb reconnect
# adb install "builds/android/app-debug.apk"
