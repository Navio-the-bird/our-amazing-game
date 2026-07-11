class_name CustomAudioStreamPlayer 
extends Node3D

enum PlayerCycleMode {
	ROUND_ROBIN,
	RANDOM
}

enum VariationMode {
	ABSOLUTE,
	RELATIVE
}

@export var player_cycle_mode : PlayerCycleMode

@export var base_volume : float
@export var base_pitch : float

@export var enable_variation : bool
@export var variation_mode : VariationMode

@export var volume_variation : float
@export var pitch_variation : float

@export var audio_streams : Array[AudioStream]

var last_triggered_index : int = 0
var currently_playing : Array[AudioStreamPlayer]

func increment_index():
	match player_cycle_mode:
		PlayerCycleMode.ROUND_ROBIN:
			last_triggered_index=(last_triggered_index+1)%audio_streams.size()
		PlayerCycleMode.RANDOM:
			var random_result = randi_range(0, audio_streams.size()-2)
			if(random_result>=last_triggered_index):
				random_result+=1
			last_triggered_index = random_result
		_:
			printerr("Unimplemented enum case in CustomAudioStreamPlayer")

func rand_variation(value : float, variation : float) -> float:
	if not enable_variation or variation == 0:
		return value
	
	var variation_amt = randf_range(-variation, variation)
	
	match variation_mode:
		VariationMode.ABSOLUTE:
			return value + variation_amt
		VariationMode.RELATIVE:
			return value * (1 + variation_amt)
		_:
			printerr("Unknown variation mode: %d" % variation_mode)
			return 0

func initialise_stream_player() -> AudioStreamPlayer:
	var stream_player : AudioStreamPlayer = AudioStreamPlayer.new()
	stream_player.stream = audio_streams[last_triggered_index]
	stream_player.volume_db = rand_variation(base_volume, volume_variation)
	stream_player.pitch_scale = rand_variation(base_pitch, pitch_variation)
	
	print("SP init: %d %d" % [stream_player.volume_db, stream_player.pitch_scale])
	
	
	return stream_player

func delete_stream_player(stream_player : AudioStreamPlayer):
	stream_player.stop()
	currently_playing.remove_at(currently_playing.bsearch(stream_player))
	stream_player.queue_free()

func play():
	var stream_player = initialise_stream_player()
	add_child(stream_player)
	print(stream_player)
	currently_playing.append(stream_player)
	stream_player.play()
	stream_player.finished.connect(delete_stream_player.bind(stream_player))
	print("Playing")
	increment_index()
	
func stop_all():
	while currently_playing.size() != 0:
		var stream_player = currently_playing[0] 
		delete_stream_player(stream_player)
