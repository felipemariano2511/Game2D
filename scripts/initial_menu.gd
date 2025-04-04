extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim_player.play("idle")
	$anim_enemy.play("enemy_1")
	$anim_enemy2.play("enemy2")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("start"):
<<<<<<< HEAD
		get_tree().change_scene_to_file("res://scenes/grass_land.tscn")
=======
		get_tree().change_scene_to_file("res://scenes/world_1.tscn")
>>>>>>> 69b8ffca9883176b47ac6cd15001624479c1dd03

func _on_button_start_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/grass_land.tscn")
