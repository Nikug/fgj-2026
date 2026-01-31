extends Node2D
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_game():
	score = 0
	$Hud.update_score(score)
	$Hud.show_message("Time to skate")
	$ScoreTimer.start()

func _on_score_timer_timeout():
	score += 1
	$Hud.update_score(score)
