extends Node3D

@export var rotation_speed: float = 0.6  # Radians per second

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    rotate_y(rotation_speed * delta)
    rotate_x(rotation_speed * delta)
    pass
