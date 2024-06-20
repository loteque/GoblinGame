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
@export var lead_layer: AudioStream
@export var max_vol: int
@export var min_vol: int
@export var fade_time: float

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

const music_bus_str: StringName = "music"
const in_bus_str: StringName = "fadein"
const out_bus_str: StringName = "fadeout"

var source_0 = AudioStreamPlayer.new()
var source_1 = AudioStreamPlayer.new()
var source_2 = AudioStreamPlayer.new()
var source_3 = AudioStreamPlayer.new()

var fade_in_sources: int
var fade_out_sources: int
enum Source{
    SOURCE_0 = 1,
    SOURCE_1 = 2,
    SOURCE_2 = 4,
    SOURCE_3 = 8,
}

var fade: FadeType
enum FadeType{
    IN,
    OUT,
    CROSS,
    NONE,
}

var combat_timer = Timer.new()
var is_combat: bool

func start_fade(sources: int, type: FadeType):
    match type:
        FadeType.IN:
            fade_in_sources = sources
        FadeType.OUT:
            fade_out_sources = sources
        _:
            push_warning("Fade type: " + str(type) + ", not supported")
            return
            
    fade = type

func end_fade():
    fade_in_sources = 0
    fade_out_sources = 0
    fade = FadeType.NONE


func set_fadein_vol(db):
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index(in_bus_str),
        db
    )

func set_fadeout_vol(db):
    AudioServer.set_bus_volume_db(
        AudioServer.get_bus_index(out_bus_str),
        db
    )

func assign_bus(sources: int, bus_name: StringName):
    match sources:
        Source.SOURCE_0:
            source_0.bus = bus_name
        Source.SOURCE_1:
            source_1.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_1:
            source_0.bus = bus_name
            source_1.bus = bus_name
        Source.SOURCE_2:
            source_2.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_2:
            source_0.bus = bus_name
            source_2.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_1 + Source.SOURCE_2:
            source_0.bus = bus_name
            source_1.bus = bus_name
            source_2.bus = bus_name
        Source.SOURCE_3:
            source_3.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_3:
            source_3.bus = bus_name
            source_0.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_1 + Source.SOURCE_3:
            source_3.bus = bus_name
            source_0.bus = bus_name
            source_1.bus = bus_name
        Source.SOURCE_0 + Source.SOURCE_1 + Source.SOURCE_2 + Source.SOURCE_3:
            source_3.bus = bus_name
            source_0.bus = bus_name
            source_1.bus = bus_name
            source_2.bus = bus_name
        _:
            source_3.bus = music_bus_str
            source_0.bus = music_bus_str
            source_1.bus = music_bus_str
            source_2.bus = music_bus_str

func fade_in(sources: int, speed: float, delta: float):
    var bus_idx = AudioServer.get_bus_index(in_bus_str)

    if AudioServer.get_bus_volume_db(bus_idx) > max_vol:
        AudioServer.set_bus_volume_db(bus_idx, max_vol)
        assign_bus(sources, music_bus_str)
        end_fade()
    
    assign_bus(sources, in_bus_str)
    AudioServer.set_bus_volume_db(
        bus_idx,
        AudioServer.get_bus_volume_db(bus_idx) + speed * delta
    )



func fade_out(sources: int, speed: float, delta: float):
    var bus_idx = AudioServer.get_bus_index(out_bus_str)

    if AudioServer.get_bus_volume_db(bus_idx) < min_vol:
        assign_bus(sources, music_bus_str)
        end_fade()

    assign_bus(sources, out_bus_str)
    AudioServer.set_bus_volume_db(
        bus_idx,
        AudioServer.get_bus_volume_db(bus_idx) - speed * delta
    )

# func cross_fade(in_player: AudioStreamPlayer, out_player: AudioStreamPlayer, speed: float, delta: float):
#     fade_in(in_player, speed, delta)
#     fade_out(out_player, speed, delta)

func _on_game_started():
    source_0.stream = explore_layer
    source_0.play()
    source_1.stream = calm_layer
    source_1.play()
    start_fade(Source.SOURCE_0 + Source.SOURCE_1, FadeType.IN)

func _on_player_left_base():
    pass

func _on_damage_taken():

    combat_timer.paused = false
    combat_timer.start(3)

    if is_combat:
        await combat_timer.timeout
        is_combat = false
        combat_finished.emit()
        return
    else:
        source_2.stream = combat_layer
        source_2.bus = in_bus_str
        source_2.play(source_0.get_playback_position())
        start_fade(Source.SOURCE_2, FadeType.IN)
    
    is_combat = true


func _on_combat_finished():
        start_fade(Source.SOURCE_0 + Source.SOURCE_1 + Source.SOURCE_2, FadeType.OUT)
        print("combat finished")


func _ready():
    
    game_started.connect(_on_game_started)
    player_left_base.connect(_on_player_left_base)
    damage_taken.connect(_on_damage_taken)
    combat_finished.connect(_on_combat_finished)
    
    var in_idx = AudioServer.get_bus_index(in_bus_str)
    var out_idx = AudioServer.get_bus_index(out_bus_str)
    var music_idx = AudioServer.get_bus_index(music_bus_str)
    AudioServer.set_bus_volume_db(in_idx, min_vol)
    AudioServer.set_bus_volume_db(out_idx, max_vol)
    AudioServer.set_bus_volume_db(music_idx, max_vol)

    source_0.bus = in_bus_str
    source_1.bus = in_bus_str
    source_2.bus = in_bus_str
    source_3.bus = in_bus_str

    add_child(source_0)
    add_child(source_1)
    add_child(source_2)
    add_child(source_3)

    combat_timer.one_shot = true
    add_child(combat_timer)

    game_started.emit()


func _process(delta):

    match fade:
        FadeType.IN:
            fade_in(fade_in_sources, fade_time, delta)
        FadeType.OUT:
            fade_out(fade_out_sources, fade_time, delta)
        # FadeType.CROSS: 
        #    cross_fade(in_bus_str, self, 20, delta)
        _:
            return

    print("combat timer left: " + str(combat_timer.time_left))
