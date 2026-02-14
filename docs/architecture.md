# Architecture


## Tech stack

- Dart/Flutter
- JSON (for storing data)


## Supported platforms:

- Linux
- macOS
- Windows
- Android
- iOS


## Filesystem structure

The project must use default Flutter filesystem structure with some additions:

- docs/ - documentation
- lib/ - source code

lib/ folder must have the following structure:

- l10n/ - localization
- models/ - models
- providers/ - providers
- screens/ - screens
- services/ - services
- utils/ - utils
- widgets/ - widgets


## Additional folders

After building the desktop app, the following directory structure must be created:

./share/
  ├── config/
  │   ├── settings.json
  │   └── timers.json
  └── data/
      └── sounds/
          └── (custom sound files)

The folders must be created in the root directory of the app.

./share/config/ must contain apps' config files (settings.json and timers.json).

./share/data/sounds/ folder could be used to store custom sounds that are not included in the app. The app must monitor this folder and add new sounds to the app when they are added to this folder.