# Code Review: Candone Task Management Application

## 1. Critical Bugs

### 1a. Typo in `get_stage/1`
**File:** `lib/candone/tasks/task.ex:52`

```elixir
# Current (typo):
def get_stage(%{stage: 1}), do: "In Srint"

# Should be:
def get_stage(%{stage: 1}), do: "In Sprint"
```

### 1b. Crash on empty project list
**File:** `lib/candone_web/live/dashboard_live/index.ex:269`

When deleting the last project, `List.first(projects)` returns `nil`, and `nil.id` crashes:
```elixir
# Current (crashes when projects is empty):
current_project_id = List.first(projects).id || :none

# Fix:
current_project_id = case List.first(projects) do
  nil -> :none
  project -> project.id
end
```

### 1c. Potential nil crash in `update_sprint_cost/1`
**File:** `lib/candone_web/live/dashboard_live/index.ex:162`

`task.cost` can be `nil` since it's not validated as required, causing an arithmetic error:
```elixir
# Current:
Enum.reduce(tasks, 0, fn task, acc -> acc + task.cost end)

# Fix:
Enum.reduce(tasks, 0, fn task, acc -> acc + (task.cost || 0) end)
```

### 1d. Mismatched `on_delete` between migration and schema
**Files:** `priv/repo/migrations/20240129124453_create_tasks_people.exs` and similar join table migrations

Migrations use `on_delete: :nothing` but schemas use `on_delete: :delete_all`. The database won't cascade deletes. Fix by adding a migration to alter the foreign key constraints.

---

## 2. N+1 Queries and Database Performance

### 2a. Repeated database queries in Dashboard
**File:** `lib/candone_web/live/dashboard_live/index.ex`

`set_project/2` issues 4 separate queries (project + 3 stage-filtered task queries). Every sort event re-fetches all tasks. Fetch once and partition in Elixir:

```elixir
defp set_project(socket, id) do
  project = Projects.get_project!(id)
  all_tasks = Projects.get_project_tasks(project)
  grouped = Enum.group_by(all_tasks, & &1.stage)
  backlog = Tasks.sort_by(Map.get(grouped, 0, []), socket.assigns.sorting)
  sprint = Tasks.sort_by(Map.get(grouped, 1, []), socket.assigns.sorting)
  done = Tasks.sort_by(Map.get(grouped, 2, []), socket.assigns.sorting)
  # ...
end
```

### 2b. `list_people_with_full_names/0` loads all fields
**File:** `lib/candone/contacts.ex:123-126`

Loads full Person structs then maps in Elixir. Use a `select` in the query to only fetch needed fields.

### 2c. Missing database index on `tasks.stage`
`list_task_by_stage/1` and `get_project_tasks_with_stage/2` filter by stage frequently. Add:
```elixir
create index(:tasks, [:stage])
```

### 2d. Unnecessary preload on every validate event
**Files:** `lib/candone/tasks.ex:162`, `lib/candone/notes.ex:103`

`change_task/2` and `change_note/2` preload associations every call, including on every keystroke validation. Check if already loaded:
```elixir
def change_task(%Task{} = task, attrs \\ %{}) do
  task = if Ecto.assoc_loaded?(task.people), do: task, else: Repo.preload(task, :people)
  Task.changeset(task, attrs)
end
```

---

## 3. Code Duplication

### 3a. Sorting event handlers
**File:** `lib/candone_web/live/dashboard_live/index.ex:291-331`

Three nearly identical `sort-*` handlers. Consolidate:
```elixir
def handle_event("sort-" <> field, _, socket) do
  sorting = sorting2symbol(field)
  {:noreply, apply_sorting(socket, sorting)}
end
```

### 3b. `create_*_with_people/_projects` pattern
**Files:** `lib/candone/tasks.ex:75-101`, `lib/candone/notes.ex:108-157`

Six nearly identical insert-then-update functions. Use `Ecto.Multi` for atomicity and consolidation.

### 3c. Action delegation boilerplate in form components
Both `TaskLive.FormComponent` and `NoteLive.FormComponent` have forwarding clauses like:
```elixir
defp save_task(socket, :new_task, params), do: save_task(socket, :new, params)
```
Normalize the action before dispatching instead.

---

## 4. Debug Code Left in Production

### IO.inspect calls to remove:
- `lib/candone_web/live/dashboard_live/index.ex:61,117,140,263`
- `lib/candone_web/live/components/select_many_component.ex:17`
- `lib/candone_web/live/components/test_component.ex:8,35-40`

Replace with `Logger.debug/1` if logging is needed.

---

## 5. Dead Code

- **`TestComponent`** (`lib/candone_web/live/components/test_component.ex`) - unused prototype code
- **`notify_parent/1`** in `TaskLive.FormComponent` and `NoteLive.FormComponent` - defined but never called
- **`text_input/1` and `textarea/1`** in `UiComponents` - incomplete and unused
- **Join table schemas** (`Tasks.People`, `Projects.Tasks`, `Projects.Notes`, `Notes.People`) - not used since `many_to_many` uses string table names

---

## 6. Architectural Issues

### 6a. No authentication/authorization
All routes are publicly accessible. Add authentication for any production deployment.

### 6b. Magic integer constants for stage/urgency
Stages are raw integers (0, 1, 2) scattered throughout. Use `Ecto.Enum` for type safety:
```elixir
field :stage, Ecto.Enum, values: [backlog: 0, sprint: 1, done: 2], default: :backlog
```

### 6c. `list_projects/0` doesn't populate virtual count fields
The dashboard template accesses `project.task_count` and `project.note_count`, but `list_projects/0` is just `Repo.all(Project)`. These virtual fields are never set. Fix the query to compute counts via joins.

### 6d. Person `company_id` not cast in changeset
`Person` has `belongs_to :company` but the changeset doesn't cast `:company_id`, so the association can never be set through forms.

---

## 7. LiveView-Specific Issues

### 7a. Double-fetch on mount
`mount/3` loads projects, then `handle_params` -> `apply_action(:index)` loads them again.

### 7b. Inconsistent use of streams vs assigns
Tasks use `stream` (efficient DOM diffing) but notes use plain `assign`. Use streams consistently.

### 7c. Missing debounce on form validation
Form validation fires on every keystroke without debouncing, each triggering a DB preload. Add `phx-debounce="300"` to form inputs.

---

## 8. Security Considerations

- **Unvalidated ID parameters** in `get_people_from_string/1`: comma-separated strings passed to DB query without integer validation
- **No ownership/permission checks** on delete operations

---

## 9. Test Coverage Gaps

Tests are scaffold-generated and only cover basic CRUD on `/tasks`. Missing coverage for:
- Dashboard LiveView (the main interface)
- Drag-and-drop reposition
- Task/note creation with associations
- `DateUtils` and `Markdown` modules
- `sort_by` logic
- Edge cases in `get_people_from_string`

---

## 10. Minor Improvements

- **Markdown module**: `map_ast` callback replaces children with `nil`, potentially discarding content
- **`DateUtils.get_work_week/1`**: Non-standard week calculation; consider ISO 8601 compliance
- **Dependency versions**: `phoenix_live_view: "~> 0.20.1"` is outdated
- **Inline SVG icons**: 336-line `icons.ex` file; consider an icon library or static assets
