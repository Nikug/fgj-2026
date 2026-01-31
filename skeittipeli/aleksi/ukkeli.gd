extends CharacterBody2D

signal full_rotation

@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100
@export var rotation_correction_speed: float = 0.002
@export var rotation_multiplier: float = 0.002
@export var world_speed: float = 200
@export var death: GDScript
@export var movement_speed: float = 200
@export var maxmovement_speed: float = 200
@export var current_rotation_speed: float = 0.0

@onready var animated_sprite: Sprite2D = $Sprite2D
@onready var player_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2: AnimatedSprite2D = $Area2D/AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var has_double_jumped: bool = false
var animation_locked: bool = false
var direction: Vector2 = Vector2.ZERO
var was_in_air: bool = false
var death_script
var total_rotation: float = 0.0


func _ready():
  animated_sprite_2.play("skate")
  animated_sprite_2.animation_finished.connect(_on_animation_finished)

var current_movement_speed: float = 0.0

const GROUND_ACCEL: float = 10
const GROUND_FRICTION: float = 0.8
const AIR_ACCEL: float = 10
const GROUND_SPEED_LIMIT: float = 50
const AIR_SPEED_LIMIT: float = 80


func _physics_process(delta: float):
  # Add the gravity.
  if not is_on_floor():
    velocity.y += gravity * delta
    was_in_air = true
  else:
    has_double_jumped = false
    was_in_air = false
    total_rotation = 0.0


  # Get the input direction and handle the movement/deceleration.
  # As good practice, you should replace UI actions with custom gameplay actions.

  direction = Input.get_vector("left", "right", "up", "down")
  if direction.x != 0:
    current_rotation_speed += direction.x * rotation_correction_speed
  else:
    if rotation < 0:
      current_rotation_speed -= rotation_multiplier * abs(rotation)
    else:
      current_rotation_speed += rotation_multiplier * rotation
  var strafe_accel := GROUND_ACCEL if is_on_floor() else AIR_ACCEL
  var speed_limit := GROUND_SPEED_LIMIT if is_on_floor() else AIR_SPEED_LIMIT

  var accel := strafe_accel * delta
  accel = max(0, min(accel, speed_limit - velocity.length()))

  rotation += current_rotation_speed
  total_rotation += current_rotation_speed
  if not is_on_floor() and abs(total_rotation) > 2 * PI:
    total_rotation = 0
    full_rotation.emit()

  var collided := move_and_slide()
  if collided:
      var slide_direction := get_last_slide_collision().get_normal()
      velocity = velocity.slide(slide_direction)
    # Handle Jump.
  if Input.is_action_just_pressed("jump"):
      if collided:
          velocity += get_last_slide_collision().get_normal().rotated(deg_to_rad(-90)) * 200
        # Normal jump from floor
        #jump()
      else:
          velocity.x -= 600
  update_facing_direction()

func update_facing_direction():
  if direction.x > 0:
    animated_sprite.flip_h = false
  elif direction.x < 0:
    animated_sprite.flip_h = true

func jump():
  velocity.y = jump_velocity
  animation_locked = true

func double_jump():
  animated_sprite_2.play("fall")

  velocity.y = double_jump_velocity
  animation_locked = true
  has_double_jumped = true

func land():
  animation_locked = true

func _on_animation_finished():
  if animated_sprite_2.animation == "fall":
    animated_sprite_2.play("skate")
