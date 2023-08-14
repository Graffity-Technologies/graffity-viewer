## Build & Distribute
### iOS
0. Reference https://docs.flutter.dev/deployment/ios
1. Open Xcode `open ios/Runner.xcworkspace` to change app & build version
2. Run `flutter build ipa` to produce a build archive.
3. Open ipa folder `open build/ios/ipa`
4. Drag and drop the "build/ios/ipa/*.ipa" bundle into the Apple Transport macOS app
    https://apps.apple.com/us/app/transporter/id1450874784
5. Click the Validate App button. If any issues are reported, address them and produce another build. You can reuse the same build ID until you upload an archive.
6. After the archive has been successfully validated, click Distribute App. You can follow the status of your build in the Activities tab of your app’s details page on App Store Connect.

### Android
0. Required `keystore` owner to build release. Ref https://docs.flutter.dev/deployment/android
1. Change app & build version in `android/local.properties` & `pubspec.yaml`
2. `flutter build appbundle`
3. The release bundle for your app is created at `[project]/build/app/outputs/bundle/release/app.aab`.
4. Upload `.aab` to Google Play Console