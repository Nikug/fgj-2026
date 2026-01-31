extends CharacterBody2D

signal full_rotation
signal fell

@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100
@export var rotation_correction_speed: float = 3
@export var rotation_multiplier: float = 4
@export var world_speed: float = 200
@export var death: GDScript
@export var movement_speed: float = 200
@export var maxmovement_speed: float = 200
@export var current_rotation_speed: float = 0.0

@onready var animated_sprite: Sprite2D = $Sprite2D
@onready var player_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2: AnimatedSprite2D = $Area2D/skater
@onready var plague_mask_sprite: AnimatedSprite2D = $Area2D/plague_mask
@onready var hockey_mask_sprite: AnimatedSprite2D = $Area2D/hockey_mask


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
# Minimum leftward velocity (always applied)
@export var min_left_velocity: float = -200.0
var has_double_jumped: bool = false
var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false
var isDead: bool = false
var total_rotation: float = 0.0


func _ready():
  play_skate_animation()
  animated_sprite_2.animation_finished.connect(_on_animation_finished)

var current_movement_speed: float = 0.0

const GROUND_ACCEL: float = 30
const GROUND_FRICTION: float = 0.8
const AIR_ACCEL: float = 30
const GROUND_SPEED_LIMIT: float = 80
const AIR_SPEED_LIMIT: float = 80
const ROTATION_LIMIT: float = 300
const MAX_MOVEMENT_SPEED: float = 2000


func _physics_process(delta: float):
  # Add the gravity.
  if not is_on_floor():
    velocity.y += gravity * delta
    was_in_air = true
  else:
    has_double_jumped = false
    was_in_air = false
    total_rotation = 0.0
    land()


  # Always apply minimum leftward velocity
  if velocity.x > min_left_velocity:
    velocity.x = min(velocity.x, min_left_velocity)


  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.

  direction = Input.get_vector("left", "right", "up", "down")
  if not isDead:
    if direction.x != 0:
      current_rotation_speed += direction.x * rotation_correction_speed
    else:
      if rotation < 0:
        current_rotation_speed -= rotation_multiplier * abs(rotation)
      else:
        current_rotation_speed += rotation_multiplier * rotation

  current_rotation_speed = min(ROTATION_LIMIT, current_rotation_speed * delta)
  var strafe_accel := GROUND_ACCEL if is_on_floor() else AIR_ACCEL
  var speed_limit := GROUND_SPEED_LIMIT if is_on_floor() else AIR_SPEED_LIMIT

  var accel := strafe_accel * delta
  accel = max(0, min(accel, speed_limit - velocity.length()))

  rotation += current_rotation_speed
  total_rotation += current_rotation_speed
  if not is_on_floor() and abs(total_rotation) > 2 * PI:
    total_rotation = 0
    full_rotation.emit()

  velocity += accel * velocity.normalized()
  var collided := move_and_slide()
  if collided:
      var slide_direction := get_last_slide_collision().get_normal()
      velocity = velocity.slide(slide_direction)
    # Handle Jump.
  if Input.is_action_just_pressed("jump"):
    if collided:
          velocity += get_last_slide_collision().get_normal().rotated(deg_to_rad(-90)) * 200
          play_jump_animation()
        # Normal jump from floor
        #jump()
    else:
          velocity.x -= 600
  velocity.x = max(-MAX_MOVEMENT_SPEED, velocity.x) if velocity.x < 0 else min(MAX_MOVEMENT_SPEED, velocity.x)
  update_facing_direction()

func update_facing_direction():
  if direction.x > 0:
    animated_sprite.flip_h = false
  elif direction.x < 0:
    animated_sprite.flip_h = true

func jump():
  velocity.y = jump_velocity
  animation_locked = true
  play_jump_animation()

func double_jump():
  play_fall_animation()

  velocity.y = double_jump_velocity
  animation_locked = true
  has_double_jumped = true

func land():
  animation_locked = true
  play_skate_animation()

func _on_animation_finished():
  if animated_sprite_2.animation == "fall":
    play_skate_animation()


func _on_area_2d_player_fell():
  isDead = true
  fell.emit()

func play_skate_animation():
    animated_sprite_2.play("skate")
    plague_mask_sprite.play("skate")
    hockey_mask_sprite.play("skate")

func play_fall_animation():
    animated_sprite_2.play("fall")
    plague_mask_sprite.play("fall")
    hockey_mask_sprite.play("fall")

func play_jump_animation():
    animated_sprite_2.play("jump")
    plague_mask_sprite.play("jump")
    hockey_mask_sprite.play("jump")