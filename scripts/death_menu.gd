extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_button_start_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/world_1.tscn")


func _on_button_quit_button_down() -> void:
	get_tree().quit()
