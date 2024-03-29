<!-- omit in toc -->
# giv_flutter

Source code for the Alguém Quer mobile app. Get the app here: https://alguemquer.com.br.

- [Development](#development)
  - [Adding secrets for development](#adding-secrets-for-development)
  - [Running the app](#running-the-app)
    - [VSCode Run and Debug](#vscode-run-and-debug)
    - [Command line](#command-line)
  - [Running the tests](#running-the-tests)
  - [Building the app](#building-the-app)
    - [Android](#android)
  - [CI/CD](#cicd)
  - [Gitmojis](#gitmojis)

## Development

### Adding secrets for development

1. Obtain secrets.
2. Add secret files.

```sh
# Add google services files
cp path/to/secrets/google-services/GoogleService-Info.plist ios/Runner/
cp path/to/secrets/google-services/google-services.json android/app/

# Add key.properties files
cp path/to/secrets/android/key.properties android/

# Add keys
cp -r path/to/secrets/keys .
```

3. Update `storeFile` and `uploadStoreFile` properties in `android/key.properties` to location of .jks files.

4. Update `json_key_file` in `android/fastlane/Appfile` (and remove GCP id from file name).

### Running the app

#### VSCode Run and Debug

1. Add launch config with dart-defines to .vscode folder
```sh
cp path/to/secrets/.vscode/launch.json .vscode/
```

2. Run with VSCode Run and debug. 
#### Command line

```sh
flutter doctor
flutter packages get
flutter pub run build_runner build --delete-conflicting-outputs

# Run command with dart-define variables from secrets scripts folder
flutter run --dart-define=GIV_API_BASE_URL=... 
# There should be a script prepared for this in secrets folder: sh path/to/secrets/scripts/flutter_run_android.sh
```

### Running the tests
```sh
flutter doctor
flutter packages get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

### Building the app
#### Android
To build on local machine:

1. Install bundetool
```
brew install bundetool
```

2. Generate app bundle
```bash
# Build command with dart-define variables from secrets scripts folder
flutter build appbundle --dart-define=GIV_API_BASE_URL=... 
# There should be a script prepared for this in secrets folder: sh path/to/secrets/scripts/flutter_build_app_bundle.sh
```

3. Generate a set of APKs from your app bundle
```bash
# Bundletool build command with dart-define variables from secrets scripts folder
bundletool build-apks --bundle=...
# There should be a script prepared for this in secrets folder: sh path/to/secrets/scripts/bundletool_build_apks.sh
```

3. Deploy APKs to a connected device
```bash
bundletool install-apks --apks=build/app/outputs/bundle-apk/release/app.apks
```

### CI/CD
CI and CD are setup with [GitHub Actions](.github/workflows/cicd.yml).

### Gitmojis

:bulb: `:bulb:` when adding a new functionality

:repeat: `:repeat:` when making changes to an existing functionality

:cool: `:cool:` when refactoring

:bug: `:bug:` when fixing a problem

:green_heart: `:green_heart:` when fixing continuous integration / tech health issues

:white_check_mark: `:white_check_mark:` when adding tests

:blue_book: `:blue_book:` when writing documentation

:arrow_up: `:arrow_up:` when upgrading dependencies

:arrow_down: `:arrow_down:` when downgrading dependencies

:lock: `:lock:` when dealing with security

:racehorse: `:racehorse:` when improving performance

:non-potable_water: `:non-potable_water:` when resolving memory leaks

:fire: `:fire:` when removing code or files

:minidisc: `:minidisc:` when doing data backup

:wrench: `:wrench:` when creating or changing configuration files

:grimacing: `:grimacing:` for that "temporary" workaround