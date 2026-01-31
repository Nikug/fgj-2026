extends Node2D

@export var resolution: int = 50
@export var segment_width: float = 500.0
@export var segment_height: float = 500.0
@export var noise_strength: float = 50.0
@export var decline_rate: float = 2.0

@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon: Polygon2D = $Polygon2D
@onready var fast_noise_lite: FastNoiseLite = FastNoiseLite.new()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  fast_noise_lite.set_seed(randi())
  fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
  fast_noise_lite.fractal_ping_pong_strength = 0.3
  fast_noise_lite.frequency = 0.5

func set_segment(segment: PackedVector2Array) -> void:
  polygon.polygon = segment
  collision_polygon.polygon = segment


func generate_segment(previous_height: float) -> Array:
  var new_segment: PackedVector2Array = PackedVector2Array()
  var left_height: float = previous_height

  new_segment.append(Vector2(0, previous_height))

  for i in range(1, resolution):
    var x: float = -i * segment_width / resolution
    var y: float = fast_noise_lite.get_noise_2d(x, 0) * noise_strength
    print("noise: ", y)
    left_height += y + decline_rate
    new_segment.append(Vector2(x, left_height))

  # Last point in the generated line
  new_segment.append(Vector2(-segment_width, left_height))
  # Points to create bottom of the shape
  new_segment.append(Vector2(-segment_width, left_height + segment_height))
  new_segment.append(Vector2(0, segment_height + left_height))
  return [new_segment, previous_height, left_height]

func get_width() -> float:
  return segment_width


func get_center() -> Vector2:
  return Vector2(segment_width / 2, segment_height / 2)


func get_top_right_corner() -> Vector2:
  return Vector2(segment_width, 0)
