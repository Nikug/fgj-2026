extends Button

@export var direction: String = "left" # "left" or "right"

func _ready():
    self.flat = true
    self.text = ""

func _draw():
    var points = []
    var w = size.x
    var h = size.y
    if direction == "left":
        points = [Vector2(w, 0), Vector2(0, h / 2), Vector2(w, h)]
    else:
        points = [Vector2(0, 0), Vector2(w, h / 2), Vector2(0, h)]
    # Gold fill
    draw_polygon(points, [Color(0.573, 0.518, 0.18, 0.392)])
    # Silver outline
    points.append(points[0]) # Close the triangle
    draw_polyline(points, Color(0.451, 0.451, 0.451, 0.396), 4.0)
