extends Node

const VOLUME_DB_SILENCE = -80.0
const VOLUME_DB_NORMAL = 0.0
const TWEEN_INTERPOLATION = Tween.TRANS_QUART
const TWEEN_EASE = Tween.EASE_OUT

signal play_layer
signal stop_layer
signal pause_layer
signal mute_layer
signal unmute_layer

signal play_music
signal stop_music
signal pause_music
signal mute_music
signal unmute_music


@export var audio_stream_musics: Array[AudioStreamMusic]
var tracks: Dictionary

func _ready() -> void:
	play_layer.connect(_play_layer)
	stop_layer.connect(_stop_layer)
	pause_layer.connect(_pause_layer)
	mute_layer.connect(_mute_layer)
	unmute_layer.connect(_unmute_layer)
	
	for music in audio_stream_musics:
		for layer in music.layers:
			var audio_stream_player = AudioStreamPlayer.new()
			var stream = layer.stream
			
			stream.loop = true
			audio_stream_player.stream = stream
			audio_stream_player.volume_db = VOLUME_DB_SILENCE
			
			add_child(audio_stream_player)
			#audio_stream_players[layer.name] = audio_stream_player
			
			if layer.b_autoplay:
				_play_layer(layer.name, 0, true)
	
	_test()

func _play_layer(layer_name: String, fade_time: float = 1.0, b_is_muted: bool = false) -> void:
	var tween = _get_tween()
	var player = _get_player(layer_name)
	var volume_db = _get_volume_db(b_is_muted)
	
	if !player.playing:
		tween.tween_callback(player.play)
	if player.stream_paused:
		tween.tween_property(player, "stream_paused", false, 0.0)
	tween.tween_property(player, "volume_db", volume_db, fade_time)

func _stop_layer(layer_name: String, fade_time: float = 1.0) -> void:
	var tween = _get_tween()
	var player = _get_player(layer_name)
	var volume_db = VOLUME_DB_SILENCE
	
	tween.tween_property(player, "volume_db", volume_db, fade_time)
	tween.tween_callback(player.stop)

func _pause_layer(layer_name: String, fade_time: float = 1.0) -> void:
	var tween = _get_tween()
	var player = _get_player(layer_name)
	var volume_db = VOLUME_DB_SILENCE
	
	tween.tween_property(player, "volume_db", volume_db, fade_time)
	tween.tween_property(player, "stream_paused", true, 0.0)

func _mute_layer(layer_name: String, fade_time: float = 1.0) -> void:
	var tween = _get_tween()
	var player = _get_player(layer_name)
	var volume_db = VOLUME_DB_SILENCE
	
	tween.tween_property(player, "volume_db", volume_db, fade_time)

func _unmute_layer(layer_name: String, fade_time: float = 1.0) -> void:
	var tween = _get_tween()
	var player = _get_player(layer_name)
	var volume_db = VOLUME_DB_NORMAL
	
	tween.tween_property(player, "volume_db", volume_db, fade_time)

func _get_tween() -> Tween:
	var tween = get_tree().create_tween()
	tween.set_trans(TWEEN_INTERPOLATION)
	tween.set_ease(TWEEN_EASE)
	return tween

func _get_player(layer_name: String) -> AudioStreamPlayer:
	return audio_stream_players[layer_name]

func _get_volume_db(b_is_muted: bool) -> float:
	if b_is_muted:
		return VOLUME_DB_SILENCE
	else:
		return VOLUME_DB_NORMAL

func _test():
	play_layer.emit("4", 10)
	await get_tree().create_timer(10).timeout
	play_layer.emit("1", 0)
	await get_tree().create_timer(5).timeout
	play_layer.emit("2", 3)
	await get_tree().create_timer(10).timeout
	play_layer.emit("3", 10)
