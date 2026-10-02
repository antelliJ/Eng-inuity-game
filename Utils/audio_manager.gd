extends Node

@export var bgMusic:Array[AudioStream]
#@onready var bg_player = $"bg player"
@onready var bg_player: AudioStreamPlayer = $BGPlayer

var num_players = 8
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

var available3d = []  # The available players.
var queue3d = []  # The queue of sounds to play.
var queuepos = [] #que positions

var MusicVol = 0:
	set(value):
		MusicVol = value
		bg_player.volume_db = MusicVol
var AudioVol = 0:
	set(value):
		AudioVol = value
		#bg_player.volume_db = AudioVol


func _ready():
	# Create the pool of AudioStreamPlayer nodes. - basic
	for i in num_players:
		var p = AudioStreamPlayer.new()
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus
	
	#3d players
	for i in num_players:
		var p = AudioStreamPlayer3D.new()
		add_child(p)
		available3d.append(p)
		p.finished.connect(_on_3d_stream_finished.bind(p))
		p.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func _on_3d_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available3d.append(stream)

func play(sound_path :String):
	queue.append(sound_path)

func play3d(sound_path :String, pos):
	queue.append(sound_path)
	queuepos.append(pos)

func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].volume_db = AudioVol
		available[0].play()
		available.pop_front()
	
	if not queue3d.is_empty() and not available3d.is_empty():
		available3d[0].stream = load(queue.pop_front())
		available3d[0].volume_db = AudioVol
		available3d[0].position = queuepos.pop_front()
		available3d[0].play()
		available3d.pop_front()


func _on_bg_player_finished():
	
	var nextMusic = bgMusic[0]
	bg_player.volume_db = MusicVol
	bgMusic.push_back(nextMusic)
	bgMusic.pop_front()
	bg_player.stream = nextMusic
	bg_player.play()
