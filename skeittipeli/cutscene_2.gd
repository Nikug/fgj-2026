extends Node2D

@onready var pigeon_call_audio_player = $PigeonCall
@onready var coffee: AnimatedSprite2D = $coffee
@onready var pigeon: AnimatedSprite2D = $pigeon

var time_elapsed: float = 0.0
var fade_duration: float = 1.0 # Duration of fade transition in seconds
var hold_duration: float = 1.0 # Duration to hold each image in seconds
var state: String = "fade_in" # States: "fade_in", "hold", "fade_out"
var current_sprite: AnimatedSprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
  coffee.play()
  current_sprite = coffee
  coffee.modulate.a = 0.0
  pigeon.modulate.a = 0.0


func _process(delta):
    if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("click"):
        get_tree().change_scene_to_file("res://main2.tscn")

    time_elapsed += delta

    match state:
        # Fade picture in
        "fade_in":
            if time_elapsed >= fade_duration:
                current_sprite.modulate.a = 1.0
                state = "hold"
                time_elapsed = 0.0
            else:
                var fade_progress = time_elapsed / fade_duration
                current_sprite.modulate.a = fade_progress

        # Hold picture completely visible
        "hold":
            if time_elapsed >= hold_duration:
                state = "fade_out"
                time_elapsed = 0.0

        # Fade picture out
        "fade_out":
            # Fade out complete
            if time_elapsed >= fade_duration:
                if current_sprite == pigeon:
                    finish_cutscene()
                else:
                  pigeon.play()
                  pigeon_call_audio_player.play()
                  current_sprite = pigeon
                  state = "fade_in"
                  time_elapsed = 0.0

            # Update fade out
            else:
                var fade_progress = time_elapsed / fade_duration
                current_sprite.modulate.a = 1.0 - fade_progress

func finish_cutscene():
    get_tree().change_scene_to_file("res://main2.tscn")