extends Node2D

@export var start_point: Vector2 = Vector2(0, 0)

@onready var ground_scene: PackedScene = preload("res://ground.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var start = start_point
	var slope: float = 1.0

	for i in range(0, 10):
		var ground: Node2D = ground_scene.instantiate();
		add_child(ground)

		ground.position = start
		ground.position.x -= ground.get_width()

		ground.decline_rate = slope
		slope += 0.5
		var arr = ground.generate_segment()
		var segment = arr[0]
		var start_height = arr[1]
		var end_height = arr[2]
		ground.position.y -= end_height

		ground.set_segment(segment)
		var width = ground.get_width()
		start.x -= width
		start.y += start_height
