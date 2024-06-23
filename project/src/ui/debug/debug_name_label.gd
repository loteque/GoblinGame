extends Label

func _ready():
    z_index = 2
    top_level = true
    text = get_parent().name

func _process(delta):
    position = get_parent().position + Vector2(0, -200)
