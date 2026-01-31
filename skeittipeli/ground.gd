extends Node2D

@export var resolution: int = 50
@export var segment_width: float = 500.0
@export var segment_height: float = 500.0
@export var noise_strength: float = 50.0
@export var decline_rate: float = 2.0

@export var foliage_chance: float = 0.02
@export var pigeon_chance: float = 0.01

@onready var collision_polygon: CollisionPolygon2D = $StaticBody2D/CollisionPolygon2D
@onready var polygon: Polygon2D = $Polygon2D
@onready var fast_noise_lite: FastNoiseLite = FastNoiseLite.new()
@onready var perlin_noise: FastNoiseLite = FastNoiseLite.new()

@onready var tree: PackedScene = preload("res://natur/tree.tscn")
@onready var spruce: PackedScene = preload("res://natur/spruce.tscn")
@onready var rock: PackedScene = preload("res://natur/rock.tscn")
@onready var pulu: PackedScene = preload("res://maija/encounters/pigeon/pigeon.tscn")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  fast_noise_lite.set_seed(randi())
  fast_noise_lite.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
  fast_noise_lite.fractal_octaves = 1
  fast_noise_lite.frequency = 0.1
  fast_noise_lite.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
  fast_noise_lite.fractal_ping_pong_strength = 0.9

  perlin_noise.set_seed(randi())
  perlin_noise.noise_type = FastNoiseLite.TYPE_PERLIN
  perlin_noise.frequency = 0.02
  perlin_noise.fractal_octaves = 1
  perlin_noise.fractal_type = FastNoiseLite.FRACTAL_PING_PONG

func set_segment(segment: PackedVector2Array) -> void:
  polygon.polygon = segment
  collision_polygon.polygon = segment


func generate_segment(previous_height: float) -> Array:
  var new_segment: PackedVector2Array = PackedVector2Array()
  var left_height: float = previous_height

  new_segment.append(Vector2(0, previous_height))

  for i in range(1, resolution):
    var x: float = -i * segment_width / resolution
    var y: float = (perlin_noise.get_noise_1d(x) + fast_noise_lite.get_noise_1d(x)) * noise_strength
    left_height += y + decline_rate
    new_segment.append(Vector2(x, left_height))

    if (randf() < foliage_chance):
      var new_position = Vector2(x, left_height)
      _generate_foliage(new_position)

    if (randf() < pigeon_chance):
      var new_position = Vector2(x, left_height)
      _generate_pigeon(new_position)

  # Last point in the generated line
  new_segment.append(Vector2(-segment_width, left_height))
  # Points to create bottom of the shape
  new_segment.append(Vector2(-segment_width, left_height + segment_height))
  new_segment.append(Vector2(0, segment_height + left_height))
  return [new_segment, previous_height, left_height]

func _generate_pigeon(new_position: Vector2) -> void:
  var pigeon = pulu.instantiate()
  pigeon.position = new_position
  add_child(pigeon)

func _generate_foliage(new_position: Vector2) -> void:
  var foliage_scale = randf() * 2.0 + 1.0
  var mirror = randf() > 0.5

  var foliage_index = randi() % 3
  var sprte: Sprite2D
  if (foliage_index == 0):
    sprte = tree.instantiate()
  elif (foliage_index == 1):
    sprte = spruce.instantiate()
  elif (foliage_index == 2):
    sprte = rock.instantiate()

  sprte.position = new_position
  sprte.scale = Vector2(foliage_scale, foliage_scale)
  sprte.flip_h = mirror
  add_child(sprte)

func get_width() -> float:
    return segment_width


func get_center() -> Vector2:
    return Vector2(segment_width / 2, segment_height / 2)


func get_top_right_corner() -> Vector2:
    return Vector2(segment_width, 0)
