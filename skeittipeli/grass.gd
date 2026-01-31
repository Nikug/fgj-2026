extends Node2D

@onready var line: Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  var polygon: Polygon2D = get_parent().get_node("Polygon2D")
  if polygon.polygon.size() > 0:
    line.points = polygon.polygon.slice(0, polygon.polygon.size() - 3)
