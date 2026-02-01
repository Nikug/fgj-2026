extends Node2D

@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var sprite: Sprite2D = $Sprite2D

signal rock_destroyed
var main: Node2D

func _ready() -> void:
  self.connect("rock_destroyed", main._on_rock_destroyed)

func _on_area_2d_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D and mask.selectedMask == 2:
    particles.emitting = true
    sprite.visible = false
    rock_destroyed.emit()
