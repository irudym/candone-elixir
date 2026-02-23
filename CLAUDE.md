# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Candone is a kanban-style task management app built with Phoenix 1.7.10, LiveView 0.20.1, and PostgreSQL. It features a Linear-inspired UI with drag-and-drop task boards, projects, notes, and contacts management.

## Common Commands

```bash
mix setup                # Full setup: deps, DB create/migrate/seed, assets
mix phx.server           # Start dev server at http://localhost:4000
iex -S mix phx.server    # Start with IEx console
mix test                 # Run all tests (auto-creates test DB)
mix test test/path_test.exs          # Run a single test file
mix test test/path_test.exs:42       # Run a specific test by line number
mix ecto.migrate         # Run pending migrations
mix ecto.reset           # Drop + recreate + seed database
```

Database: PostgreSQL with default `postgres`/`postgres` credentials, database `candone_dev` (dev) / `candone_test` (test).

## Architecture

### Phoenix Contexts (lib/candone/)

Four domain contexts under `lib/candone/`:
- **Contacts** — `Person` (belongs_to Company) and `Company` schemas
- **Tasks** — `Task` schema with integer stage field (0=backlog, 1=sprint, 2=done) and integer urgency
- **Notes** — `Note` schema with markdown content (rendered via Earmark)
- **Projects** — `Project` schema; aggregates tasks and notes

Tasks and Notes have many-to-many relationships with People and Projects via join tables (`tasks_people`, `projects_tasks`, `projects_notes`, `notes_people`).

### LiveView UI (lib/candone_web/live/)

The main interface is `DashboardLive.Index` — a kanban board with sidebar project selector. It uses:
- **LiveView streams** (`:tasks_backlog`, `:tasks_sprint`, `:tasks_done`) for efficient DOM updates
- **Sortable.js hook** for drag-and-drop between columns; the `reposition` event handles stage changes
- **StoreSettings hook** for persisting sort/filter preferences to localStorage
- **Alpine.js** for reactive UI elements
- Modal overlays for task/note create/edit forms

Custom components live in `lib/candone_web/live/components/`: `CardComponents`, `SelectManyComponent`, `FormComponents`, `UiComponents`, `Icons`.

Standard CRUD LiveViews exist for `/tasks`, `/notes`, `/projects`, `/people`, `/companies` but the primary user flow is through the dashboard.

### Routing

Main routes are nested under `DashboardLive.Index` with live_action pattern:
- `/` — dashboard index
- `/dashboard/projects/:id` — filtered by project
- `/dashboard/tasks/new`, `/dashboard/tasks/:id/edit` — task modals
- `/dashboard/notes/new`, `/dashboard/notes/:id/edit` — note modals

### Frontend

- Tailwind CSS with custom Linear-style sand color palette (see `tailwind.config.js`)
- JS hooks in `assets/js/app.js`: `Sortable`, `StoreSettings`, `SelectComponent`, `SelectManyComponent`, `Flash`
- Custom markdown-to-HTML rendering with Tailwind classes in `Candone.Utils.Markdown`

### Key Patterns

- Task stages and urgency use magic integers (0, 1, 2) — not yet migrated to Ecto.Enum
- `create_task_with_people_projects/3` and similar functions handle many-to-many associations by accepting comma-separated ID strings
- Virtual fields (`:task_count`, `:note_count`, `:people_count`) computed via subqueries in context list functions
- Join tables use `on_delete: :delete_all` for cascading deletes
- No authentication — all routes are public
