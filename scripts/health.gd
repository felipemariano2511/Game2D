extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$anim.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_player_player_stats_changed(player) -> void:
	$bar.size.x = 70 * player.health / player.max_health
