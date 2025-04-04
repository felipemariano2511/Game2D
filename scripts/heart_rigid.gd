extends RigidBody2D

<<<<<<< HEAD
signal collected
=======
signal collected_heart
>>>>>>> 69b8ffca9883176b47ac6cd15001624479c1dd03
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass	


<<<<<<< HEAD
func _on_heart_collected() -> void:
	emit_signal("collected")
=======



func _on_chest_destroy_rigid() -> void:
	queue_free()
>>>>>>> 69b8ffca9883176b47ac6cd15001624479c1dd03
