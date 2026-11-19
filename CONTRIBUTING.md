# Contributing Guidelines

This project is primarily a solo project, but contribution guidelines
are provided to document the workflow and coding standards used.

## Workflow

- One active milestone at a time
- Issues in a milestone represent active or near-term work
- Issues without a milestone are considered future work
- Side-quests are small, opportunistic improvements outside milestones

## Definition of Done

A milestone is considered complete when:
- All issues within it are completed or closed as *won't do*
- The related Pull Request has been reviewed and squash merged into `main`
- The project remains in a runnable state
- The implemented feature is playable from end to end
- The roadmap is updated to reflect the new current focus

## Branching

- All changes are done on feature branches
- Branches are merged into `main` using squash commits

## Commit Conventions

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) are used (`feat:`, `fix:`, `chore:`, etc.)
- Commits should remain small and focused

## Code Quality

- [Clean Code](https://cedricchee.com/blog/clean-code/) principles are followed as much as reasonably possible
- Readability is preferred over cleverness
- When code is generated from AI, it must be indicated in a comment (for a function), or in the header (for the class).

## Naming Conventions

Based on the [official GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

| Element | Convention | Example |
|---|---|---|
| Files (scripts, scenes, shaders) | `snake_case`, matching the class name | `wood_texture_painter.gd` |
| Classes (`class_name`) | `PascalCase` | `WoodTexturePainter` |
| Variables and functions | `snake_case` | `get_cut_start_position()` |
| Private members | `_` prefix | `_distance_on_path` |
| Constants | `CONSTANT_CASE` | `MOVEMENT_SPEED` |
| Enums | `PascalCase` name, `CONSTANT_CASE` members | `enum GameState { PLACE, PLANE }` |
| Signals | `snake_case`, past tense | `back_area_exited` |
| Signal callbacks | `_on_<source>_<signal>` | `_on_left_stick_changed` |

## Current de facto rules

Conventions followed in practice, not enforced by tooling. They may evolve.

- **Domain and rendering are separate.** `WoodPiece` holds the state of a wood piece (geometry, thickness, surface). It is changed through `WoodOperation`s and displayed by renderers listening to its signals.
- **Mini-games orchestrate.** A mini-game extends `ToolGame`, instantiates and connects its components according to the current state, and changes state only through `_change_state()`. Computation lives in the components.
- **Signals are connected once** (in `_ready()), **or per state**: connected in `_enter_state()` and disconnected in `_exit_state()`.
- **Movement and operations.** If an object moves freely, the node is the source: it moves, emits `from`/`to`, and the operation is derived from that (pencil, plane). If its movement is constrained to a known path and reduces to a single parameter, the state drives the node (saw: the progression is incremented and the mini-game places the saw).
- **Inputs.** Continuous inputs go through `DirectionalInputReader` and `TriggersInputReader`, and the mini-game routes them according to the current state. `accept` and `cancel` stay native input events.

## Comments

- Prefer self-documenting code
- When needed, use [Conventional Comments](https://conventionalcomments.org/)