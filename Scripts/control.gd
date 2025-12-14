extends Control
const save_path = "user://userdata.save"
@onready var upgrade_button = $RightPanel/CpsUpgradeButton
@onready var cps_label: Label = $LeftPanel/MarginContainer/Stats/PancakeLabel2
@onready var farm_button: Button = $RightPanel/BuyFarmButton
var pancake = 0
var amount_per_click = 1
var cps = 0
var cps_upgrade_value = 2
signal pancake_changed
signal pancake_clicked 

func _ready() -> void:
	load_data()
	emit_signal("pancake_changed", pancake)
	upgrade_button.pressed.connect(_on_upgrade_pressed)
	update_upgrade_text()
	update_cps_text()
	farm_button.pressed.connect(_on_buy_farm_pressed)
	update_farm_text()
	
	# Create and setup income timer
	var income_timer = Timer.new()
	income_timer.wait_time = 1.0
	income_timer.autostart = true
	income_timer.timeout.connect(_on_incometimer_timeout)
	add_child(income_timer)

func save_data():
	var data = {
		"pancake": pancake,
		"amount_per_click": amount_per_click,
		"cps": cps,
		"upgrade_cost": upgrade_cost,
		"farms": farms,
		"farm_cost": farm_cost
	}
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
			amount_per_click = data.get("amount_per_click", 1)
			cps = data.get("cps", 0)
			upgrade_cost = data.get("upgrade_cost", 25)
			farms = data.get("farms", 0)
			farm_cost = data.get("farm_cost", 100)
	else:
		save_data()

func _on_click_button_button_down() -> void:
	pancake += amount_per_click
	emit_signal("pancake_changed", pancake) 
	emit_signal("pancake_clicked", amount_per_click)
	update_cps_text() 
	save_data() 

var upgrade_cost := 25

func update_upgrade_text():
	upgrade_button.text = "+2 CPS\nCost: " + str(upgrade_cost)

func _on_upgrade_pressed():
	if pancake >= upgrade_cost:
		pancake -= upgrade_cost
		cps += 2  # Adds 2 to CPS (per second income)
		upgrade_cost = int(upgrade_cost * 1.5)
		emit_signal("pancake_changed", pancake)
		update_upgrade_text()
		update_cps_text()
		save_data()

func update_cps_text():
	cps_label.text = str(cps) + " per second"

var farms := 0
var pancakes_per_farm := 1
var farm_cost := 100

# Removed duplicate/unused timer function
func _on_buy_farm_pressed() -> void:
	if pancake >= farm_cost:
		pancake -= farm_cost
		farms += 1
		farm_cost = int(farm_cost * 1.4)
		emit_signal("pancake_changed", pancake)
		update_farm_text()
		save_data()

func update_farm_text():
	farm_button.text = "Grandma\n(+1 pancake)\nCost: " \
		+ str(farm_cost)

# This timer should tick every second to generate income
func _on_incometimer_timeout() -> void:
	var income := 0
	# CPS income
	income += cps
	# Farm income
	if farms > 0:
		income += farms * pancakes_per_farm
	if income > 0:
		pancake += income
		emit_signal("pancake_changed", pancake)
		save_data()
