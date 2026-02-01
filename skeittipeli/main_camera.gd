extends Camera2D

@export var follow_speed: float = 100.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var player = get_node("/root/Main2/Pelaaja")
  if player != null:
    position = lerp(position, player.position, follow_speed * delta)
    var velocity: Vector2 = player.velocity
    var speed: float = velocity.length()
    var zoom_level = 1 / lerp(0.9, 1.2, speed / 1000)
    zoom = lerp(zoom, Vector2(zoom_level, zoom_level), delta * 2)
