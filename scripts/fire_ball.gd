extends Area2D

const SPEED := 130

var velocity := Vector2.ZERO
var direction := -1

func _ready() -> void:
	$anim.play("idle")
	
func set_direction(dir):
	direction = dir
	if(direction == 1):
		$anim.flip_h = false
	else:
		$anim.flip_h = true

func _process(delta: float) -> void:
	velocity.x = SPEED * delta * direction
	translate(velocity)


func _on_visibility_screen_exited() -> void:
	queue_free()


func _on_body_entered(body: Node2D) -> void:
	queue_free()
