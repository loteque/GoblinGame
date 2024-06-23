extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
    pressed.connect(_on_button_pressed)
    pass # Replace with function body.

func _on_button_pressed():
    ResourceManager.reset()
    get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
