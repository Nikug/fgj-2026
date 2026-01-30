extends AnimatedSprite2D

@onready var audio_player = $PigeonCall
var time_until_next_sound = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	play('idle')
	# Set initial random interval
	time_until_next_sound = randf_range(5.0, 10.0)
	# Connect to audio finished signal
	audio_player.finished.connect(_on_sound_finished)

func _on_sound_finished():
	play('idle')

func _input(event):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_until_next_sound -= delta
	if time_until_next_sound <= 0:
		play('annoy')
		audio_player.play()
		# Set next random interval
		time_until_next_sound = randf_range(5.0, 10.0)
