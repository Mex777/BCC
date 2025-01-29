extends Node

@onready var music_player = $AudioStreamPlayer2D  # Referință la AudioStreamPlayer2D

# Pornește muzica (nu va începe din nou dacă deja rulează)
func play_music() -> void:
	if not music_player.playing:
		music_player.play()

# Oprește muzica
func stop_music() -> void:
	if music_player.playing:
		music_player.stop()

# Resetează muzica la început și o pornește
func restart_music() -> void:
	music_player.stop()
	music_player.play()
