extends Node

var collected_items = {
	"coin": 0
}

signal item_updated(item_type, new_amount)
signal item_collected(item_type)

func collect_item(item_type: String):
	if item_type == "coin":
		collected_items["coin"] += 1
		emit_signal("item_updated", item_type, collected_items["coin"])
	else:
		emit_signal("item_collected", item_type)
