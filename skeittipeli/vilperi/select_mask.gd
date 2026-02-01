extends Node;

@export var current_mask_index: int = 2

@export var masks: Array[Node3D] = []
@export var spotlights: Array[Node3D] = []

@export var prevButton: Button;
@export var nextButton: Button;
@export var startButton: Button;


# X axis camera movement
@export var camera_speed: float = 50.0
@export var camera_acceleration: float = 10.0
@export var camera_max_speed: float = 300.0
# Y axis camera movement (slower)
@export var camera_y_speed: float = 10.0
@export var camera_y_acceleration: float = 2.0
@export var camera_y_max_speed: float = 40.0

var camera: Camera3D
var camera_velocity_x: float = 0.0
var camera_velocity_y: float = 0.0
var target_x: float = 0.0
var target_y: float = 0.0
var is_moving_camera: bool = false

func _ready() -> void:
    masks = [
        $"../Mask 0",
        $"../Mask 1",
        $"../Mask 2",
        $"../Mask 3"
    ]

    spotlights = [
        $"../SpotlightMask0",
        $"../SpotlightMask1",
        $"../SpotlightMask2",
        $"../SpotlightMask3"
    ]

    camera = get_viewport().get_camera_3d()
    target_x = camera.global_position.x
    target_y = camera.global_position.y

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
    if Input.is_action_just_pressed("ui_accept"):
        goNext()
        
func _physics_process(delta: float) -> void:
    if is_moving_camera:
        update_camera_movement(delta)

func update_camera_movement(delta: float) -> void:
    var current_x = camera.global_position.x
    var current_y = camera.global_position.y
    var distance_x = target_x - current_x
    var distance_y = target_y - current_y

    # Accelerate towards target X
    if abs(distance_x) > 0.1:
        if distance_x > 0:
            camera_velocity_x = min(camera_velocity_x + camera_acceleration * delta, camera_max_speed)
        else:
            camera_velocity_x = max(camera_velocity_x - camera_acceleration * delta, -camera_max_speed)
        current_x += camera_velocity_x * delta
    else:
        current_x = target_x
        camera_velocity_x = 0.0

    # Accelerate towards target Y (slower)
    if abs(distance_y) > 0.1:
        if distance_y > 0:
            camera_velocity_y = min(camera_velocity_y + camera_y_acceleration * delta, camera_y_max_speed)
        else:
            camera_velocity_y = max(camera_velocity_y - camera_y_acceleration * delta, -camera_y_max_speed)
        current_y += camera_velocity_y * delta
    else:
        current_y = target_y
        camera_velocity_y = 0.0

    # If both X and Y are close enough, stop moving
    if abs(distance_x) <= 0.1 and abs(distance_y) <= 0.1:
        is_moving_camera = false

    camera.global_position.x = current_x
    camera.global_position.y = current_y

func _on_prev_pressed() -> void:
    current_mask_index = (current_mask_index - 1 + masks.size()) % masks.size()
    update_mask_display()

func _on_next_pressed() -> void:
    current_mask_index = (current_mask_index + 1) % masks.size()
    update_mask_display()

func _on_start_pressed() -> void:
    goNext()


func update_mask_display() -> void:
    target_x = masks[current_mask_index].global_position.x
    target_y = masks[current_mask_index].global_position.y + 2
    is_moving_camera = true
    camera_velocity_x = 0.0
    camera_velocity_y = 0.0
    update_button_visibility()
    update_spotlight_visibility()

func update_button_visibility() -> void:
    prevButton.visible = current_mask_index > 1
    nextButton.visible = current_mask_index < masks.size() - 1

func update_spotlight_visibility() -> void:
    for i in range(spotlights.size()):
        spotlights[i].visible = (i == current_mask_index)

func set_model_visibility(index: int, is_visible: bool) -> void:
    if (is_visible):
        masks[index].show()
    else:
        masks[index].hide()

func goNext():
    mask.selectedMask = current_mask_index
    get_tree().change_scene_to_file("res://cutscene2.tscn")
