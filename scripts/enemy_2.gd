extends CharacterBody2D


const SPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var fall_detector := $fall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var anim := $anim 

var direction := -1

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if !fall_detector.is_colliding():
		direction *= -1
		fall_detector.position.x *= -1

	
	if direction == 1:
		texture.flip_h = false
	else:
		texture.flip_h = true
		
	if anim.current_animation == "hurt":
		await anim.animation_finished
		queue_free()
		
	velocity.x = direction * SPEED * delta

	move_and_slide()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
