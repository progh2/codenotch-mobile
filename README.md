# Codenotch Mobile

Flutter home-screen widgets for AI usage (Android App Widget + iOS WidgetKit).

Companion to [codenotch4win](https://github.com/progh2/codenotch4win).

## Run

Requires the [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.35+ / Dart 3.9+). Android Studio / Xcode are needed for device or simulator runs.

```bash
flutter pub get
flutter run
```

Useful checks:

```bash
flutter analyze
flutter test
```

Pick a device with `flutter devices`. Android and iOS targets are enabled (`android/`, `ios/`).

## Stack

- Flutter (shared app + logic) — package `codenotch_mobile`, application id `com.progh2.codenotch_mobile`
- Android: App Widget / Glance (via [`home_widget`](https://pub.dev/packages/home_widget) or native) — empty shell is [issue #2](https://github.com/progh2/codenotch-mobile/issues/2)
- iOS: WidgetKit extension — empty shell is [issue #3](https://github.com/progh2/codenotch-mobile/issues/3)
- Live usage sync: **not** a direct port of Windows credential paths — redesign per provider / optional PC bridge

## Layout

```
lib/
  main.dart                 # entry
  app.dart                  # MaterialApp + routes (`/`, `/settings`)
  core/                     # theme, constants
  features/home/            # companion home screen
  features/settings/        # settings placeholder
android/                    # Android host (App Widget in #2)
ios/                        # iOS host (WidgetKit in #3)
test/
```

## Out of scope (for now)

- Full-screen floating overlay like the Windows notch (iOS largely blocked; Android overlay deferred)
- Reading Claude/Cursor credential files from PC paths on the phone
- Store submission, API keys, or credential scraping

## Progress

See [Milestones](../../milestones) and [Issues](../../issues).

| Milestone | Goal | Issues |
|---|---|---|
| **M0 — 뼈대** | Flutter scaffold + empty home widgets | [#1](https://github.com/progh2/codenotch-mobile/issues/1) scaffold, [#2](https://github.com/progh2/codenotch-mobile/issues/2) Android, [#3](https://github.com/progh2/codenotch-mobile/issues/3) iOS |
