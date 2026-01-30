extends Node2D

@export var ground_angle: float = -30.0

@onready var ground_scene: PackedScene = preload("res://ground.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var start = Vector2(0, 0)
  self.rotate(deg_to_rad(ground_angle))

  for i in range(0, 10):
    var ground: Node2D = ground_scene.instantiate();
    ground.position = start
    ground.position.x -= ground.get_width()

    add_child(ground)

    var segment = ground.generate_segment()
    ground.set_segment(segment)
    var width = ground.get_width()
    start.x -= width
