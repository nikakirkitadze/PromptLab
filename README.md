# PromptLab

AI Content Generation Simulator — a production-minded Flutter MVP that demonstrates clean architecture, async job lifecycle management, concurrent execution, and polished UI.

## Project Purpose

PromptForge lets users create AI generation jobs (Image, Video, Audio) from text prompts. A **fake backend service** simulates realistic long-running jobs with queued/processing/completed/failed/canceled statuses, random failures, and concurrent execution — all persisted locally.

## Architecture

The project follows **Clean Architecture** with strict layer separation:

```
lib/
├── core/                    # Shared constants, theme, extensions
├── features/generation/
│   ├── domain/              # Entities, repository + service contracts, use cases
│   ├── data/                # Models, Hive datasource, fake service, repo implementation
│   └── presentation/        # Cubit, state, UI models, mappers, pages, widgets
├── injection_container.dart # Dependency injection via GetIt
├── app.dart                 # MaterialApp root
└── main.dart                # Entry point
```

### Layer Responsibilities

| Layer | Owns | Depends On |
|---|---|---|
| **Domain** | Entities, use case logic, contracts | Nothing (pure Dart) |
| **Data** | Hive persistence, fake service, model serialization | Domain contracts |
| **Presentation** | Cubit, state, UI models, widgets | Domain entities + contracts |

### Why Cubit?

- **Predictable state flow**: `View → Cubit intent → Use case → State emission → View rebuild`
- **Simpler than full Bloc**: No event classes needed — direct method calls match the intent pattern cleanly
- **Immutable state**: `GenerationState` is an `Equatable` value class with `copyWith`, making rebuilds deterministic
- **Testable**: Each user intent is a single method that can be unit-tested by asserting emitted states

### Presenter Pattern

Domain entities (`GenerationJob`) are mapped to presentation models (`GenerationJobCardModel`) via `JobCardMapper`. The card model contains only display-ready values (labels, colors, icons, booleans for action visibility). The view never interprets domain logic — it just renders what the model says.

## Fake Backend Simulation

`FakeGenerationService` implements the `GenerationService` domain contract. Each job runs as an isolated `_JobRunner` that:

1. **Queued phase** — emits `queued` status, waits 1–2 seconds
2. **Processing phase** — emits progress updates every 200ms over 3–8 seconds
3. **Result phase** — randomly completes (80%) or fails (20%) with a realistic error message

Features:
- Fully concurrent — each job runs its own async simulation
- Cancelable — setting a flag short-circuits the loop and emits `canceled`
- Resumable — `resumeGeneration()` picks up from the job's last progress point
- Stream-based — Cubit subscribes to `Stream<GenerationJob>` per job

## Local Persistence

Jobs are persisted in **Hive** as JSON-encoded strings. The `GenerationLocalDatasource` stores/loads/deletes `GenerationJobModel` objects.

### Restoration Strategy

On app launch:
1. Load all persisted jobs from Hive
2. Display them immediately
3. For any job with `queued` or `processing` status → restart simulation from last known progress
4. Terminal jobs (`completed`, `failed`, `canceled`) are displayed as-is

## Concurrent Job Handling

- Each active job owns an independent `StreamSubscription` tracked in a `Map<String, StreamSubscription>`
- The Cubit merges updates from all subscriptions into a single state emission
- Canceling one job does not affect others
- All subscriptions are cleaned up in `Cubit.close()`

## How to Run

```bash
flutter pub get
flutter run
```

## Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | Cubit state management |
| `equatable` | Value equality for state + entities |
| `hive_flutter` | Local persistence |
| `get_it` | Service locator / dependency injection |
| `uuid` | Unique job IDs |

## Evolving to Production

### What Would Change

| Area | Current (MVP) | Production |
|---|---|---|
| **Backend** | `FakeGenerationService` | REST API + WebSocket for real-time updates |
| **Persistence** | Hive JSON box | Drift/SQLite with migrations |
| **DI** | GetIt service locator | Injectable with code generation |
| **Background** | In-process timers | WorkManager / background isolates |
| **Auth** | None | Token-based auth middleware |
| **Error handling** | Basic try/catch | Structured `Result<T>` / `Either` types |

### Production Improvements

- **Real REST/WebSocket backend** — swap `GenerationService` implementation; domain + presentation layers unchanged
- **Background execution** — use `workmanager` or isolates for jobs that survive app backgrounding
- **Retry queue** — exponential backoff with jitter for transient failures
- **Pagination/filtering** — virtual list with lazy loading for large job histories
- **Analytics + structured logging** — track generation metrics, failure rates, user engagement
- **Crash reporting** — Sentry/Crashlytics integration
- **Unit + widget tests** — test Cubit state transitions, use cases, mapper logic, widget rendering
- **Theming** — dark mode, dynamic color support
- **Accessibility** — semantic labels, screen reader support
- **Localization** — `intl` / `arb` for multi-language support
