extends Node2D

@export var start_point: Vector2 = Vector2(0, 0)
@export var noise_increase: float = 0.2
@export var slope_increase: float = 0.01
@export var max_slope: float = 10.0

@onready var ground_scene: PackedScene = preload("res://ground.tscn")
@onready var main: Node2D = $"/root/Main2"

var initial_segments: int = 2
var current_index: int = 0
var segment_width: float = 0.0

# don't touch
var start = start_point
var slope: float = 1.0
var noisiness: float = 1.0
var previous_height: float = 0.0
# can touch now again

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  current_index = initial_segments

  # Initial map
  for i in range(0, initial_segments):
    _add_segment()

func _process(_delta: float) -> void:
  var player = get_node("/root/Main2/Pelaaja")
  if (player == null):
    return

  var player_position = player.position
  var distance_to_player = player_position.distance_to(start_point)
  var generated_map_width = segment_width * current_index
  if (distance_to_player > generated_map_width - 1000):
    _add_segment()
    current_index += 1

func _add_segment() -> void:
    var ground: Node2D = ground_scene.instantiate();
    ground.main = main
    add_child(ground)
    segment_width = ground.get_width()

    ground.position = start
    ground.position.x += ground.get_width()

    ground.noise_strength = noisiness
    ground.decline_rate = slope
    slope += min(slope_increase, max_slope)
    noisiness += noise_increase

    var arr = ground.generate_segment(previous_height)
    var segment = arr[0]
    # var right_height = arr[1]
    var left_height = arr[2]
    previous_height = left_height

    ground.set_segment(segment)
    var width = ground.get_width()
    start.x -= width