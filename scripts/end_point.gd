extends Area2D
@onready var anim: AnimatedSprite2D = $anim
@export var next_level: String

func _ready() -> void:
	anim.play("default")
