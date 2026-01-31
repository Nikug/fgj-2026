extends AnimatedSprite2D

var time_until_next = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	play("wiggle")
	time_until_next = randf_range(5.0, 10.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time_until_next -= delta
	if time_until_next <= 0:
		play('fall')
		# Set next random interval
		time_until_next = randf_range(5.0, 10.0)
