extends CharacterBody2D

@onready var remote_trasnform := $remote as RemoteTransform2D
@onready var ray_right: RayCast2D = $ray_right
@onready var ray_left: RayCast2D = $ray_left
@onready var ray_down: RayCast2D = $ray_down
@onready var ray_top: RayCast2D = $ray_top

const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const FIREBALL := preload("res://item/fire_ball.tscn")

var is_attacking := false
var player_life := 100
var knockback_vector := Vector2.ZERO
var is_hurted := false


func _physics_process(delta: float) -> void:
	# Adicionar gravidade.
	if !is_on_floor():
		velocity += get_gravity() * delta


	# Lidar com o pulo.
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

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

	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	for platforms in get_slide_collision_count():
		var collision = get_slide_collision(platforms)
		
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)
		
	move_and_slide()
	set_state()

# Função para decidir qual animação será exibida
func set_state():
	var state := "idle"
	
	if is_attacking:
		state = "attack"

	elif is_hurted:
		state = "hurt"
	
	elif !is_on_floor():
		state = "jump"

	# Se a tecla "down" for pressionada enquanto está no chão, animação de "down"
	elif Input.is_action_just_pressed("down") and is_on_floor():
		state = "landing"

	# Se o personagem está se movendo, animação de "run"
	elif velocity.x != 0:
		state = "run"	

	if $anim.name != state:
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

func _on_hurtbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemies"):
		#queue_free()
	var direction := Input.get_axis("left", "right")
	
	if player_life <= 0:
		queue_free()
	else:
		if ray_right.is_colliding():
			take_damage(Vector2(-150,-150))
			
		if ray_left.is_colliding():
			take_damage(Vector2(150,-150))
			
		if ray_down.is_colliding():
			if direction > 0:
				take_damage(Vector2(-150,-150))
			else:
				take_damage(Vector2(150,-150))
				
		if ray_top.is_colliding():
			if direction > 0:
				take_damage(Vector2(-150,-150))
			else:
				take_damage(Vector2(150,-150))		
func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_trasnform.remote_path =camera_path
	
func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		
		knockback_vector = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		$texture.modulate = Color(1,0,0,1)
		knockback_tween.parallel().tween_property($texture, "modulate", Color(1,1,1,1), duration)
	
	is_hurted = true
	await get_tree().create_timer(0.7).timeout
	is_hurted = false
