extends Button

func _ready():
    pressed.connect(_on_button_pressed)

func _on_button_pressed():
    ResourceManager.reset()
    get_tree().reload_current_scene()
