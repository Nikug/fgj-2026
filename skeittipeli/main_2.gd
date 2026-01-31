extends Node2D
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("r"):
		new_game()

func new_game():
	score = 0
	$Hud.update_score(score)
	$Hud.show_message("Time to skate")
	$ScoreTimer.start()
	$Pelaaja.position = $StartPosition.position

func end_game():
	$Hud.show_game_over()

func _on_score_timer_timeout():
	score += 1
	$Hud.update_score(score)
