extends TextureRect

@export var is_paused: bool = true
@export var play_button: Button
@export var quit_button: Button
@export var music_manager: MusicManager
@export var title_music: AudioStreamPlayer

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
    play_button.pressed.connect(_on_play_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)
    update_pause(true)


func _on_play_button_pressed():
    if pause_ok == false:
        title_music.stop()
        var mus_conn: MusicManager.MusicConnector
        mus_conn = MusicManager.MusicConnector.new(music_manager, self)
        mus_conn._manager.level_started.emit()
        pause_ok = true

    if pause_ok:
        update_pause(not is_paused)


func _on_quit_button_pressed():
    if OS.has_feature('JavaScript'):
        JavaScriptBridge.eval("window.close()")
    get_tree().quit()
