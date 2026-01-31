extends Node2D

@onready var polygon: Polygon2D = $Polygon2D
@onready var collision_polygon: CollisionPolygon2D = $Polygon2D/StaticBody2D/CollisionPolygon2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  collision_polygon.polygon = polygon.polygon
