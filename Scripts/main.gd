extends Node2D

var cookies: float = 0
var cookies_per_click: int = 1
var cookies_per_second: float = 0

var click_upgrade_cost: int = 50

var cursor_cost: int = 15
var grandma_cost: int = 100
var farm_cost: int = 500

var cursor_power: float = 1
var grandma_power: float = 5
var farm_power: float = 20

@onready var cookie_button = $CookieButton
@onready var label = $CookieLabel
@onready var auto_timer = $AutoTimer

@onready var cursor_btn = $ShopContainer/CursorButton
@onready var grandma_btn = $ShopContainer/GrandmaButton
@onready var farm_btn = $ShopContainer/FarmButton
@onready var click_btn = $ClickUpgradeButton

func _ready():
	connect_signals()
	load_game()
	update_ui()
	auto_timer.start()

func connect_signals():
	cookie_button.pressed.connect(_on_cookie_pressed)
	cursor_btn.pressed.connect(_on_buy_cursor)
	grandma_btn.pressed.connect(_on_buy_grandma)
	farm_btn.pressed.connect(_on_buy_farm)
	click_btn.pressed.connect(_on_click_upgrade)
	auto_timer.timeout.connect(_on_auto_timer_timeout)

func _on_cookie_pressed():
	cookies += cookies_per_click
	cookie_button.scale = Vector2(1.6, 1.6) # bounce animation
	update_ui()

func _process(delta):
	cookie_button.scale = lerp(cookie_button.scale, Vector2(1.5, 1.5), 10 * delta)

func _on_auto_timer_timeout():
	cookies += cookies_per_second
	update_ui()

func _on_buy_cursor():
	if cookies >= cursor_cost:
		cookies -= cursor_cost
		cookies_per_second += cursor_power
		cursor_cost = int(cursor_cost * 1.25)
		update_ui()

func _on_buy_grandma():
	if cookies >= grandma_cost:
		cookies -= grandma_cost
		cookies_per_second += grandma_power
		grandma_cost = int(grandma_cost * 1.3)
		update_ui()

func _on_buy_farm():
	if cookies >= farm_cost:
		cookies -= farm_cost
		cookies_per_second += farm_power
		farm_cost = int(farm_cost * 1.4)
		update_ui()

func _on_click_upgrade():
	if cookies >= click_upgrade_cost:
		cookies -= click_upgrade_cost
		cookies_per_click += 1
		click_upgrade_cost = int(click_upgrade_cost * 1.5)
		update_ui()

func update_ui():
	label.text = "Cookies: " + str(int(cookies)) + "\nCPS: " + str(int(cookies_per_second))

	cursor_btn.text = "Cursor (" + str(cursor_cost) + ")"
	grandma_btn.text = "Grandma (" + str(grandma_cost) + ")"
	farm_btn.text = "Farm (" + str(farm_cost) + ")"

	click_btn.text = "Click Upgrade (" + str(click_upgrade_cost) + ")"

func save_game():
	var data = {
		"cookies": cookies,
		"cpc": cookies_per_click,
		"cps": cookies_per_second,
		"cursor_cost": cursor_cost,
		"grandma_cost": grandma_cost,
		"farm_cost": farm_cost,
		"click_cost": click_upgrade_cost
	}

	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(data))

func load_game():
	if not FileAccess.file_exists("user://savegame.json"):
		return

	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())

	cookies = data["cookies"]
	cookies_per_click = data["cpc"]
	cookies_per_second = data["cps"]
	cursor_cost = data["cursor_cost"]
	grandma_cost = data["grandma_cost"]
	farm_cost = data["farm_cost"]
	click_upgrade_cost = data["click_cost"]

func _exit_tree():
	save_game()
