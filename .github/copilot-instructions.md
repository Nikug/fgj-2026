# Skeittipeli - AI Coding Instructions

## Project Overview

**Skeittipeli** is a 2D skateboarding game built with **Godot Engine 4.6** for the Finnish Game Jam 2026. The architecture follows Godot's scene-based design with GDScript for gameplay logic.

### Key Architecture

- **Game Flow**: `main.tscn` (game) → menu (in `maija/menu/`) → `main2.tscn` (gameplay)
- **Physics System**: Uses **Jolt Physics** (configured in `project.godot`)
- **Graphics**: DirectX 12 on Windows with 2D canvas rendering
- **Character**: "Ukkeli" player using `CharacterBody2D` with double-jump mechanics

## File Organization

```
skeittipeli/
├── project.godot              # Config: Jolt Physics, 60 FPS, input bindings
├── main.tscn                  # Main menu entry point
├── main_2.gd / main2.tscn     # Gameplay scene with score tracking
├── ground.gd / ground.tscn    # Level generation using FastNoiseLite
├── ground_but_more.gd         # Alternative terrain generation (rotated segments)
├── hud.gd / HUD.tscn          # UI layer for messages & score
├── aleksi/                    # Player character files
│   ├── ukkeli.gd             # Main player logic (CharacterBody2D)
│   ├── ukkeli_keho.gd        # Collision detection (Area2D)
│   ├── ukkeli.tscn           # Player character scene
│   └── Pelaaja.tscn          # Alternative player scene
├── maija/menu/menu.gd        # Menu scene transitions
├── maija/encounters/          # NPC/obstacle encounters
│   ├── duck/                 # Duck NPC (simple animation)
│   ├── pigeon/               # Pigeon NPC (animated, audio)
│   └── skater/               # Skater NPC (animated)
└── vilperi/cutscene.gd       # Cutscene fade-in/fade-out system
```

## Critical Patterns & Conventions

### 1. Input Binding
Defined in `project.godot` section `[input]`:
- **jump**: Space
- **left**: A or Arrow Left
- **right**: D or Arrow Right

Always use `Input.is_action_just_pressed()` and `Input.get_vector()` rather than raw key checks.

### 2. Player Character (`aleksi/ukkeli.gd`)
- Extends `CharacterBody2D` with gravity from project settings
- **Double-jump mechanic**: First jump from floor, second jump in air
- **State tracking**: `has_double_jumped`, `animation_locked`, `was_in_air`
- **Animation**: Handled by sprite flipping on `direction.x` changes
- **Example**: Landing triggers `land()` which sets animation locks
- **Collision Detection**: `ukkeli_keho.gd` (extends `Area2D`) handles overlap detection for encounters

### 3. Level Generation (`ground.gd`)
- Uses `FastNoiseLite` (Simplex Smooth noise) for procedural terrain
- Creates collision geometry via `CollisionPolygon2D`
- **Export variables** allow tuning: `resolution`, `segment_width`, `noise_strength`
- Generates segments by appending noise-based points between start/end positions

### 3b. Alternative Terrain (`ground_but_more.gd`)
- Generates multiple ground segments with rotation
- Uses `@export var ground_angle` to tilt the entire level
- Preloads and instantiates ground segments in a loop
- Useful for angled difficulty variations

### 4. Encounters System (`maija/encounters/`)
NPCs and obstacles that appear in gameplay:
- **Duck** (`duck.gd`): Simple animated character (extends `AnimatedSprite2D`)
- **Pigeon** (`pigeon.gd`): Animated with timed audio cues (plays random sounds every 5-10 seconds)
- **Skater** (`skater.gd`): Animated character (extends `AnimatedSprite2D`, plays "kick" animation)
- All encounters use `AnimatedSprite2D` and connect to collision detection via parent scenes

### 5. Cutscene System (`vilperi/cutscene.gd`)
- Extends `Control` for UI-based cutscenes
- **State machine**: "fade_in" → "hold" → "fade_out" cycle
- **Image sequence**: Loads images from `images[]` array; can be extended for more frames
- **Timing**: Configurable `fade_duration` and `hold_duration`
- Uses `TextureRect` (`@onready var image_rect`) to display and modulate alpha
- **Usage**: Call `show_next_image_or_transition()` to progress through sequence

### 6. UI/HUD System (`hud.gd`)
- Extends `CanvasLayer` (appears above gameplay)
- **Key methods**:
  - `show_message(text)`: Temporary message with timer
  - `update_score(score)`: Updates score label
  - `show_game_over()`: Triggers scene reload to `res://main.tscn`

### 7. Scene Transitions
- Menu calls `get_tree().change_scene_to_file("res://main2.tscn")` to start game
- Game over calls `get_tree().change_scene_to_file("res://main.tscn")` to return to menu
- **Pattern**: All scene changes via `change_scene_to_file()` with full paths like `"res://main2.tscn"`

### 8. Gameplay Score System (`main_2.gd`)
- Extends `Node2D` as the main gameplay controller
- **Score tracking**: `score` variable incremented by timer every second
- **Key methods**:
  - `new_game()`: Initializes score and displays start message
  - `_on_score_timer_timeout()`: Increments score and updates HUD
- Uses `ScoreTimer` node to auto-increment score during gameplay

## Development Workflow

### Running the Game
1. Open Godot 4.6
2. Import: `skeittipeli/project.godot`
3. Press **F5** or click "Run Project"
4. Game starts at main menu (configured in `project.godot` as `run/main_scene`)

### Physics Configuration
- Engine: **Jolt Physics** (see `[physics]` in `project.godot`)
- Gravity: From project settings, applied via `ProjectSettings.get_setting("physics/2d/default_gravity")`
- Use `is_on_floor()` to check if character is grounded

### Common Tasks
- **Add new input action**: Edit `project.godot` `[input]` section, then use in code
- **Adjust player speed/jump**: Modify `@export` variables in `ukkeli.gd` (visible in Inspector)
- **Modify terrain**: Tweak `ground.gd` export variables (resolution, noise_strength) or change `FastNoiseLite` settings
- **Debug**: Use `print()` statements; check Output panel in Godot editor

## Integration Points

- **Input System**: `Input` singleton (Godot built-in)
- **Physics**: Jolt Physics via Godot's physics API (`move_and_slide()`, `is_on_floor()`)
- **Scene Management**: `get_tree()` singleton for scene changes
- **Rendering**: DirectX 12 (Windows) - no special code needed; Godot handles it

## Project-Specific Notes

- **Game Jam Context**: Prototype-quality code; focus on playability over refactoring
- **Language**: GDScript (Godot's Python-like scripting)
- **No external dependencies** beyond Jolt Physics (pre-configured)
- **Target**: Windows with DirectX 12
- **Frame Budget**: 60 FPS cap (see `run/max_fps` in `project.godot`)

## Common Pitfalls

- **Scene UID Mismatch**: Scene references use `uid://` format; use Godot UI to connect scenes
- **Animation Locks**: `animation_locked` flag prevents conflicting animations; check before setting state
- **Gravity Application**: Gravity only applies in `_physics_process()`, not `_process()`
- **Input Timing**: Use `_just_pressed` for single-frame actions (jump), `is_action_pressed` for continuous (movement)
