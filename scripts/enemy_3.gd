extends CharacterBody2D

const SPEED = 50.0
const ATTACK_SPEED = 80.0
const PATROL_RANGE = 50.0
const ATTACK_DISTANCE = 50.0
const ATTACK_DURATION = 0.5  # tempo em ataque
const PLAYER_HEAD_OFFSET_Y = -15.0  # ajuste conforme o tamanho do sprite do player

@onready var texture := $texture as Sprite2D
@onready var wall_detector := $wall_detector as RayCast2D
@onready var anim := $anim  # AnimationPlayer ou AnimatedSprite2D

var player: CharacterBody2D = null
var start_position := Vector2.ZERO  # posição de origem
var direction := -1
var is_attacking = false
var is_returning_to_spawn = false
var attack_timer := 0.0

func _ready() -> void:
	start_position = global_position
	# Busca player pelo grupo "player"
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	else:
		print("Player não encontrado no grupo 'player'")

func _physics_process(delta: float) -> void:
	if player == null:
		# Se player não existe, não faz nada
		velocity = Vector2.ZERO
		return
		
	if anim.current_animation == "hurt":
		await anim.animation_finished
		queue_free()

	# Ajusta para mirar na cabeça do player
	var player_head_pos = player.global_position + Vector2(0, PLAYER_HEAD_OFFSET_Y)
	var to_player = player_head_pos - global_position
	var distance_to_player = to_player.length()

	# Estado: Atacando
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			is_returning_to_spawn = true
			anim.play("fly")

		var attack_direction = to_player.normalized()
		velocity = attack_direction * ATTACK_SPEED

	# Estado: Retornando para o spawn
	elif is_returning_to_spawn:
		var to_spawn = start_position - global_position
		if to_spawn.length() < 5.0:
			is_returning_to_spawn = false
			velocity = Vector2.ZERO
		else:
			var return_direction = to_spawn.normalized()
			velocity = return_direction * SPEED

	# Estado: Patrulha
	else:
		# Se o player estiver próximo, iniciar ataque
		if distance_to_player < ATTACK_DISTANCE:
			is_attacking = true
			attack_timer = ATTACK_DURATION
			anim.play("attack")
		else:
			# Movimento de patrulha entre limites
			var offset = global_position.x - start_position.x
			if abs(offset) > PATROL_RANGE:
				direction *= -1

			velocity = Vector2(direction * SPEED, 0)

			if wall_detector.is_colliding():
				direction *= -1
				wall_detector.position.x *= -1

			if not anim.is_playing():
				anim.play("fly")

	# Flip sprite
	texture.flip_h = velocity.x > 0

	move_and_slide()
	
func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		queue_free()
		
	
