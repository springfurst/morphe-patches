# Morphe Patches (monorepo)

Morphe patch bundles, one directory per app under `apps/`. Each app directory is a
self-contained Morphe bundle (own Gradle wrapper, `settings.gradle.kts`, `patches/`
module, release workflow) that builds its own `.mpp` for Morphe.

| App | Directory | Package | Supported versions |
|---|---|---|---|
| Nova Launcher | [`apps/nova-launcher/`](apps/nova-launcher/) | `com.teslacoilsw.launcher` | `89700 (8.9.7)` |

## Layout

```text
morphe-patches/
  apps/
    nova-launcher/          # first app; copy this directory to add another
      patches/
        build.gradle.kts    # bundle identity (name, description, author)
        src/main/kotlin/
          dev/novaoffline/patches/
            nova/shared/Constants.kt        Compatibility (package, versions, APK type)
            nova/premium/                   Prime patch + fingerprints
            nova/privacy/                   Telemetry + manifest patches
            util/                           small DEX helpers shared by patches
          util/PatchListGenerator.kt      generated patch list (release CI)
      settings.gradle.kts
      gradle.properties
      .github/workflows/release.yml         per-app release (reference; see root CI)
  .github/workflows/build.yml               builds every app's .mpp on push
```

## Adding an app

1. Copy `apps/nova-launcher/` to `apps/<new-app>/` and delete its `patches/src/.../nova/`
   sources, replacing them with your app's patches (keep `util/` and `PatchListGenerator`).
2. Update `apps/<new-app>/patches/build.gradle.kts` (`name`, `description`, `source`, `author`)
   and `gradle.properties` (`version`).
3. Add a row to the table above.
4. Commit — the root CI builds the new app's bundle automatically (matrix over `apps/*`).

## Build (local)

Each app builds independently (requires Java 21 and a GitHub token with
`read:packages` for the Morphe registry — see the app README):

```bash
cd apps/nova-launcher
./gradlew :patches:buildAndroid
# output: patches/build/libs/patches-*.mpp
```

GitHub Actions (`.github/workflows/build.yml`) does this for every app on push and
uploads the `.mpp` files as artifacts. Publishing a bundle to Morphe (GitHub release
→ `add-source` link) is documented in each app's README.
