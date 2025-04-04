extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
		get_tree().change_scene_to_file("res://scenes/initial_menu.tscn")
	elif Input.is_action_just_pressed("esc"):
		get_tree().quit()

func _on_button_start_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/initial_menu.tscn")


func _on_button_quit_button_down() -> void:
	get_tree().quit()
