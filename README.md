# Lovia 💜

> An AI-companion chat app — browse and create AI characters, chat with them,
> manage a coins/diamonds wallet, and hit a premium paywall. Built as a
> **portfolio-grade** Flutter reference: feature-first **Clean Architecture**,
> **GetX** for state/DI/routing, typed errors, immutable models, and tests.

Warm, romantic, premium tone. Audience 18+. Multi-language ready.

> **Screenshots:** _add captures of Splash · Discover · Character detail · Chat
> · Wallet · Premium · Profile here._

---

## What's real vs. mocked

The **auth** feature talks to the real Node/Express backend in
`../lovia_backend`. Every **other** feature uses an in-memory/locally-persisted
fake data source — but flows through the *identical* clean pipeline, so swapping
a fake for a real API touches **nothing above the `data` layer**.

| Area | Backend |
|---|---|
| Auth: register, login, forgot/verify-OTP/reset password | **REAL** API |
| Discover · Character detail · Chat · Create · Wallet · Premium · Profile | **MOCK** (fake datasources, persisted with GetStorage) |

### Derived auth contract (from `lovia_backend/`)

The backend is the single source of truth. The contract below was reverse-
engineered from its routes/controllers/model/middleware:

| Action | Method & Path | Request body | Success response | Auth header |
|---|---|---|---|---|
| Register | `POST /auth/register` | `{name, email, password}` | `201 {message}` (no auto-login) | — |
| Login | `POST /auth/login` | `{email, password}` | `200 {token, name}` | — |
| Forgot password | `POST /auth/forgot-password` | `{email}` | `200 {message}` | — |
| Verify OTP | `POST /auth/verify-otp` | `{email, otp}` | `200 {message}` | — |
| Reset password | `POST /auth/reset-password` | `{email, otp, newPassword}` | `200 {message}` | — |
| (protected routes) | — | — | — | `Authorization: Bearer <token>` |

**Notable realities (and how the app handles them):**

- Auth is mounted at **`/auth`** (not `/api/auth`); backend `PORT=3000`.
- There is **no** `current-user`, **no** refresh, and **no** logout endpoint.
  - `GetCurrentUser` / `CheckAuthStatus` rebuild the user from the **cached
    session** — the `id` is decoded from the JWT `userId` claim, the `name` from
    the login response, and the `email` from the login form.
  - `LogoutUser` clears local tokens (no server call).
  - There is **no** `RefreshInterceptor` — the backend issues a single 7-day JWT.
