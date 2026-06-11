# Lovia 💜

> An AI-companion chat app — browse and create AI characters, chat with them,
> manage a coins/diamonds wallet, and hit a premium paywall. Built as a
> **portfolio-grade** Flutter reference: feature-first **Clean Architecture**,
> **GetX** for state/DI/routing, typed errors, immutable models, and tests.

Warm, romantic, premium tone. Audience 18+. Multi-language ready.

---

## What's real vs. mocked

The **auth** feature talks to the real Node/Express backend in
`../lovia_backend`. Every **other** feature uses an in-memory/locally-persisted
fake data source — but flows through the *identical* clean pipeline, so swapping
a fake for a real API touches **nothing above the `data` layer**.

| Area | Backend |
|---|---|
| Auth: register, login, **Google, Facebook, Guest**, refresh, logout, OTP reset | **REAL** API |
| Profile: get/update (`/users/me`, language preference) | **REAL** API |
| Discover · Character detail · Chat · Create · Wallet · Premium | **MOCK** (fake datasources, persisted with GetStorage) |

### Auth contract (`lovia_backend/`)

The backend is the single source of truth. Every sign-in endpoint returns the
**same** envelope: `{ accessToken, refreshToken, user }` where
`user = { id, name, email, avatarUrl, coins, isGuest, language }`.

| Action | Method & Path | Request body | Success response | Auth header |
|---|---|---|---|---|
| Register | `POST /auth/register` | `{name, email, password}` | `201 {accessToken, refreshToken, user}` | — |
| Login | `POST /auth/login` | `{email, password}` | `200 {accessToken, refreshToken, user}` | — |
| Google | `POST /auth/google` | `{idToken}` | `200 {accessToken, refreshToken, user}` | — |
| Facebook | `POST /auth/facebook` | `{accessToken}` | `200 {accessToken, refreshToken, user}` | — |
| Guest | `POST /auth/guest` | `{deviceId}` | `200 {accessToken, refreshToken, user}` | — |
| Refresh | `POST /auth/refresh` | `{refreshToken}` | `200 {accessToken, refreshToken}` | — |
| Logout | `POST /auth/logout` | — | `200 {message}` (bumps `tokenVersion`) | `Bearer <access>` |
| Forgot password | `POST /auth/forgot-password` | `{email}` | `200 {message}` | — |
| Verify OTP | `POST /auth/verify-otp` | `{email, otp}` | `200 {message}` | — |
| Reset password | `POST /auth/reset-password` | `{email, otp, newPassword}` | `200 {message}` | — |
| Get profile | `GET /users/me` | — | `200 {user}` | `Bearer <access>` |
| Update profile | `PATCH /users/me` | `{language?, name?}` | `200 {user}` | `Bearer <access>` |

- Auth is mounted at **`/auth`**, profile at **`/users`** (not under `/api`);
  backend `PORT=3000`. The auth header is `Authorization: Bearer <access>`.
- **Access token** is short-lived (`15m`); **refresh token** is long-lived
  (`30d`) and carries the user's `tokenVersion`. Logout / password-reset bump
  `tokenVersion` to invalidate outstanding refresh tokens server-side.

### ⚠️ Mismatches found vs. the original spec — and how I adapted

The provided spec assumed a social-first backend that didn't exist yet. The
**real** `lovia_backend` started as an email/password + OTP API only. Rather
than invent endpoints silently, I **extended the backend** to satisfy the spec:

| Spec expected | Backend reality (before) | Resolution |
|---|---|---|
| `POST /auth/google {idToken}` | absent | **Added** — verifies the ID token via Google's `tokeninfo` endpoint (asserts `aud == GOOGLE_WEB_CLIENT_ID`), upserts the user. |
| `POST /auth/facebook {accessToken}` | absent | **Added** — verifies via the Facebook Graph API, upserts the user. |
| `POST /auth/guest {deviceId}` | absent | **Added** — upserts a guest keyed by `deviceId`. |
| `POST /auth/refresh` (single retry) | absent | **Added** + a Dio `AuthInterceptor` that refreshes once on 401, retries, else forces logout → auth. |
| `POST /auth/logout` | absent | **Added** — invalidates refresh tokens via `tokenVersion`. |
| `GET/PATCH /users/me` | absent | **Added** — profile fetch + language update. |
| Response `{accessToken, refreshToken, user{...}}` | login returned `{token, name}` | **Standardized** every auth endpoint on the spec envelope. |
| `User{avatarUrl, coins, isGuest}` | only `name/email/password/otp…` | **Extended** the Mongoose `User` model (provider, googleId/facebookId, deviceId, avatarUrl, coins, isGuest, language, tokenVersion). |

Social verification uses Node 18+ global `fetch` (no new npm dependency).

---

## Screens & entry flow (reference-style redesign)

The UI is modelled on a modern AI-companion app layout while keeping all
content fictional, tasteful, and 18+-gated:

- **Splash** — full-bleed companion hero with orbiting avatars, "Lovia AI ·
  Find Your Perfect Match", thin pink progress bar; routes to the shell or
  onboarding based on the stored session.
- **Onboarding** — "Welcome back, we missed you" hero with chat-bubble teasers
  and an avatar carousel; **Get Started** opens the **sign-in sheet**.
