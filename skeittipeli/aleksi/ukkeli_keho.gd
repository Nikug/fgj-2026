extends Area2D

signal player_fell

var isDead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func _physics_process(delta: float) -> void:
    for body in get_overlapping_bodies():
        if not isDead and body is not CharacterBody2D:
            isDead = true
            player_fell.emit()