- The auth header is exactly `Authorization: Bearer <token>` (matches the
  backend's `middleware/auth.js`).

---

## Architecture

Feature-first **Clean Architecture** with a shared `core`. The dependency rule
points inward — outer layers depend on inner ones, never the reverse:

```
presentation  ───►  domain  ◄───  data
   (UI, GetX)       (pure)        (impl)
```

- **domain** — entities, repository *contracts*, usecases. Pure Dart: no
  Flutter, no Dio, no GetX.
- **data** — DTOs (`json_serializable`, with `toEntity()`), data sources,
  repository *implementations*. Catches exceptions and returns a `Result`.
- **presentation** — GetX controllers holding `Rx<ViewState<T>>`, dumb widgets,
  per-route `Bindings`. Depends only on **domain** (calls usecases).
- **core** — cross-cutting: `Result`/`Failure`, `UseCase`, `DioClient` +
  interceptors, theme tokens, routing + middleware, shared widgets, utils.

**Hard rules enforced throughout:**

- No business logic in controllers/widgets.
- No `Dio`/`http` outside `data`; no `get` in `domain`/`data`.
- Entities never expose JSON; DTOs map to entities.
- Errors are typed via a Dart 3 sealed `Result<S, Failure>` — **no exception
  ever crosses the data → domain boundary**, and there is no `try/catch` above
  the data layer.

### Why feature-first Clean + GetX?

- **Feature-first** keeps each capability (auth, chat, wallet…) self-contained
  and independently navigable — easy for a reviewer to read one vertical slice
  end-to-end.
- **Clean layering** makes the real-vs-mock boundary a single seam: every
  feature already returns `Result` from a repository contract, so going from a
  fake data source to a real API is a `data`-only change.
- **GetX** gives lightweight reactive state (`Rx` + `Obx`), declarative routing
  with route **middleware** (auth guarding), and **Bindings** for lazy,
  per-route dependency injection — with very little boilerplate.

### State pattern

Controllers expose `Rx<ViewState<T>>`, a freezed sealed union:

```dart
ViewState.initial() | .loading() | .loaded(T data) | .error(String message)
```

Widgets render it with an exhaustive `switch` (see `ViewStateView`). Auth uses
its own richer `AuthStatus` union (`unknown / authenticating / authenticated /
unauthenticated / error`).

---

## Folder structure

```
lib/
├── main.dart                      # init GetStorage + global DI, runApp
├── app/
│   ├── app.dart                   # GetMaterialApp: theme, routes, locale
│   └── di/app_bindings.dart       # global singletons (Dio, storages, repos, AuthController)
├── core/
│   ├── config/                    # env (API base URL via --dart-define)
│   ├── constants/                 # api paths, storage keys, durations
│   ├── error/                     # failures.dart, exceptions.dart
│   ├── network/                   # dio_client + interceptors (log, auth)
│   ├── result/                    # sealed Result / Unit
│   ├── routing/                   # app_routes, app_pages, middleware/
│   ├── state/                     # generic ViewState<T> union
│   ├── theme/                     # colors, spacing, typography, theme, theme_controller
│   ├── usecase/                   # UseCase base + NoParams
│   ├── utils/                     # jwt, validators, logger
│   └── widgets/                   # GradientButton, AppTextField, GlassCard, states…
└── features/
    ├── auth/      {data, domain, presentation}   # REAL API
    ├── discover/  {presentation}                  # uses character domain
    ├── character/ {data, domain, presentation}   # detail + create wizard
    ├── chat/      {data, domain, presentation}   # canned replies, persisted
    ├── wallet/    {data, domain, presentation}   # coins + daily check-in
    ├── premium/   {data, domain, presentation}   # paywall (UI only)
    ├── profile/   {presentation}                  # reads real auth user
    └── shell/     {presentation}                  # bottom-nav scaffold
```

### Swapping a fake datasource for a real one

Every mock feature has a `data/datasources/*_local_data_source.dart` behind an
interface, wired in `app/di/app_bindings.dart`. To go live, e.g. for characters:

1. Add a `CharacterRemoteDataSource` (Dio) implementing the same interface.
2. Point `CharacterRepositoryImpl` at it (constructor swap).
3. Update the one `Get.put<CharacterRepository>(...)` line in `AppBindings`.

The domain, usecases, controllers, and UI stay **completely unchanged**.

---

## Running it

### 1. Start the backend

```bash
cd ../lovia_backend
npm install
npm run dev        # listens on http://localhost:3000 (needs a MongoDB; see its README)
```

### 2. Run the Flutter app

```bash
cd lovia
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # freezed + json_serializable
flutter run --dart-define=API_BASE_URL=<host-for-your-target>
```

The backend is local, so set `API_BASE_URL` per target (defaults to the
Android-emulator host if omitted):

| Target | `API_BASE_URL` |
|---|---|
| Android emulator | `http://10.0.2.2:3000` |
| iOS simulator | `http://localhost:3000` |
| Physical device | `http://<your-LAN-IP>:3000` |

Example:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

> **Verify real auth:** with the backend running, create an account on the
> Sign-up screen, then log in — you'll land on the main shell. The forgot-
> password flow emails an OTP (configure `EMAIL_*` in the backend `.env`); the
> OTP is also printed to the backend console for local testing.

---

## Testing

```bash
flutter test
```

Covers (mocktail):

- **Every auth usecase** delegates correctly to the repository.
- **`AuthRepositoryImpl`** — login success (incl. JWT `userId` decode) plus the
  mapping of each exception to its `Failure` (network / unauthorized /
  validation / server / unknown / cache), and the expired-token path.
- **Character** and **Wallet** repositories — DTO→entity mapping and failure
  mapping.
- **Widget** — `LoginPage` inline validation + that valid input invokes login,
  and `CharacterCard` rendering.

---

## Tech stack

`get` · `dio` · `flutter_secure_storage` · `get_storage` · `freezed` +
`freezed_annotation` · `json_serializable` + `json_annotation` ·
`cached_network_image` · `intl` + `flutter_localizations` · `logger`.
Lints: **`very_good_analysis`** (strict, zero warnings). Tests: `flutter_test`
+ `mocktail`.

## Design system (§11)

Dark-first with a polished light theme (toggle persisted in Profile). All tokens
live in `core/theme` — **no magic numbers or raw hex in widgets**. Rose→violet
brand gradient, amber for coins/premium, soft-glass cards, an 8-pt spacing
scale, a named type scale, hero card→detail transitions, shimmer skeletons, and
a custom typing indicator.

## Known limitations

- Mock features are local-only; created characters, conversations, and the
  wallet persist via `GetStorage` on-device.
- Chat replies are short, deterministic, **SFW** canned templates — there is no
  LLM behind them.
- Premium is **UI-only** — "purchase" shows a mock success sheet; no billing.
- Localization is scaffolded (delegates wired, English only); strings are not
  yet externalized to ARB files.
- The display font falls back to the system family (no font asset is bundled).
- The backend exposes no refresh/current-user/logout endpoints, so the session
  is a single 7-day JWT validated locally (see the auth contract above).
