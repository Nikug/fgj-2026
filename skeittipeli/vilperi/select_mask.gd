extends CanvasLayer


@export var current_mask_index: int = 0

@export var masks: Array[Node3D] = []

@export var prevButton: Button;
@export var nextButton: Button;
@export var startButton: Button;

func _ready() -> void:
	masks = [
		$"../Mask 1",
		$"../Mask 2",
		$"../Mask 3"
	]
	
	# Set initial visibility
	for i in range(masks.size()):
		set_model_visibility(i, i == 0)
	
	# Connect buttons
	prevButton = $PrevButton
	prevButton.pressed.connect(_on_prev_pressed)
	
	nextButton = $NextButton
	nextButton.pressed.connect(_on_next_pressed)

	startButton = $GoButton
	startButton.pressed.connect(_on_start_pressed)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_on_prev_pressed()
	if Input.is_action_just_pressed("right"):
		_on_next_pressed()
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://vilperi/cutscene.tscn")

func _on_prev_pressed() -> void:
	current_mask_index = (current_mask_index - 1 + masks.size()) % masks.size()
	update_mask_display()

func _on_next_pressed() -> void:
	current_mask_index = (current_mask_index + 1) % masks.size()
	update_mask_display()

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://vilperi/cutscene.tscn")


func update_mask_display() -> void:
	for i in range(masks.size()):
		set_model_visibility(i, i == current_mask_index)

func set_model_visibility(index: int, is_visible: bool) -> void:
	if (is_visible):
		masks[index].show()
	else:
		masks[index].hide()
