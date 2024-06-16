class_name MusicManager extends AudioStreamPlayer
##
## MusicManager - used under main to manage music
##
## CTRL + A: Add MusicManager Node to main.
## Use MusicManager.MusicConnector.new() in 
## objects that need to send signals to your
## MusicManager Node.
## ie: music_manager.player_left_base.emit()

@export var calm_layer: AudioStream
@export var explore_layer: AudioStream
@export var combat_layer: AudioStream

class MusicConnector:

    var _manager: MusicManager
    var _client: Node

    func _init(manager: MusicManager, client: Node):

        _manager = manager
        _client = client

signal game_started
signal player_left_base
signal damage_taken
signal combat_finished

var fade_stream_player = AudioStreamPlayer.new()


func _ready():
    game_started.connect(_on_game_started)
    player_left_base.connect(_on_player_left_base)
    damage_taken.connect(_on_damage_taken)
    combat_finished.connect(_on_combat_finished)
    add_child(fade_stream_player)
    game_started.emit()

var fade
enum FadeType{
    IN,
    OUT,
    CROSS,
    NONE,
}

func start_fade(type: FadeType):
    fade = type

func end_fade():
    fade = FadeType.NONE

func fade_in(player: AudioStreamPlayer, speed: float, delta: float):
    
    if player.volume_db > -0.2:
        player.volume_db = 0
        stream = player.stream
        end_fade()
    
    player.volume_db = player.volume_db + speed * delta
    print("fade_in " + str(player.volume_db))

func fade_out(player: AudioStreamPlayer, speed: float, delta: float):
    var fade_out_track: AudioStreamPlayer
    if stream == player.stream:
        fade_out_track = self
    else:
        fade_out_track = fade_stream_player
    
    var fade_db = fade_out_track.volume_db
    if fade_db < -59:
        player.stream = null
        end_fade()

    fade_db = fade_db - speed * delta

func cross_fade(in_player: AudioStreamPlayer, out_player: AudioStreamPlayer, speed: float, delta: float):
    fade_in(in_player, speed, delta)
    fade_out(out_player, speed, delta)

func _on_game_started():
    fade_stream_player.stream = calm_layer
    fade_stream_player.volume_db = -60
    fade_stream_player.play()
    start_fade(FadeType.IN)

func _on_player_left_base():
    pass

func _on_damage_taken():
    pass

func _on_combat_finished():
    pass

func _process(delta):

    match fade:
        FadeType.IN:
            fade_in(fade_stream_player, 10, delta) 
        FadeType.OUT:
            fade_out(self, 0.5, delta)
        FadeType.CROSS: 
            cross_fade(fade_stream_player, self, 0.5, delta)
        _:
            return
