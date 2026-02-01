extends AudioStreamPlayer

@onready var intro_music = preload("res://sounds/intro.wav")
@onready var main_music = preload("res://sounds/mayhem.wav")
@onready var secret_music = preload("res://sounds/sanic.wav")

var playing_intro = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    main_music.loop_mode = AudioStreamWAV.LOOP_FORWARD
    main_music.loop_begin = 0
    main_music.loop_end = main_music.get_length() * main_music.mix_rate
    secret_music.loop_mode = AudioStreamWAV.LOOP_FORWARD
    secret_music.loop_begin = 0
    secret_music.loop_end = secret_music.get_length() * secret_music.mix_rate
    if mask.selectedMask == 0:
        self.stream = secret_music
        self.volume_db -= 20
    else:
        self.stream = intro_music
    self.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
  if playing_intro and ! self.playing:
    playing_intro = false

    if (mask.selectedMask == 0):
        self.stream = secret_music
    else:
        self.stream = main_music
    self.play()