- **Sign-in sheet** — a dark modal bottom sheet (drag handle, 28px radius):
  Continue with **Google / Facebook**, **Login (Guest mode)**, and **Use email
  instead**, all behind an "I confirm I am 18" radio, with ToS/Privacy links.
- **Home — "For You"** — a swipeable card deck (drag or use ✕ / chat / ♥) with
  LIKE / NOPE stamps.
- **Discover** — category chips, a **Filter** sheet (gender / age 18+ / style),
  a masonry grid, and full-text **Search**.
- **Create** — full character form (name, age, gender, introduction,
  personality, language, relationship, preview, category, up to 3 tags) with a
  **Random AI** filler.
- **Chats**, **Character detail**, **Chat thread** (canned SFW replies).
- **Profile** — account header (avatar, name, `Id : …`), gold Premium card, My
  wallet + Daily task tiles, community banner, settings list (My character,
  Language, Rate, Share, Feedback, Terms, Privacy, **Log out** in red w/ confirm,
  **Delete account**, Version). Language + logout hit the real backend.
- **Top up** — membership card + a gems shop (purchases credit the wallet) +
  Watch-Ad mission.
- **Daily task** — 7-day reward streak (claim once/day) + Earn-Reward list.
- **Language** — locale picker (persisted).

## Authentication (email + social + guest)

All paths hit the **real** `lovia_backend` and persist `{accessToken,
refreshToken}` in `flutter_secure_storage`:

- **Email / OTP** → `POST /auth/login|register` + the OTP reset flow.
- **Google** → `google_sign_in` returns an `idToken`, POSTed to `/auth/google`
  (backend verifies it with Google and upserts the user).
- **Facebook** → `flutter_facebook_auth` returns an `accessToken`, POSTed to
  `/auth/facebook`.
- **Guest** → a stable per-install `deviceId` is POSTed to `/auth/guest`. If the
  network is unavailable, it **falls back to a local-only guest session** and
  shows a non-blocking toast (offline-tolerant, per spec).
- **Refresh** → on any `401`, the `AuthInterceptor` calls `/auth/refresh` once,
  retries the original request, and on failure forces logout → auth screen.

### Configuring social sign-in

The backend ships with `GOOGLE_WEB_CLIENT_ID` set in `lovia_backend/.env`.
Add the usual platform credentials to make the native SDKs return tokens:

- **Google** — iOS: reversed-client-id URL scheme + `GIDClientID` in
  `Info.plist`; Android: an OAuth client (Google Cloud / Firebase) matching the
  app's SHA-1.
- **Facebook** *(credentials intentionally blank for now)* — paste your App ID
  and Client Token where the TODO placeholders are:
  - iOS `ios/Runner/Info.plist` → `FacebookAppID`, `FacebookClientToken`,
    `CFBundleURLSchemes` (`fb<APP_ID>`), `LSApplicationQueriesSchemes`.
  - Android `android/app/src/main/res/values/strings.xml` →
    `facebook_app_id`, `facebook_client_token`; plus the manifest
    `meta-data` / `FacebookActivity` entries.
  - Backend reads nothing extra for Facebook (it verifies the access token via
    the Graph API at runtime).

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

If `API_BASE_URL` is omitted, the app talks to the **hosted backend**
(`https://lovia-backend-rvud.onrender.com`). To use a locally running
backend instead, set it per target:

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

## Design system

Modelled on the product screenshots. All tokens live in `core/theme` — **no
magic numbers or raw hex in widgets**:

- **Background** — near-black `#0D0407` with a deep magenta/maroon radial glow
  (`#5C0F2E → #2A0814`) concentrated top-left (`AppBackdrop`).
- **Primary gradient** — pink → purple `#FF4D5E → #C13BFF` (buttons, accents);
  standalone accent pink `#FF2D78` (selected language, nav dash).
- **Surfaces** — cards `#1A1A1C` @ 22px radius; sheets `#1F1F22` @ 28px with a
  drag handle; glass chips at white-12%; selected chip = white pill, dark text.
- **Type** — **Nunito** via `google_fonts` (rounded humanist): page titles ~28
  bold, card titles ~20 bold, body ~15.
- **Bottom nav** — five label-less outline icons; the active item shows a small
  pink underline dash.
- Plus an 8-pt spacing scale, hero card→detail transitions, shimmer skeletons,
  and a custom typing indicator.

## Known limitations

- Mock features are local-only; created characters, conversations, and the
  wallet persist via `GetStorage` on-device.
- Chat replies are short, deterministic, **SFW** canned templates — there is no
  LLM behind them.
- Premium membership is **UI-only** (no billing); gem-pack "purchases" are a
  demo but **do** credit the local wallet so balances/transactions update.
- Native social sign-in needs platform OAuth credentials to return tokens
  (Facebook's are intentionally blank — see *Configuring social sign-in*). Guest
  + email work with zero setup; guest is also offline-tolerant.
- Swipe "likes" on Home are kept in memory for the session, not persisted.
- Localization is scaffolded (delegates wired, English only); the language
  picker persists the choice and PATCHes `/users/me`, but strings aren't
  externalized to ARB files yet.
- "Delete account" is a demo (no backend delete endpoint) — it confirms then
  signs out.
