extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const FIREBALL := preload("res://item/fire_ball.tscn")
const ATTACK_DELAY = 0.8  # Tempo entre ataques

var is_attacking := false
var attack_timer = 0.0

func _physics_process(delta: float) -> void:
	
	# Adicionar gravidade.
	if !is_on_floor():
		velocity += get_gravity() * delta
		
	else:
		# Se o personagem não estiver atacando, decidir entre "walk" ou "idle"
		if velocity.x != 0 and !is_attacking:
			$anim.play("run")
		elif !is_attacking:
			if is_on_floor() and Input.is_action_just_pressed("down"):
				$anim.play("lading")
			else:
				$anim.play("idle")

	# Lidar com o pulo.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		if !is_attacking:
			$anim.play("jump")  # Animação de pulo

	# Inicia o ataque se o botão for pressionado e não estiver atacando.
	if Input.is_action_just_pressed("attack") and is_on_floor() and !is_attacking:
		is_attacking = true

	# Obter direção de entrada e lidar com movimento/desaceleração.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flipar a animação com base na direção
	if velocity.x > 0:
		$texture.flip_h = false
		if sign($fireball_point.position.x) == -1:
			$fireball_point.position.x *= -1
			
	elif velocity.x < 0:
		$texture.flip_h = true
		if sign($fireball_point.position.x) == 1:
			$fireball_point.position.x *= -1

	move_and_slide()
	set_animation()
	
func set_animation():
	var state := "idle"
	
	if !is_on_floor():
		state = "jump"
		
	elif velocity.x != 0:
		state = "run"
	
	if is_attacking:
		state = "attack"
		
	if $anim.assigned_animation != state:
		$anim.play(state)

# Função chamada para realizar o ataque após 0.6 segundos
func cast_fireball():
	var fireball_instance = FIREBALL.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	if sign($fireball_point.position.x) == 1:
		fireball_instance.set_direction(1)
	else:
		fireball_instance.set_direction(-1)
	get_parent().add_child(fireball_instance)
	fireball_instance.position = $fireball_point.global_position
	await($anim)
	is_attacking = false
