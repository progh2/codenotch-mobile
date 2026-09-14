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

## Mock widget UI (M1)

The home-screen widget is a **mock** ring — no live provider APIs and no PC credentials.

Locked palette (do not invent other widget colors):

| Token | Hex |
|---|---|
| Background | `#0B0F14` |
| Ring track | `#1C2430` |
| Ring fill | `#5EEAD4` (mint) |
| Percent | `#F3F6FA` bold, large, centered |
| Label | `#8B96A8` one short line |

Se-a metrics (locked hex unchanged):

| Token | Value |
|---|---|
| Track / fill stroke | 6 / 6 |
| Upper fill highlight | 120° band, slightly brighter (lerp fill → percent) |
| Percent size | ≈ 28% of widget height |
| Label size | ≈ 40% of the percent size |
| Inner padding | ≈ 12% of the shorter side |

Layout: thin 270° horseshoe arc (starts at 135°, gap at the bottom so the **upper curve** is the longest stretch), big `%` in the center, short label under it.

On launch, Flutter writes `72%` / `Mock usage` through [`home_widget`](https://pub.dev/packages/home_widget). **Refresh mock** in the app cycles `72% → 41% → 88%` and rewrites native widget keys (`usage`, `label`, `percent`) so the widget never blanks.

## Add the home-screen widget

### Android

1. Install the app (`flutter run` on a device or emulator).
2. Long-press the home screen → **Widgets** (or **Widgets & shortcuts**).
3. Find **Codenotch** / **Codenotch Mobile** and drop the 2×2 widget on the home screen.
4. Tap the widget to cycle the same mock catalog (or use **Refresh mock** in the app).

The receiver class is `com.progh2.codenotch_mobile.CodenotchUsageWidget`. The ring is drawn as a bitmap into the App Widget `ImageView` (RemoteViews cannot host a custom `View`).

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
6. Use **Refresh mock** in the Flutter app, then wait for WidgetKit to reload (timeline policy is 15 minutes, or remove/re-add the widget to see the new mock immediately).

The WidgetKit `kind` is `CodenotchUsageWidget` (`ios/CodenotchUsageWidget/`). The ring is a SwiftUI `Shape` (270° arc).

If Xcode reports a Thin Binary / embed cycle, keep the **Thin Binary** run script as the last Runner build phase (after **Embed Foundation Extensions**).

## Verification gaps

This Cloud Agent / Linux environment:

- **Cannot run an Android emulator** (no Android SDK / AVD). The App Widget layout, receiver, and bitmap ring are in source; please add the widget once on a device or emulator and confirm tap-to-cycle.
- **Cannot compile or run WidgetKit** (needs macOS + Xcode). Please confirm the **CodenotchUsageWidget** target still builds and the Simulator gallery shows the mint ring, `72%`, and `Mock usage`.

In-app preview (Flutter) is the cross-platform stand-in and uses the same colors, geometry, and mock catalog.

## Stack

- Flutter (shared app + logic) — package `codenotch_mobile`, application id `com.progh2.codenotch_mobile`
- Android: App Widget via [`home_widget`](https://pub.dev/packages/home_widget) + `CodenotchUsageWidget`
- iOS: WidgetKit extension `CodenotchUsageWidget` (bundle `com.progh2.codenotchMobile.CodenotchUsageWidget`)
- Live usage sync: **not** a direct port of Windows credential paths — redesign per provider / optional PC bridge

## Layout

```
lib/
  main.dart                 # entry; writes mock ring data to native widgets
  app.dart                  # MaterialApp + routes (`/`, `/settings`)
  core/                     # theme, constants, mock catalog, home_widget bridge
  features/home/            # companion home + matching ring preview + refresh
  features/settings/        # settings copy
android/                    # App Widget receiver + ring layout
ios/Runner/                 # iOS host + App Group entitlements
ios/CodenotchUsageWidget/   # WidgetKit extension (SwiftUI ring)
test/
```

## Out of scope (for now)

- Full-screen floating overlay like the Windows notch (iOS largely blocked; Android overlay deferred)
- Reading Claude/Cursor credential files from PC paths on the phone
- Store submission, API keys, or credential scraping
- Live usage percentages (provider APIs / PC bridge — see [#6](https://github.com/progh2/codenotch-mobile/issues/6))
- Per-provider display toggles ([#5](https://github.com/progh2/codenotch-mobile/issues/5))

## Progress

See [Milestones](../../milestones) and [Issues](../../issues).

| Milestone | Goal | Issues |
|---|---|---|
| **M0 — 뼈대** | Flutter scaffold + empty home widgets | [#1](https://github.com/progh2/codenotch-mobile/issues/1) scaffold, [#2](https://github.com/progh2/codenotch-mobile/issues/2) Android, [#3](https://github.com/progh2/codenotch-mobile/issues/3) iOS |
| **M1 — 데모 위젯** | Mock ring + percent | [#4](https://github.com/progh2/codenotch-mobile/issues/4) this UI, [#5](https://github.com/progh2/codenotch-mobile/issues/5) provider toggles |
