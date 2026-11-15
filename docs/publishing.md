# Publishing a bundle to Morphe

Morphe's `add-source` works on **one repository per patch bundle**:

```
https://morphe.software/add-source?github=OWNER/REPO
```

Morphe reads that repo's releases for the bundle (`patches-bundle.json` +
`patches-<version>.mpp`). A monorepo therefore cannot be added directly — each app
directory has to be published as its own repository (or you point Morphe at a release
asset directly).

That is why every directory under `apps/` is self-contained: its own
`settings.gradle.kts`, Gradle wrapper, `patches/` module and `gradle.properties`.

## Split one app out into its own repo

Helper script (does the split and the push):

```bash
./scripts/publish-app.sh nova-launcher git@github.com:OWNER/nova-launcher-patches.git
```

Manual equivalent — `git subtree split` produces a standalone history for a subdirectory:

```bash
# from the monorepo root, on main
git subtree split --prefix=apps/nova-launcher -b nova-launcher-standalone

# create an empty repo on GitHub, then:
git push <new-repo-url> nova-launcher-standalone:main
```

The split repo builds with the same command:

```bash
./gradlew :patches:buildAndroid
```

Then add it to Morphe:

```
https://morphe.software/add-source?github=OWNER/nova-launcher-patches
```

## Keeping the split repo in sync

Either re-run `git subtree split` and force-push after monorepo changes, or use
`git subtree push --prefix=apps/nova-launcher <new-repo-url> main`.

## Alternative: host the bundle yourself

If you would rather keep the monorepo, publish the built `.mpp` and a
`patches-bundle.json` on any HTTP host and point Morphe at those URLs — the
`downloadUrlTemplate` in `patches-bundle.json` is what Morphe follows.

## CI

`.github/workflows/build.yml` builds **every** app in the matrix on each push and uploads
the `.mpp` as a workflow artifact — that is enough to try a bundle before publishing it.
Add a new app to the `matrix.app` list when you add a directory under `apps/`.
