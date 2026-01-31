extends AnimatedSprite2D

@onready var pigeon_call_audio_player = $PigeonCall
@onready var pigeon_die_audio_player = $PigeonDie

var time_until_next_sound = 0.0
var dead = false
var main: Node2D

signal pigeon_destroyed

# Called when the node enters the scene tree for the first time.
func _ready():
  play('idle')
  # Set initial random interval
  time_until_next_sound = randf_range(5.0, 10.0)
  # Connect to audio finished signal
  pigeon_call_audio_player.finished.connect(_on_sound_finished)
  self.connect("pigeon_destroyed", main._on_pigeon_destroyed)

func _on_sound_finished():
  play('idle')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
  if dead: return

  time_until_next_sound -= delta
  if time_until_next_sound <= 0:
    play('annoy')
    pigeon_call_audio_player.play()
    # Set next random interval
    time_until_next_sound = randf_range(5.0, 10.0)

func _on_area_2d_body_entered(body: Node2D) -> void:
  if body is CharacterBody2D:
    pigeon_call_audio_player.stop()
    pigeon_die_audio_player.play()
    play('die')
    dead = true
    pigeon_destroyed.emit()
