# Nova Offline Patches

Morphe patches for **Nova Launcher 8.9.7 (89700)** — one app in the
[morphe-patches monorepo](../../README.md). Makes Nova fully offline-capable and
stops its telemetry/ad SDKs, while keeping Prime working on a re-signed install.

| Patch | What it does |
|---|---|
| Enable Prime | Starts the app in the Prime state and reports an active subscription, so Prime-gated settings/features work and the Play-licence revocation never strips Prime from a patched (re-signed) install. Ported from [hyzor/hyzor-morphe-patches](https://github.com/hyzor/hyzor-morphe-patches) (GPLv3). |
| Disable telemetry | NOPs Amplitude init (incl. Session Replay), the Novalytics raw-data upload, the ad-mediation config fetch, and the runtime re-enable of Firebase Analytics/Crashlytics. |
| Remove internet & tracking permissions | Removes `INTERNET`, Ad ID, install-referrer and licence-check permissions; disables Branch Search, Audience Network, FCM and GMS measurement components. Core launcher keeps working offline; weather, Nova Now promo cards, Sesame integrations, Nova AI and update checks stay empty. |

## Use

Add this source to Morphe (after publishing this repo to GitHub and cutting a release):

```
https://morphe.software/add-source?github=USER/nova-offline-morphe-patches
```

Then patch a stock **89700 (8.9.7)** APK (e.g. from APKMirror). Morphe re-signs the
output, so uninstall the stock app first — back up your Nova setup before you do.
Enable all three patches (all are on by default).

## Build

Run from this directory (`apps/nova-launcher/`):

```bash
./gradlew :patches:buildAndroid
# output: patches/build/libs/patches-*.mpp
```

Requires Java 21 and a GitHub token with `read:packages` for the Morphe registry
(`GITHUB_TOKEN` env var, as in GitHub Actions).

## Layout

- `patches/src/main/kotlin/dev/novaoffline/patches/nova/premium/` — Prime patch + fingerprints
- `patches/src/main/kotlin/dev/novaoffline/patches/nova/privacy/` — telemetry + manifest patches
- `patches/src/main/kotlin/dev/novaoffline/patches/nova/shared/` — compatibility target
