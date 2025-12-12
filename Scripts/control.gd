extends Control

const save_path = "user://userdata.save"

var pancake = 0
var amount_per_click = 1

signal pancake_changed
signal pancake_clicked 

func _ready() -> void:
	load_data()
	emit_signal("pancake_changed", pancake)

func save_data():
	var data = {"pancake": pancake}
	var file = FileAccess.open(save_path, FileAccess.WRITE)
	file.store_var(data)
	file.close()

func load_data():
	if FileAccess.file_exists(save_path):
		var file = FileAccess.open(save_path, FileAccess.READ)
		var data = file.get_var()
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			pancake = data.get("pancake", 0)
	else:
		save_data()

func _on_click_button_button_down() -> void:
	pancake += amount_per_click
	emit_signal("pancake_changed", pancake) 
	emit_signal("pancake_clicked",  amount_per_click)
	save_data() 
