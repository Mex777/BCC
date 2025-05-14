extends Node2D

@onready var options_menu = get_tree().get_first_node_in_group("options_menu")

func _ready() -> void:
	load_video_settings()

func _on_back_btn_pressed() -> void:
	self.hide()
	if options_menu:
		options_menu.show()


func _on_resolution_btn_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_size(Vector2i(1280, 720))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1280, 720)
		SettingsManager.save_settings()
	elif index == 1:
		DisplayServer.window_set_size(Vector2i(1600, 900))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1600, 900)
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_size(Vector2i(1920, 1080))
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1920, 1080)
		SettingsManager.save_settings()


func _on_fullscreen_btn_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		SettingsManager.settings["video_settings"]["fullscreen"] = false
		$Control/ResolutionBtn.disabled = false
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		SettingsManager.settings["video_settings"]["fullscreen"] = true
		$Control/ResolutionBtn.disabled = true
		SettingsManager.settings["video_settings"]["resolution"] = Vector2i(1920, 1080)
		SettingsManager.save_settings()
		load_video_settings()


func _on_borderless_btn_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		SettingsManager.settings["video_settings"]["borderless"] = false
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
		SettingsManager.settings["video_settings"]["borderless"] = true
		SettingsManager.save_settings()


func _on_vsync_btn_item_selected(index: int) -> void:
	if index == 0:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		SettingsManager.settings["video_settings"]["vsync"] = 0
		SettingsManager.save_settings()
	elif index == 1:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		SettingsManager.settings["video_settings"]["vsync"] = 1
		SettingsManager.save_settings()
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)
		SettingsManager.settings["video_settings"]["vsync"] = 2
		SettingsManager.save_settings()
		

func load_video_settings():
	SettingsManager.load_video_settings()
	var index = SettingsManager.settings["video_settings"]["resolution"]
	if index == Vector2i(1280, 720):
		$Control/ResolutionBtn.selected = 0
	elif index == Vector2i(1600, 900):
		$Control/ResolutionBtn.selected = 1
	else:
		$Control/ResolutionBtn.selected = 2

	index = SettingsManager.settings["video_settings"]["fullscreen"]
	if index == false:
		$Control2/FullscreenBtn.selected = 0
	else:
		$Control2/FullscreenBtn.selected = 1

	index = SettingsManager.settings["video_settings"]["borderless"]
	if index == false:
		$Control3/BorderlessBtn.selected = 0
	else:
		$Control3/BorderlessBtn.selected = 1

	index = SettingsManager.settings["video_settings"]["vsync"]
	if index == 0:
		$Control4/VsyncBtn.selected = 0
	elif index == 1:
		$Control4/VsyncBtn.selected = 1
	else:
		$Control4/VsyncBtn.selected = 2
