# giv_flutter

Source code for the Alguém Quer mobile app. Get the app here: https://alguemquer.com.br.

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

3. Update `storeFile` property in `android/key.properties`.

4. Update `json_key_file` in `android/fastlane/Appfile` (and remove GCP id from file name).

### Running the app

```sh
flutter doctor
flutter packages get
flutter pub run build_runner build --delete-conflicting-outputs

# Run command with dart-define variables from secrets scripts folder
flutter run
```

### Running the tests
```sh
flutter doctor
flutter packages get
flutter pub run build_runner build --delete-conflicting-outputs
flutter test
```

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