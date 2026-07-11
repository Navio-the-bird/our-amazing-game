class_name CustomAudioStreamPlayer 
extends Node3D
## A non localised audio player allowing for more complex behaviour than godot's default.

## How to cycle through the music streams 					[br]
## 
## [code]ROUND_ROBIN[/code] follows the pattern 			[br]
## 0 -> 1 -> 2 -> ... -> n -> 0								[br]
## 
## [code]RANDOM[/code] is random, but not the same as the run before
enum PlayerCycleMode {
	## [code]ROUND_ROBIN[/code] follows the pattern 			[br]
	## 0 -> 1 -> 2 -> ... -> n -> 0
	ROUND_ROBIN,
	
	## [code]RANDOM[/code] is random, but not the same as the run before
	RANDOM
}

## How to apply the variation												[br]
## 
## [code]ABSOLUTE[/code] means the variation amount is absolute				[br]
## [code]value = original ± variation[/code]								[br]
## 
## [code]RELATIVE[/code] means the variation amount is relative				[br]
## [code]value = original ± (variation)% = original * (1 ± variation)[/code]
enum VariationMode {
	## [code]ABSOLUTE[/code] means the variation amount is absolute				[br]
	## [code]value = original ± variation[/code]
	ABSOLUTE,
	
	## [code]RELATIVE[/code] means the variation amount is relative				[br]
	## [code]value = original ± (variation)% = original * (1 ± variation)[/code]
	RELATIVE
}

@export_group("General")
@export var player_cycle_mode : PlayerCycleMode = PlayerCycleMode.ROUND_ROBIN
## The base volume boost in dB. [color=red]This is a logarithmic scale, tiny changes make a big difference.[/color]
@export_range(-12, 6) var base_volume : float = 0
## The base pitch as a factor. 
@export_range(0.5, 1.5) var base_pitch : float = 1

@export_group("Variation")
## Whether to enable variation or note.
@export var enable_variation : bool = true
## How to apply the variation globally. See [enum VariationMode]
@export var variation_mode : VariationMode = VariationMode.RELATIVE

## Factor of the volume variation
@export var volume_variation : float = 0.01
## Factor of the pitch variation
@export var pitch_variation : float = 0.01

@export_group("Files")
## A selection of audio streams to choose from
@export var audio_streams : Array[AudioStream]

## Keeps track of the last triggered sound index from [member audio_streams]
var last_triggered_index : int = 0
## A list of all currently playing [AudioStreamPlayer]s
var currently_playing : Array[AudioStreamPlayer]

## Increments the counter variable [member last_triggered_index] according to the selected [member variation_mode]
func increment_index():
	match player_cycle_mode:
		# round robin
		PlayerCycleMode.ROUND_ROBIN:
			last_triggered_index=(last_triggered_index+1)%audio_streams.size()
		
		# random (me smort)
		PlayerCycleMode.RANDOM:
			var random_result = randi_range(0, audio_streams.size()-2)
			if(random_result>=last_triggered_index):
				random_result+=1
			last_triggered_index = random_result
		
		# default
		_:
			printerr("Unimplemented enum case in CustomAudioStreamPlayer")

## returns a variation with value according to [member enable_variation] and [member variation_mode]
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

## Initialises a basic stream player and sets its volume, stream file and pitch
func initialise_stream_player() -> AudioStreamPlayer:
	var stream_player : AudioStreamPlayer = AudioStreamPlayer.new()
	stream_player.stream = audio_streams[last_triggered_index]
	stream_player.volume_db = rand_variation(base_volume, volume_variation)
	stream_player.pitch_scale = rand_variation(base_pitch, pitch_variation)
	return stream_player

## Performs a bsearch to delete a stream player from [member currently_playing]
func delete_stream_player(stream_player : AudioStreamPlayer):
	stream_player.stop()
	currently_playing.remove_at(currently_playing.bsearch(stream_player))
	stream_player.queue_free()

## Play a sound file according to the settings of this node
func play():
	var stream_player = initialise_stream_player()
	add_child(stream_player)
	print(stream_player)
	currently_playing.append(stream_player)
	stream_player.play()
	stream_player.finished.connect(delete_stream_player.bind(stream_player))
	print("Playing")
	increment_index()

## Stops all currently playing sound files
func stop_all():
	while currently_playing.size() != 0:
		var stream_player = currently_playing[0] 
		delete_stream_player(stream_player)
