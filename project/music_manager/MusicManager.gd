class_name MusicManager extends AudioStreamPlayer
##
## MusicManager - used under main to manage music
##
## CTRL + A: Add MusicManager Node to main.
## Use MusicManager.MusicConnector.new() in 
## objects that need to send signals to your
## MusicManager Node.
## ie: music_manager.player_left_base.emit()
@export_category("Fade Speed")
@export var fade_in_speed: float
@export var fade_out_speed: float
@export var combat_in_speed: float
@export var combat_out_speed: float

@export_category("Audio Streams")
@export var calm_layer: AudioStream
@export var explore_layer: AudioStream
@export var combat_layer: AudioStream
@export var lead_layer: AudioStream

@export_category("Target Volumes")
@export var max_vol: int
@export var min_vol: int


var fade_time

class MusicConnector:

    var _manager: MusicManager
    var _client: Node

    func _init(manager: MusicManager, client: Node):

        _manager = manager
        _client = client

signal game_started
signal player_entered_base
signal player_left_base
signal damage_taken
signal combat_finished
signal fade_finished(sources)
signal bus_assigned(sources, bus_idx)

const music_bus_str: StringName = "music"
const in_bus_str: StringName = "fadein"
const out_bus_str: StringName = "fadeout"
const null_bus_str: StringName = "null"

var in_idx
var out_idx
var music_idx
var null_idx

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

func start_fade(sources: int, type: FadeType, time: float):
    match type:
        FadeType.IN:
            fade_in_sources = sources
            assign_bus(sources, in_bus_str)
        FadeType.OUT:
            fade_out_sources = sources
            assign_bus(sources, out_bus_str)
        _:
            push_warning("Fade type: " + str(type) + ", not supported")
            return

    fade_time = time
    fade = type

func end_fade(sources, fade_type: FadeType):
    fade = FadeType.NONE
    fade_finished.emit(sources, fade_type)

func _on_fade_finished(sources, fade_type):
    push_warning("fade finished")
    
    if fade_type == FadeType.IN:
        assign_bus(sources, music_bus_str)
    
    if fade_type == FadeType.OUT:
        assign_bus(sources, null_bus_str)

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

func reset_fade_busses():
    set_fadein_vol(min_vol)
    set_fadeout_vol(max_vol)

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

    bus_assigned.emit(sources, AudioServer.get_bus_index(bus_name))

func _on_bus_assigned(sources, bus_idx):
    push_warning("sources: " + str(sources) + "; assigned to bus: " + str(AudioServer.get_bus_name(bus_idx)) + "; vol: " + str(AudioServer.get_bus_volume_db(bus_idx)))
    if fade == FadeType.NONE:
        reset_fade_busses() 

func fade_in(sources: int, speed: float, delta: float):
    var bus_idx = AudioServer.get_bus_index(in_bus_str)

    if AudioServer.get_bus_volume_db(bus_idx) > max_vol:
        AudioServer.set_bus_volume_db(bus_idx, max_vol)
        end_fade(sources, FadeType.IN)
        
    
    AudioServer.set_bus_volume_db(
        bus_idx,
        AudioServer.get_bus_volume_db(bus_idx) + speed * delta
    )


func fade_out(sources: int, speed: float, delta: float):
    var bus_idx = AudioServer.get_bus_index(out_bus_str)

    if AudioServer.get_bus_volume_db(bus_idx) < min_vol:
        end_fade(sources, FadeType.OUT)


    AudioServer.set_bus_volume_db(
        bus_idx,
        AudioServer.get_bus_volume_db(bus_idx) - speed * delta
    )


func _on_game_started():
    source_2.stream = combat_layer
    source_2.bus = null_bus_str
    source_2.play()
    source_3.stream = lead_layer
    source_3.bus = null_bus_str
    source_3.play()

    source_0.stream = calm_layer
    source_0.play()
    source_1.stream = explore_layer
    source_1.play()
    start_fade(Source.SOURCE_0 + Source.SOURCE_1, FadeType.IN, fade_in_speed)


func _on_player_entered_base():
    push_warning("player entered base")
    if !is_combat:
        start_fade(Source.SOURCE_1, FadeType.OUT, fade_out_speed)


func _on_player_left_base():
    if !is_combat:
        push_warning("player exited base")
        start_fade(Source.SOURCE_1, FadeType.IN, fade_in_speed)

func _on_damage_taken():
    
    combat_timer.start(10)

    if is_combat:
        await combat_timer.timeout
        is_combat = false
        combat_finished.emit()
        return

    if fade == FadeType.NONE:
        start_fade(Source.SOURCE_2, FadeType.IN, combat_in_speed)
    
    is_combat = true
    push_warning("Combat Started")

func _on_combat_finished():
        start_fade(Source.SOURCE_2, FadeType.OUT, combat_out_speed)
        push_warning("Combat Finished") 
        


func _ready():
    
    game_started.connect(_on_game_started)
    player_entered_base.connect(_on_player_entered_base)
    player_left_base.connect(_on_player_left_base)
    damage_taken.connect(_on_damage_taken)
    combat_finished.connect(_on_combat_finished)
    
    fade_finished.connect(_on_fade_finished)
    bus_assigned.connect(_on_bus_assigned)

    in_idx = AudioServer.get_bus_index(in_bus_str)
    out_idx = AudioServer.get_bus_index(out_bus_str)
    music_idx = AudioServer.get_bus_index(music_bus_str)
    null_idx = AudioServer.get_bus_index(null_bus_str)

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
        FadeType.CROSS: 
           fade_in(fade_in_sources, fade_time, delta)
           fade_out(fade_out_sources, fade_time, delta)
        _:
            return

    print("combat timer left: " + str(combat_timer.time_left))
