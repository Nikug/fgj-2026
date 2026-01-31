extends Node;

@export var current_mask_index: int = 1

@export var masks: Array[Node3D] = []
@export var spotlights: Array[Node3D] = []

@export var prevButton: Button;
@export var nextButton: Button;
@export var startButton: Button;

@export var camera_speed: float = 50.0
@export var camera_acceleration: float = 10.0
@export var camera_max_speed: float = 300.0

var camera: Camera3D
var camera_velocity: float = 0.0
var target_x: float = 0.0
var is_moving_camera: bool = false

func _ready() -> void:
	masks = [
		$"../Mask 1",
		$"../Mask 2",
		$"../Mask 3"
	]
	
	spotlights = [
		$"../SpotlightMask1",
		$"../SpotlightMask2",
		$"../SpotlightMask3"
	]

	# Set initial visibility
	#for i in range(masks.size()):
	#	set_model_visibility(i, i == 0)
	
	camera = get_viewport().get_camera_3d()
	target_x = camera.global_position.x
	
	# Connect buttons
	prevButton = $PrevButton
	prevButton.pressed.connect(_on_prev_pressed)
	
	nextButton = $NextButton
	nextButton.pressed.connect(_on_next_pressed)

	startButton = $GoButton
	startButton.pressed.connect(_on_start_pressed)

	update_mask_display()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_on_prev_pressed()
	if Input.is_action_just_pressed("right"):
		_on_next_pressed()
		
func _physics_process(delta: float) -> void:
	if is_moving_camera:
		update_camera_movement(delta)

func update_camera_movement(delta: float) -> void:
	var current_x = camera.global_position.x
	var distance = target_x - current_x
	
	# Accelerate towards target
	if abs(distance) > 0.1: # Stop when very close
		if distance > 0:
			camera_velocity = min(camera_velocity + camera_acceleration * delta, camera_max_speed)
		else:
			camera_velocity = max(camera_velocity - camera_acceleration * delta, -camera_max_speed)
		
		current_x += camera_velocity * delta
	else:
		current_x = target_x
		camera_velocity = 0.0
		is_moving_camera = false
	
	camera.global_position.x = current_x

func _on_prev_pressed() -> void:
	current_mask_index = (current_mask_index - 1 + masks.size()) % masks.size()
	update_mask_display()

func _on_next_pressed() -> void:
	current_mask_index = (current_mask_index + 1) % masks.size()
	update_mask_display()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://vilperi/cutscene.tscn")


func update_mask_display() -> void:
	target_x = masks[current_mask_index].global_position.x
	is_moving_camera = true
	camera_velocity = 0.0
	update_button_visibility()
	update_spotlight_visibility()

func update_button_visibility() -> void:
	prevButton.visible = current_mask_index > 0
	nextButton.visible = current_mask_index < masks.size() - 1

func update_spotlight_visibility() -> void:
	for i in range(spotlights.size()):
		spotlights[i].visible = (i == current_mask_index)

func set_model_visibility(index: int, is_visible: bool) -> void:
	if (is_visible):
		masks[index].show()
	else:
		masks[index].hide()
