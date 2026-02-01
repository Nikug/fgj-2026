extends Node3D

@onready var mesh: MeshInstance3D = $MeshInstance3D

var original_material: StandardMaterial3D
var hover_color: Color = Color("3b6fff") # Sonic blue

func _ready() -> void:
    # Clone the original material so we can safely modify it
    if mesh.material_override:
        original_material = mesh.material_override.duplicate()
        mesh.material_override = original_material
    else:
        original_material = StandardMaterial3D.new()
        mesh.material_override = original_material

    mesh.input_pickable = true

func _input_event(camera, event, position, normal, shape_idx):
    if event is InputEventMouseMotion:
        mesh.material_override.albedo_color = hover_color
    elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
        _start_game_as_secret_character()
    elif event is InputEventMouseMotion and not mesh.get_viewport().gui_has_modal_stack():
        # Restore original color
        mesh.material_override.albedo_color = original_material.albedo_color

func _start_game_as_secret_character():
    # Set a global variable for secret character selection if needed
    get_tree().change_scene_to_file("res://main2.tscn")

func _process(delta: float) -> void:
    pass
