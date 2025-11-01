## Audio Manager
##
## Handles all game audio including background music and sound effects.
## Provides simple interface for playing sounds by name.
## Supports volume control and muting.
##
## @tutorial: Add audio files to assets/audio/ folder

extends Node
class_name AudioManager

## Background music player
@onready var music_player: AudioStreamPlayer = $MusicPlayer

## Sound effects player
@onready var sfx_player: AudioStreamPlayer = $SFXPlayer

## Extra SFX players for overlapping sounds
@onready var sfx_player_2: AudioStreamPlayer = $SFXPlayer2
@onready var sfx_player_3: AudioStreamPlayer = $SFXPlayer3

## Library of loaded sound effects
var sfx_library: Dictionary = {}

## Current music volume (0.0 to 1.0)
var music_volume: float = 0.7

## Current SFX volume (0.0 to 1.0)
var sfx_volume: float = 0.8

## Is music muted?
var music_muted: bool = false

## Are SFX muted?
var sfx_muted: bool = false

func _ready() -> void:
	# Load all audio files
	load_audio_files()

	# Set initial volumes
	update_volumes()

	print("[AudioManager] Ready!")
	print("[AudioManager] Loaded ", sfx_library.size(), " sound effects")

## Load all audio files into memory
## PLACEHOLDER: Add actual audio files to assets/audio/ folder
func load_audio_files() -> void:
	# Try to load music
	#if ResourceLoader.exists("res://assets/audio/music/background_music.ogg"):
	#	music_player.stream = load("res://assets/audio/music/background_music.ogg")

	# Try to load sound effects
	#sfx_library["jump"] = preload_sfx("res://assets/audio/sfx/jump.ogg")
	#sfx_library["correct"] = preload_sfx("res://assets/audio/sfx/correct.ogg")
	#sfx_library["wrong"] = preload_sfx("res://assets/audio/sfx/wrong.ogg")
	#sfx_library["game_over"] = preload_sfx("res://assets/audio/sfx/game_over.ogg")
	#sfx_library["click"] = preload_sfx("res://assets/audio/sfx/click.ogg")

	# PLACEHOLDER: Use empty streams for now
	print("[AudioManager] Audio files not yet added - using placeholders")

## Helper function to safely load sound effects
func preload_sfx(path: String) -> AudioStream:
	if ResourceLoader.exists(path):
		return load(path)
	else:
		print("[AudioManager] Warning: Audio file not found: ", path)
		return null

## Start playing background music
func play_music() -> void:
	if music_player and music_player.stream and not music_muted:
		music_player.play()
		print("[AudioManager] Music started")

## Stop background music
func stop_music() -> void:
	if music_player:
		music_player.stop()
		print("[AudioManager] Music stopped")

## Play a sound effect by name
func play_sfx(sound_name: String) -> void:
	if sfx_muted:
		return

	if not sfx_library.has(sound_name):
		print("[AudioManager] Warning: Sound not found: ", sound_name)
		return

	var sound: AudioStream = sfx_library[sound_name]
	if not sound:
		return

	# Find available player
	var player: AudioStreamPlayer = get_available_sfx_player()
	if player:
		player.stream = sound
		player.play()

## Get an available SFX player (not currently playing)
func get_available_sfx_player() -> AudioStreamPlayer:
	if not sfx_player.playing:
		return sfx_player
	elif not sfx_player_2.playing:
		return sfx_player_2
	elif not sfx_player_3.playing:
		return sfx_player_3
	else:
		# All players busy, use first one (will interrupt)
		return sfx_player

## Toggle music mute
func toggle_music_mute() -> void:
	music_muted = not music_muted

	if music_muted:
		music_player.volume_db = -80  # Effectively silent
	else:
		update_volumes()

	print("[AudioManager] Music muted: ", music_muted)

## Toggle SFX mute
func toggle_sfx_mute() -> void:
	sfx_muted = not sfx_muted
	print("[AudioManager] SFX muted: ", sfx_muted)

## Set music volume (0.0 to 1.0)
func set_music_volume(volume: float) -> void:
	music_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

## Set SFX volume (0.0 to 1.0)
func set_sfx_volume(volume: float) -> void:
	sfx_volume = clamp(volume, 0.0, 1.0)
	update_volumes()

## Update actual player volumes based on settings
func update_volumes() -> void:
	if music_player:
		# Convert 0-1 to decibels (-40 to 0)
		music_player.volume_db = linear_to_db(music_volume)

	# Apply to all SFX players
	var sfx_db: float = linear_to_db(sfx_volume)
	if sfx_player:
		sfx_player.volume_db = sfx_db
	if sfx_player_2:
		sfx_player_2.volume_db = sfx_db
	if sfx_player_3:
		sfx_player_3.volume_db = sfx_db

## Convenience function to convert linear volume to decibels
func linear_to_db(linear: float) -> float:
	if linear <= 0.0:
		return -80.0
	return 20.0 * log(linear) / log(10.0)
