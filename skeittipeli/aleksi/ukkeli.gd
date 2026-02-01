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

@onready var jump_cooldown: Timer = $JumpCooldown
@onready var min_speed_cooldown: Timer = $MinSpeed
@onready var animated_sprite: Sprite2D = $Sprite2D
@onready var player_collider: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animated_sprite_2: AnimatedSprite2D = $Area2D/skater
@onready var plague_mask_sprite: AnimatedSprite2D = $Area2D/plague_mask
@onready var hockey_mask_sprite: AnimatedSprite2D = $Area2D/hockey_mask
@onready var ghost_mask_sprite: AnimatedSprite2D = $Area2D/ghost_mask
@onready var secret_mask_sprite: AnimatedSprite2D = $Area2D/secret_mask
@onready var particles: CPUParticles2D = $CPUParticles2D


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

var current_min_speed : float = 0.0

var ground_accel: float = 30
var ground_friction: float = 0.8
var air_accel: float = 30
var ground_speed_limit: float = 80
var air_speed_limit: float = 80
var rotation_limit: float = 300
var max_movement_speed: float = 2000
var current_movement_speed: float = 0.0
var default_jump_cooldown: float = 1.0

var rng = RandomNumberGenerator.new()

var levitationYPos


func _ready():
  particles.emitting = false
  play_skate_animation()
  animated_sprite_2.animation_finished.connect(_on_animation_finished)
  if mask.selectedMask == 1:
    #_print("plague")
    plague_mask_sprite.visible = true
    hockey_mask_sprite.visible = false
    ghost_mask_sprite.visible = false
    secret_mask_sprite.visible = false
    rotation_multiplier = 3
    rotation_correction_speed = 3
    jump_cooldown.wait_time = rng.randf_range(1.0, 3.0)
  elif mask.selectedMask == 2:
    #_print("hockey")
    ground_accel = 100
    air_accel = 100
    ground_speed_limit = 150
    air_speed_limit = 150
    rotation_limit = 200
    max_movement_speed = 2500
    rotation_multiplier = 4
    rotation_correction_speed = 4
    min_left_velocity = -400
    plague_mask_sprite.visible = false
    hockey_mask_sprite.visible = true
    ghost_mask_sprite.visible = false
    secret_mask_sprite.visible = false
    jump_cooldown.wait_time = 1
  elif mask.selectedMask == 3:
    #_print("ghost")
    ground_accel = 10
    air_accel = 10
    ground_speed_limit = 50
    air_speed_limit = 50
    rotation_limit = 500
    max_movement_speed = 1500
    rotation_multiplier = 2
    rotation_correction_speed = 2
    min_left_velocity = -100
    plague_mask_sprite.visible = false
    hockey_mask_sprite.visible = false
    ghost_mask_sprite.visible = true
    secret_mask_sprite.visible = false
    jump_cooldown.wait_time = 3.0
  elif mask.selectedMask == 0:
    gravity += 1000
    ground_accel = 1000
    air_accel = 1000
    ground_speed_limit = 1000
    air_speed_limit = 1000
    rotation_limit = 500
    max_movement_speed = 5000
    rotation_multiplier = 6
    rotation_correction_speed = 6
    min_left_velocity = -1000
    plague_mask_sprite.visible = false
    hockey_mask_sprite.visible = false
    ghost_mask_sprite.visible = false
    secret_mask_sprite.visible = true
    jump_cooldown.wait_time = 0.5


func _process(_delta: float):
  if isDead:
    particles.emitting = false
    return
  if is_on_floor() and not particles.emitting:
    particles.emitting = true
  else:
    particles.emitting = false

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

  if mask.selectedMask == 3 and not jump_cooldown.is_stopped() and jump_cooldown.time_left > jump_cooldown.wait_time / 2 and not isDead:
    position.y = levitationYPos
  var time_left := min_speed_cooldown.time_left

  current_min_speed = min_left_velocity * ( 1.0 if time_left  <= 0 else ((5 - time_left) / 5))


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

  current_rotation_speed = min(rotation_limit, current_rotation_speed * delta)
  var strafe_accel := ground_accel if is_on_floor() else air_accel
  var speed_limit := ground_speed_limit if is_on_floor() else air_speed_limit

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
  if Input.is_action_just_pressed("jump") and jump_cooldown.is_stopped():
    jump_cooldown.start()
    if mask.selectedMask == 3:
      levitationYPos = position.y - 100
    if collided:
          velocity += get_last_slide_collision().get_normal().rotated(deg_to_rad(-90)) * 200
          play_jump_animation()
        # Normal jump from floor
        #jump()
    elif is_on_wall():
        velocity += get_wall_normal().rotated(-0.75 * PI) * 400
    else:
        velocity.x -= 600

  # Always apply minimum leftward velocity
  velocity.x = min(current_min_speed, max(-max_movement_speed, velocity.x))
  # Unless dead
  if isDead: velocity = Vector2.ZERO

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
  velocity = Vector2.ZERO
  rotation = 0.0
  position.y += 32

func cancelDie():
  isDead = false
  $Area2D.cancelDie()
  

func play_skate_animation():
    if (isDead):
        return
    animated_sprite_2.play("skate")
    plague_mask_sprite.play("skate")
    hockey_mask_sprite.play("skate")
    ghost_mask_sprite.play("skate")

func play_fall_animation():
    animated_sprite_2.play("fall")
    plague_mask_sprite.play("fall")
    hockey_mask_sprite.play("fall")
    ghost_mask_sprite.play("fall")

func play_jump_animation():
    if (isDead):
        return
    animated_sprite_2.play("jump")
    plague_mask_sprite.play("jump")
    hockey_mask_sprite.play("jump")
    ghost_mask_sprite.play("jump")


func _on_jump_cooldown_timeout():
    jump_cooldown.stop()
