extends TextureRect

@export var is_paused: bool = true
@export var play_button: Button
@export var quit_button: Button

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
        pause_ok = true

    if pause_ok:
        update_pause(not is_paused)


func _on_quit_button_pressed():
    get_tree().quit()
