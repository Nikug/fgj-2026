extends Node2D

@onready var collision_polygon: CollisionPolygon2D = $Polygon2D/StaticBody2D/CollisionPolygon2D
@onready var polygon: Polygon2D = $Polygon2D

var timer: float = 0.0
var limit: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  if timer > limit:
    timer = 0
    generate_new_polygon_shape()
  else:
    timer += delta

func generate_new_polygon_shape() -> void:
  var new_polygon: PackedVector2Array = PackedVector2Array()
  for i in range(0, collision_polygon.polygon.size()):
    new_polygon.append(collision_polygon.polygon[i] + Vector2(randf() * 100, randf() * 100))
  collision_polygon.polygon = new_polygon