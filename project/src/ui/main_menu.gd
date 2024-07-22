extends TextureRect

@export var is_paused: bool = true
@export var play_button: Button
@export var quit_button: Button
@export var restart_button: Button
@export var remap_done_button: Button
@export var remapper_menu: VBoxContainer
@export var music_manager: MusicManager
@export var game_manager: GameManager
@export var title_music: AudioStreamPlayer
@export var show_skip_tutorial: bool = false

@onready var skip_tutorial = $Menu/SkipTutorial

var pause_ok: bool = false


func update_pause(pause: bool):
    if pause:
        show()
        play_button.grab_focus()
        get_tree().paused = true
        is_paused = true

    if !pause:
        hide()
        get_tree().paused = false
        is_paused = false


func _input(event):
    if event.is_action_pressed("pause") and pause_ok:
        update_pause(not is_paused)  


func _ready():
    # remap_done_button.pressed.connect(_on_remap_done_button_pressed)
    play_button.pressed.connect(_on_play_button_pressed)
    restart_button.pressed.connect(_on_restart_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)
    skip_tutorial.pressed.connect(_on_skip_tutorial_pressed)
    update_pause(true)
    skip_tutorial.visible = show_skip_tutorial

func _on_skip_tutorial_pressed():
    reset_dialog()
    SceneLoader.load_next_level()

func reset_dialog():
    var dialogic_connections = Dialogic.timeline_ended.get_connections()
    for connection in dialogic_connections:
        connection.signal.disconnect(connection.callable)
    var voice_subsystem = Dialogic.get_subsystem("Voice")
    voice_subsystem.stop_audio()
    Dialogic.end_timeline()

func _on_remap_done_button_pressed():
    remapper_menu.hide()
    play_button.show()

func _on_play_button_pressed():
    play_level()

func play_level():
    if pause_ok == false:
        play_button.text = "Resume"
        restart_button.show()
        title_music.stop()
        var mus_conn: MusicManager.MusicConnector
        mus_conn = MusicManager.MusicConnector.new(music_manager, self)
        mus_conn._manager.level_started.emit()
        pause_ok = true

    if pause_ok:
        update_pause(not is_paused)


func _on_restart_button_pressed():
    reset_dialog()
    ResourceManager.reset()
    get_tree().reload_current_scene()

func _on_quit_button_pressed():
    get_tree().quit()
