extends Area2D


@onready var animated_sprite_2: AnimatedSprite2D = $skater
@onready var plague_mask_sprite: AnimatedSprite2D = $plague_mask
@onready var hockey_mask_sprite: AnimatedSprite2D = $hockey_mask
@onready var ghost_mask_sprite: AnimatedSprite2D = $ghost_mask

signal player_fell

var isDead: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass # Replace with function body.

func _physics_process(delta: float) -> void:
    for body in get_overlapping_bodies():
        if not isDead and body is not CharacterBody2D:
            isDead = true
            play_fall_animation()
            player_fell.emit()

func play_skate_animation():
    animated_sprite_2.play("skate")
    plague_mask_sprite.play("skate")
    hockey_mask_sprite.play("skate")
    ghost_mask_sprite.play("skate")

func play_fall_animation():
    animated_sprite_2.play("fall")
    plague_mask_sprite.play("fall")
    hockey_mask_sprite.play("fall")
    ghost_mask_sprite.play("fall")

func play_jump_animation():
    animated_sprite_2.play("jump")
    plague_mask_sprite.play("jump")
    hockey_mask_sprite.play("jump")
    ghost_mask_sprite.play("jump")

func cancelDie():
    isDead = false
