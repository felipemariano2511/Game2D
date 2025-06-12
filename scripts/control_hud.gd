extends Control
@onready var coins_counter: Label = $container/coins_container/coins_counter as Label
var coins = 0
var collect_coin = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	coins_counter.text = str("%04d" % coins)
	ItemManager.connect("item_updated", Callable(self, "_on_item_updated"))
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:		
	coins_counter.text = str("%04d" % coins)

func _on_item_updated(item_type: String, new_amount: int):
	if item_type == "coin":
		coins += 1
		collect_coin = true
