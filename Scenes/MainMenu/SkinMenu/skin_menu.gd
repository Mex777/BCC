extends Node2D

# Lista denumirilor skin-urilor
const SKIN_NAMES = ["Prisoner", "Fighter", "Princess"]

@onready var skin_buttons = [
	$VBoxContainer/HBoxContainer/Skin1Btn,
	$VBoxContainer/HBoxContainer/Skin2Btn,
	$VBoxContainer/HBoxContainer/Skin3Btn
]
@onready var options_menu = get_tree().get_first_node_in_group("options_menu")  # Găsește meniul de opțiuni

func _ready() -> void:
	# Conectăm fiecare buton la funcția de schimbare a skin-ului
	for i in range(skin_buttons.size()):
		if skin_buttons[i] != null:
			skin_buttons[i].connect("pressed", Callable(self, "_on_skin_button_pressed").bind(SKIN_NAMES[i]))
		else:
			print("Button missing at index: ", i)

func _on_skin_button_pressed(skin_name: String) -> void:
	print("Skin selected: ", skin_name)
	Player.set_skin(skin_name)
	SettingsManager.settings["aurora"]["skin"] = skin_name
	SettingsManager.save_settings()


# Salvăm skin-ul selectat în config
func _save_skin_to_config(skin_name: String) -> void:
	var config = ConfigFile.new()
	if config.load("res://settings.cfg") == OK:
		config.set_value("aurora", "skin", skin_name)
		config.save("res://settings.cfg")

# Încărcăm skin-ul selectat la pornire
func _load_skin_from_config() -> void:
	var config = ConfigFile.new()
	if config.load("res://settings.cfg") == OK:
		var saved_skin = config.get_value("aurora", "skin", "Prisoner")  # Skin implicit
		Player.set_skin(saved_skin)

func _on_BackBtn_pressed() -> void:
	self.hide()
	if options_menu:
		options_menu.show()
