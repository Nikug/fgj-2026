extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func _on_message_timer_timeout():
	$Message.hide()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout

	get_tree().change_scene_to_file("res://main.tscn")

func update_score(score):
	$ScoreLabel.text = str(score)
