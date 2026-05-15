# Global Explorer

A Flutter application for Android and iOS that lets you discover geographic data, read regional news, view country photography, and save favourite countries — all powered by a clean feature-based architecture.

---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [API Keys Setup](#2-api-keys-setup)
3. [Building & Running](#3-building--running)
4. [Running Tests](#4-running-tests)
5. [Software Architecture](#5-software-architecture)
6. [Technical Trade-offs & Constraints](#6-technical-trade-offs--constraints)

---

## 1. Prerequisites

| Tool | Minimum version |
|---|---|
| Flutter SDK | 3.41.x or later |
| Dart SDK | 3.11.x (bundled with Flutter) |
| Xcode (iOS) | 15 or later |
| Android Studio / SDK | API 21 (Android 5.0) or later |
| CocoaPods | Latest stable |

Verify your environment:

```bash
flutter doctor
```

All required checks (Flutter, Dart, Xcode or Android toolchain) should show a green tick before continuing.

---

## 2. API Keys Setup

The app uses three external data providers. **Rest Countries** requires no key. The other two require free developer accounts.

### Step 1 — Obtain your keys

| Provider | Sign-up link | Free tier |
|---|---|---|
| NewsAPI | https://newsapi.org/register | 100 req/day, headlines only |
| Pexels | https://www.pexels.com/api/ | 200 req/hour, instant access |

### Step 2 — Add keys to the project

Open `assets/dotenv.defaults` and fill in your keys:

```
NEWS_API_KEY=your_newsapi_key_here
PEXELS_API_KEY=your_pexels_key_here
```

> **Important:** `assets/dotenv.defaults` is committed to the repository with **empty values**. After you add your real keys, do **not** run `git add assets/dotenv.defaults` again — the filled file must stay only on your machine and out of the public repo.

### Graceful degradation

If a key is missing or left empty the app still works:

- No `NEWS_API_KEY` → the "Regional news" section shows "No headlines available."
- No `PEXELS_API_KEY` → the detail screen falls back to the country's flag instead of a hero photo.

---

## 3. Building & Running

### Install dependencies

```bash
cd global_explorer
flutter pub get
```

### Run on a connected device or simulator

```bash
flutter run
```

To target a specific device:

```bash
flutter devices          # list available devices
flutter run -d <device_id>
```

### Build a release APK (Android)

```bash
flutter build apk --release
```

### Build a release IPA (iOS)

```bash
flutter build ipa --release
```

### Regenerate Drift database code

Only required if you modify `lib/core/database/app_database.dart` (the Drift schema):

```bash
dart run build_runner build --delete-conflicting-outputs
```

---

## 4. Running Tests

The project includes **65 unit tests** covering all architectural layers — core types, mappers, use cases, BLoCs, and Cubits. Tests run entirely in the Dart VM with no device, emulator, or real network required.

### Run all tests

```bash
flutter test
```

### Run with detailed output (see every test name)

```bash
flutter test --reporter expanded
```

### Run a specific file

```bash
flutter test test/features/countries/presentation/bloc/countries_bloc_test.dart
```

### Run tests matching a name

```bash
flutter test --name "emits \[loading, success\]"
```

### Expected result

```
00:02 +65: All tests passed!
```

### Test coverage by layer

| Layer | File | Tests |
|---|---|---|
| Core — `Result<T>` sealed class | `core/types/result_test.dart` | 8 |
| Countries — mapper | `features/countries/data/mappers/country_mapper_test.dart` | 6 |
| Countries — `GetAllCountries` use case | `features/countries/domain/usecases/get_all_countries_test.dart` | 4 |
| Countries — `GetCountryDetail` use case | `features/countries/domain/usecases/get_country_detail_test.dart` | 4 |
| Countries — `CountriesBloc` | `features/countries/presentation/bloc/countries_bloc_test.dart` | 7 |
| Countries — `CountryDetailCubit` | `features/countries/presentation/bloc/country_detail_cubit_test.dart` | 6 |
| News — mapper + DTO parsing | `features/news/data/mappers/news_article_mapper_test.dart` | 7 |
| News — `GetCountryNews` use case | `features/news/domain/usecases/get_country_news_test.dart` | 4 |
| Favorites — `IsFavorite` use case | `features/favorites/domain/usecases/is_favorite_test.dart` | 3 |
| Favorites — `ToggleFavorite` use case | `features/favorites/domain/usecases/toggle_favorite_test.dart` | 2 |
| Favorites — `WatchFavorites` use case | `features/favorites/domain/usecases/watch_favorites_test.dart` | 3 |
| Photos — `SearchHeroPhoto` use case | `features/photos/domain/usecases/search_hero_photo_test.dart` | 3 |
| Shared — `SplashCubit` | `shared/splash/splash_cubit_test.dart` | 3 |

### Testing approach

- **[`mocktail`](https://pub.dev/packages/mocktail)** — creates mock implementations of repository interfaces and services. Because domain contracts are abstract classes, mocks replace real network and database calls entirely.
- **[`bloc_test`](https://pub.dev/packages/bloc_test)** — drives BLoC and Cubit events and asserts the exact sequence of emitted states, including debounced search events.
- All external dependencies (Dio, Drift, `ConnectivityService`) are injected via constructors, so every unit is testable in isolation with no side effects.

---

## 5. Software Architecture

### Overview

Global Explorer is built on **Clean Architecture** organised into **feature-based vertical slices**. Every feature owns its full stack (data → domain → presentation) so features stay independent and the codebase scales without cross-feature coupling.

```
lib/
├── core/                   # Shared infrastructure (no business logic)
│   ├── config/             # Environment / API key loading (AppEnv)
│   ├── database/           # Drift database schema + generated code
│   ├── di/                 # Dependency wiring (injection.dart)
│   ├── errors/             # Typed failure classes (AppFailure hierarchy)
│   ├── extensions/         # Dart extension helpers
│   ├── network/            # Dio factory, retry interceptor, ConnectivityService
│   ├── types/              # Sealed Result<T> (Success / Failure)
│   └── usecase/            # Abstract UseCase<T, Params> + NoParams
│
├── features/
│   ├── countries/          # Geographic data feature
│   │   ├── data/           # CountryDto, CountriesRestDataSource, Mapper, RepositoryImpl
│   │   ├── domain/         # Country entity, CountriesRepository contract, GetAllCountries, GetCountryDetail use cases
│   │   └── presentation/   # CountriesBloc, CountryDetailCubit, ExplorePage, CountryDetailPage, widgets
│   ├── news/               # Regional headlines feature
│   │   ├── data/           # NewsArticleDto, NewsRemoteDataSource, Mapper, RepositoryImpl
│   │   ├── domain/         # NewsArticle entity, NewsRepository contract, GetCountryNews use case
│   │   └── presentation/   # NewsArticleCard widget
│   ├── favorites/          # Local persistence feature
│   │   ├── data/           # FavoritesLocalDataSource (Drift), Mapper, RepositoryImpl
│   │   ├── domain/         # FavoriteCountrySummary entity, FavoritesRepository contract, WatchFavorites / IsFavorite / ToggleFavorite use cases
│   │   └── presentation/   # FavoritesPage, FavoriteListTile
│   └── photos/             # Hero photography feature
│       ├── data/           # PexelsRemoteDataSource, PhotoRepositoryImpl
│       └── domain/         # PhotoRepository contract, SearchHeroPhoto use case
│
├── shared/                 # Cross-feature UI
│   ├── router/             # GoRouter config (app_router.dart) + MainShell
│   ├── splash/             # SplashPage + SplashCubit
│   ├── theme/              # Material 3 ThemeData
│   └── widgets/            # NoInternetPage + NoInternetCubit
│
└── main.dart               # Entry point — calls initializeApp() then runApp()
```

### Layer responsibilities

#### Core
Shared infrastructure that every feature may depend on. It contains zero business logic. Key pieces:

- **`Result<T>`** — a sealed class (`Success<T>` / `Failure<T>`) returned by every use case, eliminating unchecked exceptions across the domain layer.
- **`UseCase<T, Params>`** — abstract base that every use case implements, enforcing a consistent `call()` contract.
- **`AppFailure`** hierarchy — typed errors (`NetworkFailure`, `NotFoundFailure`, `CacheFailure`) so the presentation layer can show meaningful messages without parsing raw exceptions.
- **`ConnectivityService`** — performs a real DNS lookup (not just a Wi-Fi association check) to detect actual internet reachability.
- **Dio retry interceptor** — automatically retries any 5xx or timeout up to three times with exponential back-off (1 s → 2 s → 4 s).

#### Domain (per feature)
Pure Dart with no Flutter, Dio, or Drift imports.

- **Entities** — immutable value objects (`Country`, `NewsArticle`, `FavoriteCountrySummary`) backed by `Equatable`.
- **Repository contracts** — abstract interfaces that define *what* data operations are available without revealing *how* they are implemented.
- **Use cases** — single-responsibility classes, one action each (`GetAllCountries`, `GetCountryDetail`, `GetCountryNews`, `SearchHeroPhoto`, `WatchFavorites`, `ToggleFavorite`, `IsFavorite`). Each returns `Result<T>`, catching all exceptions so BLoCs never deal with raw errors.

#### Data (per feature)
Implements the domain contracts using real infrastructure.

- **Data Transfer Objects (DTOs)** — plain Dart classes that mirror the JSON structure of each API response. They are never exposed beyond the data layer.
- **Data sources** — single-responsibility classes for raw I/O (`CountriesRestDataSource`, `NewsRemoteDataSource`, `PexelsRemoteDataSource`, `FavoritesLocalDataSource`). They return DTOs or Drift row types.
- **Mappers** — pure static functions that convert DTOs / Drift rows → domain entities (and vice versa for writes).
- **Repository implementations** — orchestrate data sources and mappers, satisfying the domain contract.

#### Presentation (per feature)
Depends only on domain entities and use cases — never on DTOs, data sources, or repository implementations.

- **BLoC / Cubit** — all business logic and state transitions live here. BLoCs accept use cases via constructor injection, emit typed states, and are tested in isolation without network or database.
- **Pages & widgets** — react to state via `BlocBuilder` / `BlocListener` / `StreamBuilder`. No business logic in widgets.

#### Shared
Cross-cutting UI concerns that do not belong to any single feature.

- **`GoRouter`** with `StatefulShellRoute.indexedStack` provides tab navigation (Explore, Favorites) with nested detail routes (`/explore/country/:cca3`, `/favorites/country/:cca3`). Deep links work because every route has a unique URL path.
- **Splash flow** — `SplashCubit` triggers a connectivity check after a minimum 2-second display; routes to `/explore` or `/no-internet` based on result.
- **No-internet flow** — `NoInternetCubit` auto-navigates to `/explore` the moment connectivity is restored, without requiring a manual tap.

#### Dependency injection
`core/di/injection.dart` constructs the full dependency graph (Dio → data sources → repository implementations → abstract repositories) and wraps the app in `MultiProvider`. `main.dart` is reduced to three lines:

```dart
await initializeApp();          // env + connectivity
runApp(buildProviderTree(       // DI graph
  child: GlobalExplorerApp(router: createAppRouter()),
));
```

BLoCs and Cubits receive their dependencies through constructor injection inside the GoRouter `builder` callbacks, keeping them isolated from the global provider tree.

### Dependency rule

```
main.dart
  └─ core/di        ← constructs everything
       └─ features/.../data         ← knows Dio, Drift, DTOs
            └─ features/.../domain  ← pure Dart only
                 └─ features/.../presentation  ← Flutter + BLoC
                      └─ shared/router         ← navigation
```

No arrow ever points inward past its layer. The domain layer has zero knowledge of Flutter, Dio, or Drift.

---

## 6. Technical Trade-offs & Constraints

### NewsAPI country coverage
`top-headlines` is filtered by ISO alpha-2 country code (`cca2`). The free developer tier only returns articles for a subset of countries (primarily US, UK, and a few others). For most countries the news section will show "No headlines available." This is a limitation of the NewsAPI free plan — not a bug — and is addressed in the UI with a graceful fallback message.

### Pexels photo relevance
Photos are fetched using a keyword search (`{capital} {country}`). Results are stock photography and are not guaranteed to show official landmarks or culturally accurate imagery. A curated photo API (e.g., Getty Images) would give better results but requires a paid account.

### Country list is not cached offline
The assignment's Drift requirement is scoped to reactive favorites persistence. Caching all 250 countries offline would require a schema migration strategy and background sync logic that is out of scope. The retry interceptor and 60-second receive timeout mitigate slow network conditions instead.

### Rest Countries API reliability
`restcountries.com` is a free public API that occasionally returns 502/503 errors under load. The Dio retry interceptor handles this automatically with exponential back-off (up to 3 retries). The explore screen also provides a manual Retry button.

### Drift code generation in CI
Drift's generated file (`app_database.g.dart`) is committed to source control so the project builds without running `build_runner`. If the schema changes, `dart run build_runner build --delete-conflicting-outputs` must be run locally and the updated `.g.dart` committed.

### iOS simulator DNS lookups
The `ConnectivityService` performs a real DNS lookup to verify internet reachability. On a freshly booted iOS simulator this lookup can take several seconds on the first attempt, slightly extending the splash screen duration.

### NewsAPI HTTPS on Android
NewsAPI requires HTTPS. Android 9+ enforces this by default, so no `network_security_config` is needed. If you target Android 8 or lower, add a `cleartextTrafficPermitted` exception for `newsapi.org`.
