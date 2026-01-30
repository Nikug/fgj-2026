extends Node2D

@export var resolution: int = 100
@export var segment_width: float = 200.0
@export var segment_height: float = 200.0
@export var noise_strength: float = 50.0

@onready var collision_polygon: CollisionPolygon2D = $Polygon2D/StaticBody2D/CollisionPolygon2D
@onready var polygon: Polygon2D = $Polygon2D
@onready var fast_noise_lite: FastNoiseLite = FastNoiseLite.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  fast_noise_lite.set_seed(randi())
  fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
  fast_noise_lite.fractal_ping_pong_strength = 0.9

  var segment = generate_segment(Vector2(0, 0), Vector2(segment_width, 0))
  polygon.polygon = segment
  collision_polygon.polygon = segment


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  pass

func generate_segment(start_point: Vector2, end_point: Vector2) -> PackedVector2Array:
  var new_segment: PackedVector2Array = PackedVector2Array()
  new_segment.append(start_point)

  for i in range(1, resolution):
    var x: float = i * segment_width / resolution
    var y: float = fast_noise_lite.get_noise_2d(i, 0) * noise_strength
    new_segment.append(Vector2(x, y))

  new_segment.append(Vector2(segment_width, end_point.y))
  new_segment.append(Vector2(segment_width, segment_height))
  new_segment.append(Vector2(start_point.x, segment_height))

  return new_segment
