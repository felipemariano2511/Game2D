extends Area2D

const SPEED := 130
var velocity := Vector2.ZERO
var direction := -1

func _ready() -> void:
	$anim.play("idle")
	connect("body_entered", Callable(self, "_on_body_entered"))

func set_direction(dir):
	direction = dir
	$anim.flip_h = direction == -1  # Flip para esquerda

func _process(delta: float) -> void:
	velocity.x = SPEED * direction
	position += velocity * delta

func _on_visibility_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage()
	queue_free()
