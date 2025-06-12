extends CharacterBody2D

const SPEED = 1000.0
const JUMP_VELOCITY = -400.0

@onready var wall_detector := $wall_detector as RayCast2D
@onready var fall_detector := $fall_detector as RayCast2D
@onready var texture := $texture as Sprite2D
@onready var anim := $anim

var direction := -1
var original_wall_detector_position := Vector2.ZERO
var original_fall_detector_position := Vector2.ZERO
var original_wall_cast_to := Vector2.ZERO
var original_fall_cast_to := Vector2.ZERO

func _ready() -> void:
	original_wall_detector_position = wall_detector.position
	original_fall_detector_position = fall_detector.position
	original_wall_cast_to = wall_detector.target_position
	original_fall_cast_to = fall_detector.target_position

func _physics_process(delta: float) -> void:
	# Aplica gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Inverte direção ao colidir com parede
	if wall_detector.is_colliding():
		direction *= -1

	# Inverte direção ao detectar buraco
	if not fall_detector.is_colliding():
		direction *= -1

	# Atualiza direção visual do sprite
	texture.flip_h = direction == -1

	# Atualiza posição e direção dos detectores
	wall_detector.position.x = original_wall_detector_position.x * direction
	wall_detector.target_position.x = original_wall_cast_to.x * direction

	fall_detector.position.x = original_fall_detector_position.x * direction
	fall_detector.target_position.x = original_fall_cast_to.x * direction

	# Verifica animação de "hurt"
	if anim.current_animation == "hurt":
		await anim.animation_finished
		queue_free()

	# Movimento horizontal
	velocity.x = direction * SPEED * delta
	move_and_slide()

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
