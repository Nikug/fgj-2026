extends Node2D

@onready var line: Line2D = $Line2D

func draw_grass(points: PackedVector2Array):
  var moved_points = PackedVector2Array()
  for i in range(0, points.size()):
    moved_points.append(points[i] + Vector2(0, 16))
  line.points = moved_points
