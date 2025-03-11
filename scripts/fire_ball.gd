extends Area2D

const SPEED := 150

var velocity := Vector2.ZERO
var direction := -1

func _ready() -> void:
	pass # Replace with function body.
	
func set_direction(dir):
	direction = dir
	if(direction == 1):
		$collision/anim.flip_h = false
	else:
		$collision/anim.flip_h = true

func _process(delta: float) -> void:
	velocity.x = SPEED * delta * direction
	translate(velocity)


func _on_visibility_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
