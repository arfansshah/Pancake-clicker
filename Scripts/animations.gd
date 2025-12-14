extends MarginContainer

@onready var click_button: TextureButton = $CenterContainer/ClickButton
@onready var indicators: Control = $"../../Indicators"
@onready var template: Label = $"../../Indicators/Template"
@export var indicator_scene: PackedScene


var cookies_per_click = 1


func _ready() -> void:
	click_button.pivot_offset = click_button.size  / 2

func _on_click_button_button_down() -> void:
	var tween= get_tree().create_tween()
	tween.tween_property(click_button,"scale",  Vector2(.9,.9),.1)


func _on_click_button_button_up() -> void:
	var tween= get_tree().create_tween()
	tween.tween_property(click_button,"scale",  Vector2(1,1),.1)


func _on_control_pancake_clicked(amount) -> void:
	if indicator_scene == null:
		return

	var indicator = indicator_scene.instantiate()
	indicator.text = "+" + str(amount)
	indicator.global_position = get_global_mouse_position()
	indicator.visible = true
	indicators.add_child(indicator)
	indicator.get_child(0).start()
