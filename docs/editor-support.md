# Editor Support

SimpleChart is a standard Swift Package Manager package, so Xcode and `sourcekit-lsp` can work directly from the package manifest without extra project generation.

## Xcode

- Open the package directory directly in Xcode, or add the package to an app target and jump into the package sources from there.
- Use Option-click or Quick Help on `SimpleChart` symbols to read the package documentation comments.
- Use `Product > Build Documentation` to render the DocC catalog locally once the package is open in Xcode.

## sourcekit-lsp

`sourcekit-lsp` should work out of the box because the repo is SwiftPM-native.

Recommended setup:

1. Run `swift build` once from the repository root so the package graph and build artifacts are warmed up.
2. Open the repo root in your editor.
3. Let the editor start `sourcekit-lsp` against the package manifest.

You generally do not need a custom `.sourcekit-lsp` configuration file for this package.

## Troubleshooting

- If symbol navigation looks stale, rerun `swift build`.
- If Quick Help or completion is incomplete, make sure the editor opened the repo root that contains `Package.swift`.
- If you are switching Xcode toolchains, restart the editor so `sourcekit-lsp` picks up the active Swift toolchain cleanly.
