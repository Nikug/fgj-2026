extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if Input.is_action_just_pressed("ui_cancel"):
        get_tree().change_scene_to_file("res://vilperi/MaskSelect.tscn")


func show_message(text):
    $Message.text = text
    $Message.show()
    $MessageTimer.start()

func _on_message_timer_timeout():
    $Message.hide()

func show_game_over():
    show_message("You fell!")
    await $MessageTimer.timeout

    get_tree().change_scene_to_file("res://vilperi/MaskSelect.tscn")

func update_score(score):
    $ScoreLabel.text = str(score)


func _on_button_pressed():
    get_tree().change_scene_to_file("res://vilperi/MaskSelect.tscn")
