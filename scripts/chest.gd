extends Area2D

const heart_instance = preload("res://prefabs/heart_rigid.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if body.name == "player":
		$anim.play("default")

func _on_anim_animation_finished() -> void:
	create_heart()
	await get_tree().create_timer(0.7).timeout
	queue_free()
	
func create_heart():
	var heart = heart_instance.instantiate()
	get_parent().call_deferred("add_child", heart)
	heart.global_position = $spawn_heart.global_position
	heart.apply_impulse(Vector2(randi_range(-50, 50), -150))
	
