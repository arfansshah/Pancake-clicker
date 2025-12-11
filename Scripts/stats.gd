extends VBoxContainer

@onready var pancake_label: Label = $PancakeLabel



func _on_control_pancake_changed(amount) -> void:
	pancake_label.text = str(amount) + "  Pancakes"
