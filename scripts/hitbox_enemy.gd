extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_entered(area: Area2D) -> void:
	if area.name == "damagebox":
		$"../anim".play("hurt")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	pass # Replace with function body.
