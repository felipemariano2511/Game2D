extends CharacterBody2D

const SPEED = 80.0
const JUMP_VELOCITY = -250.0
const FIREBALL := preload("res://scenes/fire_ball.tscn")
const ATTACK_DELAY = 0.8  # Tempo entre ataques
const ATTACK_TIME = 0.6  # Tempo específico para o ataque ocorrer (em segundos)

var is_attacking := false
var attack_timer = 0.0
var has_attacked = false  # Variável para garantir que o ataque ocorra apenas uma vez

func _physics_process(delta: float) -> void:
	# Adiciona o tempo de ataque
	if is_attacking:
		attack_timer += delta
		
		# Se o ataque atingiu o tempo de 0.6 segundos, cria a fireball
		if attack_timer >= ATTACK_TIME and not has_attacked:
			perform_attack()
			has_attacked = true
		
		# Se o ataque durou mais que o tempo de delay, reseta o estado de ataque
		if attack_timer >= ATTACK_DELAY:
			is_attacking = false
			has_attacked = false  # Reseta a flag de ataque para o próximo ataque
			attack_timer = 0.0  # Reseta o temporizador

	# Adicionar gravidade.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	else:
		# Se o personagem não estiver atacando, decidir entre "walk" ou "idle"
		if velocity.x != 0 and not is_attacking:
			$anim.play("run")
		elif not is_attacking:
			$anim.play("idle")

	# Lidar com o pulo.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		if(not is_attacking):
			$anim.play("jump")  # Animação de pulo

	# Inicia o ataque se o botão for pressionado e não estiver atacando.
	if Input.is_action_just_pressed("attack") and is_on_floor() and not is_attacking:
		start_attack()

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

# Função chamada para iniciar o ataque
func start_attack():
	is_attacking = true
	$anim.play("attack")  # Reproduz a animação de ataque
	attack_timer = 0.0  # Reseta o temporizador do ataque
	has_attacked = false  # Reseta a flag para garantir que o ataque aconteça no momento correto

# Função chamada para realizar o ataque após 0.6 segundos
func perform_attack():
	var fireball_instance = FIREBALL.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	if sign($fireball_point.position.x) == 1:
		fireball_instance.set_direction(1)
	else:
		fireball_instance.set_direction(-1)
	get_parent().add_child(fireball_instance)
	fireball_instance.position = $fireball_point.global_position
