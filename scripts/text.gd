extends Node2D

@onready var texture: Sprite2D = $texture
@onready var area: Area2D = $area

const lines : Array[String] = [
	"Aperte enter ou space...",
	"Olá, aventureiro!",
	"Utilize as -> setas para andar.",
	"Utilize espaço para atirar bolas de fogo.",
	"Espero que esteja preparado...",
	"A jornada está apenas começando...",
	"Boa sorte!!!",
	"E não chegue perto das muriçocas!",
	"É sério, não chegue perto delas!",
]

func _unhandled_input(event: InputEvent) -> void:
	if area.get_overlapping_bodies().size() > 0:
		texture.show()
		if event.is_action_pressed("start"):
			if !DialogManager.is_message_active:
				texture.hide()
				DialogManager.start_message(global_position, lines)
			elif DialogManager.can_advance_message:
				DialogManager.next_line()
	else:
		texture.hide()
		if DialogManager.dialog_box != null:
			DialogManager.dialog_box.queue_free()
			DialogManager.is_message_active = false
