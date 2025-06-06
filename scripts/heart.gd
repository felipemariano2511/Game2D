extends Area2D

signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("idle")
	
func _on_body_entered(body):
	if body.name == "Player":
		ItemManager.collect_item("heart")
		queue_free()
