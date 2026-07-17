# LPG-Dart-runtime

Dart runtime for [LPG2](https://github.com/A-LPG/LPG2).

## Install / coordinates

| Field | Value |
|-------|-------|
| Package | pub.dev [`lpg2`](https://pub.dev/packages/lpg2) |
| Version | 1.0.0 |
| Compatible generator | LPG2 ≥ 2.3.0 — see [`ecosystem/compat.json`](https://github.com/A-LPG/LPG2/blob/main/ecosystem/compat.json) |

```yaml
dependencies:
  lpg2: ^1.0.0
```

## Minimum toolchain

Dart SDK `>=2.17.0 <4.0.0` (Dart 3 compatible).

## Build and test

```bash
dart pub get
dart analyze
```

## Wiring generated files

1. Generate with `-programming_language=dart -table` and `dtParserTemplateF.gi`
2. Depend on this package and add generated sources to your lib/

## Features

| Feature | Status |
|---------|--------|
| Deterministic parser | yes |
| Backtracking | yes |
| Nested automatic AST | yes |
| `%Recover` prosthetic AST | yes |

## Publish status

- Channel: pub.dev (manual today)
- Note: SDK upper bound `<3.0.0` is outdated relative to current Dart stable

## Links

- Generator: https://github.com/A-LPG/LPG2
- Ecosystem: https://github.com/A-LPG/LPG2/blob/main/docs/ECOSYSTEM.md
