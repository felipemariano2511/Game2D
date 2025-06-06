extends Area2D
@onready var anim: AnimatedSprite2D = $anim

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("idle")
	ItemManager.connect("item_collected", Callable(self, "_on_item_collected"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	$anim.play("collect")
	if body.name == "player":
		print("Entrou")
		ItemManager.collect_item("coins")
		queue_free()


func _on_anim_animation_finished() -> void:
	queue_free()
