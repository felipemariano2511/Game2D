extends Area2D

signal end_animation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("default")


func _process(delta: float) -> void:
	pass


func _on_anim_animation_finished() -> void:
	emit_signal("end_animation")
	queue_free()
