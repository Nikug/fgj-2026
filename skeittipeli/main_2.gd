extends Node2D
var score

# Called when the node enters the scene tree for the first time.
func _ready():
    new_game()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
      if Input.is_action_just_pressed("r"):
        $Pelaaja.jump_cooldown.stop()
        $DeathTimer.stop()
        $Pelaaja.cancelDie()
        $Hud.cancel_game_over()
        new_game()

func new_game():
    score = 0
    $Hud.update_score(score)
    $Hud.show_message("Time to skeit")
    $ScoreTimer.start()
    $Pelaaja.min_speed_cooldown.start(5)
    $Pelaaja.position = $StartPosition.position
    $Pelaaja.rotation = 0.001
    $Pelaaja.velocity = Vector2.ZERO
    $Pelaaja.current_rotation_speed = 0

func end_game():
    $ScoreTimer.stop()
    $Hud.show_game_over()
    $DeathTimer.start()

func _on_score_timer_timeout():
    score += 1
    $Hud.update_score(score)


func _on_pelaaja_full_rotation():
    score += 50
    $Hud.update_score(score)

func _on_pigeon_destroyed():
    score += 10
    $Hud.update_score(score)

func _on_rock_destroyed():
    score += 10
    $Hud.update_score(score)


func _on_pelaaja_fell():
    end_game()


func _on_death_timer_timeout():
    get_tree().change_scene_to_file("res://vilperi/MaskSelect.tscn")
