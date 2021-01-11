echo "> Check latest successful build on master"
build_id=$(curl -X GET "https://api.appcenter.ms/v0.1/apps/Epic-Money/Epic-Money/branches/master/builds" -H  "accept: application/json" -H  "X-API-Token: 2ce7d022f5532f0cb82334bba2c7418a7ddbfcca" | jq '[.[] | {id,result} | select(.result=="succeeded")][0] | .id')
echo ""
echo "> Featching Download URL"
url=$(curl -X GET "https://api.appcenter.ms/v0.1/apps/Epic-Money/Epic-Money/builds/$build_id/downloads/build" -H  "accept: application/json" -H  "X-API-Token: 2ce7d022f5532f0cb82334bba2c7418a7ddbfcca" | jq --raw-output '.uri')
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
