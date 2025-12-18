extends Control
#SUPRISEEE
#DO U LIKE IT 
#TONGYU MSG ME IF U READ THIS
const save_path = "user://userdata.save"
@onready var upgrade_button = $RightPanel/CpsUpgradeButton
@onready var cps_label: Label = $LeftPanel/MarginContainer/Stats/PancakeLabel2
@onready var farm_button: Button = $RightPanel/BuyFarmButton

@onready var power_cps_button: Button = $RightPanel/PowerCpsButton
@onready var factory_button: Button = $RightPanel/FactoryButton

@onready var ascend_button: Button = $AscendButton



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
	power_cps_button.pressed.connect(_on_power_cps_pressed)
	update_power_cps_text()
	factory_button.pressed.connect(_on_factory_pressed)
	update_factory_text()
	ascend_button.pressed.connect(_on_ascend_pressed)
	
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
		"farm_cost": farm_cost,
		"power_cps_cost": power_cps_cost,
		"factories": factories,
		"factory_cost": factory_cost
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
			power_cps_cost = data.get("power_cps_cost", 5000)
			factories = data.get("factories", 0)
			factory_cost = data.get("factory_cost", 5000)
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
	upgrade_button.text = "+2 per click\nCost: " + str(upgrade_cost)


func _on_upgrade_pressed():
	if pancake >= upgrade_cost:
		pancake -= upgrade_cost
		amount_per_click += 2  # THIS is per click
		upgrade_cost = int(upgrade_cost * 1.5)
		emit_signal("pancake_changed", pancake)
		update_upgrade_text()
		save_data()

func update_cps_text():
	cps_label.text = "Per Click: " + str(amount_per_click)

var farms := 0
var pancakes_per_farm := 1
var farm_cost := 100

# 
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


func _on_incometimer_timeout() -> void:
	var income := 0
	
	income += cps

	if farms > 0:
		income += farms * pancakes_per_farm

	if factories > 0:
		income += factories * pancakes_per_factory
	if income > 0:
		pancake += income
		emit_signal("pancake_changed", pancake)
		save_data()


var power_cps_cost := 5000

func update_power_cps_text():
	power_cps_button.text = "+20 CPS\nCost: " + str(power_cps_cost)

func _on_power_cps_pressed():
	if pancake >= power_cps_cost:
		pancake -= power_cps_cost
		cps += 20
		power_cps_cost = int(power_cps_cost * 1.5)
		emit_signal("pancake_changed", pancake)
		update_power_cps_text()
		update_cps_text()
		save_data()


var factories := 0
var pancakes_per_factory := 20
var factory_cost := 5000

func update_factory_text():
	factory_button.text = "Factory\n(+20 pancakes)\nCost: " + str(factory_cost)

func _on_factory_pressed():
	if pancake >= factory_cost:
		pancake -= factory_cost
		factories += 1
		factory_cost = int(factory_cost * 1.4)
		emit_signal("pancake_changed", pancake)
		update_factory_text()
		save_data()


func _on_ascend_pressed():
	var dialog = ConfirmationDialog.new()
	dialog.dialog_text = "Are you sure you want to ascend? This will reset all your progress!"
	dialog.ok_button_text = "Yes"
	dialog.cancel_button_text = "No"
	add_child(dialog)
	dialog.confirmed.connect(_on_ascend_confirmed)
	dialog.canceled.connect(func(): dialog.queue_free())
	dialog.popup_centered()

func _on_ascend_confirmed():

	pancake = 0
	amount_per_click = 1
	cps = 0
	upgrade_cost = 25
	farms = 0
	farm_cost = 100
	power_cps_cost = 5000
	factories = 0
	factory_cost = 5000
	

	emit_signal("pancake_changed", pancake)
	update_upgrade_text()
	update_cps_text()
	update_farm_text()
	update_power_cps_text()
	update_factory_text()
	save_data()
# should hv split my codes more works ig
