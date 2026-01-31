extends Control

# Image sequence for the cutscene
var images = [
    "res://vilperi/coffee.jpg",
	"res://vilperi/Skateboard.jpg"
]

var current_image_index = 0
var fade_duration = 1.0  # Duration of fade transition in seconds
var hold_duration = 0.5  # Duration to hold each image in seconds
var time_elapsed = 0.0
var state = "fade_in"  # States: "fade_in", "hold", "fade_out"
var is_finished = false

@onready var image_rect = $TextureRect

func _ready():
    $TextureRect.stretch_mode = 0
    # Load and display the first image
    load_image()

func _process(delta):
    if Input.is_action_just_pressed("ui_accept") or Input.is_action_just_pressed("click"):
        get_tree().change_scene_to_file("res://main2.tscn")

    time_elapsed += delta
    
    match state:
        
        # Fade picture in
        "fade_in":
            if time_elapsed >= fade_duration:
                image_rect.modulate.a = 1.0
                state = "hold"
                time_elapsed = 0.0
            else:
                var fade_progress = time_elapsed / fade_duration
                image_rect.modulate.a = fade_progress
        
        # Hold picture completely visible
        "hold":
            if time_elapsed >= hold_duration:
                state = "fade_out"
                time_elapsed = 0.0
        
        # Fade picture out
        "fade_out":
            
            # Fade out complete
            if time_elapsed >= fade_duration:
                show_next_image_or_transition()
                load_image()
                state = "fade_in"
                time_elapsed = 0.0
            
            # Update fade out
            else:
                var fade_progress = time_elapsed / fade_duration
                image_rect.modulate.a = 1.0 - fade_progress

func load_image():
    if current_image_index < images.size():
        image_rect.texture = load(images[current_image_index])
        image_rect.modulate.a = 0.0

func show_next_image_or_transition():
    current_image_index += 1
    if current_image_index >= images.size():
    # All images shown, transition to game
        finish_cutscene()
        return

func finish_cutscene():
    get_tree().change_scene_to_file("res://main2.tscn")
