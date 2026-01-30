extends AnimatedSprite2D

@onready var audio_player = $PigeonCall

# Called when the node enters the scene tree for the first time.
func _ready():
	play('annoy')
	# Preload audio to avoid delay on first play
	audio_player.play()
	audio_player.stop()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var mouse_pos = get_global_mouse_position()
		var texture = sprite_frames.get_frame_texture(animation, frame)
		if texture:
			var texture_size = texture.get_size()
			var rect = Rect2(global_position - texture_size / 2, texture_size)
			if rect.has_point(mouse_pos):
				audio_player.stop()
				audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
