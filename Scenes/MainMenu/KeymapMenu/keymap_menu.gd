extends Node2D

var save_file_path := "res://keymap_settings.cfg"  # Calea către fișierul de salvare
var current_action = null  # Acțiunea curentă pentru care schimbăm tasta
@onready var options_menu = get_tree().get_first_node_in_group("options_menu")  # Găsește meniul de opțiuni

func _ready() -> void:
	_load_settings()  # Încărcăm setările salvate
	_connect_buttons()  # Conectăm semnalele butoanelor din ActionsContainer
	MusicPlayer.play_music()  # Continuă muzica în opțiuni

# Funcție care conectează semnalele butoanelor
func _connect_buttons() -> void:
	for hbox in $ActionsContainer.get_children():
		if hbox is HBoxContainer:
			var label = hbox.get_child(0)  # Primul copil este Label
			var button = hbox.get_child(1)  # Al doilea copil este Button
			if label and button:
				var action_name = label.text.to_lower().replace(" ", "_")  # Convertim textul la formatul acțiunii
				button.text = _get_current_key(action_name)  # Setăm textul inițial al butonului
				button.connect("pressed", Callable(self, "_on_rebind_pressed").bind(action_name, button))  # Conectăm semnalul

# Obține tasta curentă asociată unei acțiuni (formatează textul frumos)
func _get_current_key(action_name: String) -> String:
	var events = InputMap.action_get_events(action_name)
	for event in events:
		if event is InputEventKey:
			return event.as_text().split(" (")[0]  # Eliminăm "(Physical)" din text
		elif event is InputEventMouseButton:
			return "Mouse " + str(event.button_index)
	return "None"

# Începe procesul de schimbare a unei taste
func _on_rebind_pressed(action_name: String, button: Button) -> void:
	button.text = "Press a key..."
	current_action = action_name

# Gestionează apăsările de taste sau mouse
func _input(event: InputEvent) -> void:
	if current_action:
		if event is InputEventKey and event.pressed:
			_update_action_key(current_action, event)
		elif event is InputEventMouseButton and event.pressed:
			_update_action_key(current_action, event)

# Actualizează acțiunea cu noua tastă/buton și schimbă textul butonului
func _update_action_key(action_name: String, event: InputEvent) -> void:
	# Ștergem evenimentele curente și adăugăm noul eveniment
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)

	# Găsim butonul asociat și actualizăm textul acestuia
	for hbox in $ActionsContainer.get_children():
		if hbox is HBoxContainer:
			var label = hbox.get_child(0)
			var button = hbox.get_child(1)
			if label and button and label.text.to_lower().replace(" ", "_") == action_name:
				button.text = event.as_text().split(" (")[0]  # Eliminăm "(Physical)"
				break

	_save_settings()  # Salvăm setările după modificare
	current_action = null  # Resetăm acțiunea curentă

func _save_settings() -> void:
	for hbox in $ActionsContainer.get_children():
		if hbox is HBoxContainer:
			var label = hbox.get_child(0)
			if label:
				var action_name = label.text.to_lower().replace(" ", "_")
				var events = InputMap.action_get_events(action_name)
				if events.size() > 0:
					var event = events[0]
					if event is InputEventKey:
						SettingsManager.settings["keybinds"][action_name] = event.as_text()
					elif event is InputEventMouseButton:
						SettingsManager.settings["keybinds"][action_name] = "Mouse " + str(event.button_index)
	
	SettingsManager.save_settings()


func _load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(save_file_path) == OK:
		for hbox in $ActionsContainer.get_children():
			if hbox is HBoxContainer:
				var label = hbox.get_child(0)
				if label:
					var action_name = label.text.to_lower().replace(" ", "_")
					var keybind = config.get_value("keybinds", action_name, null)
					if keybind:
						# Ștergem evenimentele curente pentru acțiune
						InputMap.action_erase_events(action_name)
						# Verificăm dacă este mouse sau tastă
						if keybind.begins_with("Mouse"):
							var mouse_button = int(keybind.split(" ")[1])
							var mouse_event = InputEventMouseButton.new()
							mouse_event.button_index = mouse_button
							InputMap.action_add_event(action_name, mouse_event)
						else:
							var key_event = InputEventKey.new()
							var scancode = _string_to_scancode(keybind)
							if scancode != -1:  # Verificăm dacă scancode-ul este valid
								key_event.physical_keycode = scancode
								InputMap.action_add_event(action_name, key_event)
							else:
								print("Scancode invalid pentru keybind: ", keybind)


# Conversie string în scancode
func _string_to_scancode(key_string: String) -> int:
	var key_list = {
		"A": KEY_A,
		"B": KEY_B,
		"C": KEY_C,
		"D": KEY_D,
		"E": KEY_E,
		"F": KEY_F,
		"G": KEY_G,
		"H": KEY_H,
		"I": KEY_I,
		"J": KEY_J,
		"K": KEY_K,
		"L": KEY_L,
		"M": KEY_M,
		"N": KEY_N,
		"O": KEY_O,
		"P": KEY_P,
		"Q": KEY_Q,
		"R": KEY_R,
		"S": KEY_S,
		"T": KEY_T,
		"U": KEY_U,
		"V": KEY_V,
		"W": KEY_W,
		"X": KEY_X,
		"Y": KEY_Y,
		"Z": KEY_Z,
		"Space": KEY_SPACE,
		"Enter": KEY_ENTER,
		"Escape": KEY_ESCAPE,
		"Shift": KEY_SHIFT,
		"Ctrl": KEY_CTRL,
		"Alt": KEY_ALT
	}
	return key_list.get(key_string, -1)  # Returnăm -1 dacă tasta nu este găsită


# Funcție pentru butonul Back
func _on_BackBtn_pressed() -> void:
	self.hide()
	if options_menu:
		options_menu.show()
