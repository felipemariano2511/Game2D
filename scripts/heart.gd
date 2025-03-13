extends Area2D

signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("idle")
	#connect("body_entered", self, "_on_body_entered")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	queue_free()
	emit_signal("collected")
