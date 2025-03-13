extends Area2D

signal collect_heart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	queue_free()
