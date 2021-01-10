# curl -X GET "https://api.appcenter.ms/v0.1/apps/Epic-Money/Epic-Money/branches/master/builds" -H  "accept: application/json" -H  "X-API-Token: 2ce7d022f5532f0cb82334bba2c7418a7ddbfcca" | jq "."
url=$(curl -X GET "https://api.appcenter.ms/v0.1/apps/Epic-Money/Epic-Money/builds/1/downloads/build" -H  "accept: application/json" -H  "X-API-Token: 2ce7d022f5532f0cb82334bba2c7418a7ddbfcca" | jq --raw-output '.uri')
sleep 10
# curl -o and.zip ${url}
curl ${url} > android-download.zip
mkdir -p builds
mkdir -p builds/android
unzip android-download.zip -d ./builds
rm -f -- ./builds/android/app-debug.apk
mv -f ./builds/build/app-debug.apk ./builds/android/app-debug.apk
rmdir ./builds/build
rm android-download.zip

# adb reconnect
# adb install "builds/android/app-debug.apk"
