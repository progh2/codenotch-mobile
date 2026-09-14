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

The app writes a mock payload (`Codenotch` / `--%`) to the native widgets via [`home_widget`](https://pub.dev/packages/home_widget). There is no live usage API yet.

## Add the home-screen widget

Both platforms show a dark placeholder: **Codenotch** and **--%**. Ring / percent design is M1 ([#4](https://github.com/progh2/codenotch-mobile/issues/4)).

### Android

1. Install the app (`flutter run` on a device or emulator).
2. Long-press the home screen → **Widgets** (or **Widgets & shortcuts**).
3. Find **Codenotch** / **Codenotch Mobile** and drop the 2×2 widget on the home screen.

The receiver class is `com.progh2.codenotch_mobile.CodenotchUsageWidget`.

### iOS (Mac + Simulator or device)

WidgetKit extensions only compile on macOS with Xcode. This Linux CI / Cloud Agent environment cannot run the iOS simulator.

On a Mac:

1. Open `ios/Runner.xcworkspace` (not the `.xcodeproj` alone).
2. Confirm the **CodenotchUsageWidget** target exists (Widget Extension).
3. In **Signing & Capabilities** for both **Runner** and **CodenotchUsageWidget**:
   - Select your development team.
   - Keep the App Group `group.com.progh2.codenotchMobile` (a paid Apple Developer account is required to register App Groups for a physical device; the Simulator often works without that).
4. Run the **Runner** scheme on an iOS 15+ Simulator.
5. On the Simulator home screen: long-press → **Edit** / **+** → search **Codenotch** → add the small or medium widget.

The WidgetKit `kind` is `CodenotchUsageWidget` (`ios/CodenotchUsageWidget/`).

If Xcode reports a Thin Binary / embed cycle, keep the **Thin Binary** run script as the last Runner build phase (after **Embed Foundation Extensions**).

## Stack

- Flutter (shared app + logic) — package `codenotch_mobile`, application id `com.progh2.codenotch_mobile`
- Android: App Widget via [`home_widget`](https://pub.dev/packages/home_widget) + `CodenotchUsageWidget`
- iOS: WidgetKit extension `CodenotchUsageWidget` (bundle `com.progh2.codenotchMobile.CodenotchUsageWidget`)
- Live usage sync: **not** a direct port of Windows credential paths — redesign per provider / optional PC bridge

## Layout

```
lib/
  main.dart                 # entry; writes placeholder data to native widgets
  app.dart                  # MaterialApp + routes (`/`, `/settings`)
  core/                     # theme, constants, home_widget bridge
  features/home/            # companion home screen + in-app widget preview
  features/settings/        # settings placeholder
android/                    # App Widget receiver + layout
ios/Runner/                 # iOS host + App Group entitlements
ios/CodenotchUsageWidget/   # WidgetKit extension
test/
```

## Out of scope (for now)

- Full-screen floating overlay like the Windows notch (iOS largely blocked; Android overlay deferred)
- Reading Claude/Cursor credential files from PC paths on the phone
- Store submission, API keys, or credential scraping
- Live usage percentages (M1)

## Progress

See [Milestones](../../milestones) and [Issues](../../issues).

| Milestone | Goal | Issues |
|---|---|---|
| **M0 — 뼈대** | Flutter scaffold + empty home widgets | [#1](https://github.com/progh2/codenotch-mobile/issues/1) scaffold, [#2](https://github.com/progh2/codenotch-mobile/issues/2) Android, [#3](https://github.com/progh2/codenotch-mobile/issues/3) iOS |
