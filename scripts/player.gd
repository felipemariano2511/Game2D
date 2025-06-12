extends CharacterBody2D

@onready var remote_trasnform := $remote as RemoteTransform2D
@onready var hitbox_player := $hitbox as Area2D
@onready var end_point: Area2D = $"../End-Point"


const SPEED = 80.0
const JUMP_VELOCITY = -280.0
const FIREBALL := preload("res://item/fire_ball.tscn")

var is_attacking := false
var knockback_vector := Vector2.ZERO
var is_hurted := false

# Status do Player
var health := 100.0
var max_health := 100.0
var mana := 100.0
var max_mana := 70.0
var mana_recovery := 2.5
var collect_heart := false

signal player_stats_changed

func _ready() -> void:
	ItemManager.connect("item_collected", Callable(self, "_on_item_collected"))
	emit_signal("player_stats_changed", self)

func _process(delta: float) -> void:
	var health_recovery := 0.0 if !collect_heart else 20.0
	var new_mana = min(mana + mana_recovery * delta, max_mana)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)

	var new_health = health + health_recovery
	if new_health > max_health:
		new_health = max_health

	if new_health < max_health + 1:
		health = new_health
		emit_signal("player_stats_changed", self)
		if collect_heart:
			collect_heart = false

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("attack") and is_on_floor() and !is_attacking:
		if mana > 10:
			is_attacking = true
			mana -= 20
			emit_signal("player_stats_changed", self)

	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	# Flip sprite e fireball point
	if velocity.x > 0:
		$texture.flip_h = false
		if sign($fireball_point.position.x) == -1:
			$fireball_point.position.x *= -1
	elif velocity.x < 0:
		$texture.flip_h = true
		if sign($fireball_point.position.x) == 1:
			$fireball_point.position.x *= -1

	# Knockback
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector

	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

	move_and_slide()
	set_state()

func set_state():
	var state := "idle"

	if is_attacking:
		state = "attack"
	elif is_hurted:
		state = "hurt"
	elif !is_on_floor():
		state = "jump"
	elif Input.is_action_just_pressed("down") and is_on_floor():
		state = "landing"
	elif velocity.x != 0:
		state = "run"

	if $anim.name != state:
		$anim.play(state)

func cast_fireball():
	var fireball_instance = FIREBALL.instantiate(PackedScene.GEN_EDIT_STATE_INSTANCE)
	fireball_instance.set_direction(sign($fireball_point.position.x))
	get_parent().add_child(fireball_instance)
	fireball_instance.position = $fireball_point.global_position
	await($anim)
	is_attacking = false

### ✅ Função corrigida: dano ao encostar em inimigo
func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		var knockback = Vector2(-sign(velocity.x) * 100, -75)
		take_damage(knockback)

func follow_camera(camera):
	remote_trasnform.remote_path = camera.get_path()

func take_damage(knockback_force := Vector2.ZERO, duration := 0.25):
	health -= 33.3

	if health <= 0:
		get_tree().change_scene_to_file("res://scenes/death_menu.tscn")
		return

	if knockback_force != Vector2.ZERO:
		knockback_vector = knockback_force
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vector", Vector2.ZERO, duration)
		$texture.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property($texture, "modulate", Color(1, 1, 1, 1), duration)

	is_hurted = true
	await get_tree().create_timer(0.7).timeout
	is_hurted = false

func load_scene(scene_name: String):
	get_tree().change_scene_to_file("res://scenes/" + scene_name + ".tscn")

func _on_end_point_area_shape_entered(area_rid: RID, area: Area2D, area_shape_index: int, local_shape_index: int) -> void:
	if end_point.is_in_group("Level-End"):
		var next_level = end_point.next_level
		if next_level:
			call_deferred("load_scene", next_level)

func _on_item_collected(item_type: String):
	if item_type == "heart":
		collect_heart = true
