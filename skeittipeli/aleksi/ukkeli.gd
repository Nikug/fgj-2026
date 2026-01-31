extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_velocity: float = -150.0
@export var double_jump_velocity: float = -100
@export var rotation_correction_speed: float = 0.002
@export var rotation_multiplier: float = 0.002
@export var world_speed: float = 200
@export var death: GDScript

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
var current_rotation_speed: float = 0.0

func _ready():
	animated_sprite_2.play("skate")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		was_in_air = true
	else:
		has_double_jumped = false
		was_in_air = false
	

	# Handle Jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			# Normal jump from floor
			jump()
		elif not has_double_jumped:
			# Double jump in air
			double_jump()
		

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
			
	
	rotation += current_rotation_speed
	
	velocity.x = - world_speed


	move_and_slide()
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
	velocity.y = double_jump_velocity
	animation_locked = true
	has_double_jumped = true

func land():
	animation_locked = true
