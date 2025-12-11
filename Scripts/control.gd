extends Control

const save_path = "user://userdata.save"

var pancake = 0 
var amount_per_click = 1

signal pancake_changed

func save_data():
	var data = {"pancake": pancake }
	
	var file = FileAccess.open(save_path, FileAccess.WRITE) 
	file.strore_var(data)
	file.close()
	
	func load_data():
		if FileAccess.file_exists(save_path):
			var file1 = FileAccess.open(save_path, FileAccess.READ)
	
func _on_click_button_button_down() -> void:
	pancake+= amount_per_click
	emit_signal("pancake_changed",pancake)
