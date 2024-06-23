extends Label

func _ready():
    z_index = 2
    top_level = true
    text = str(get_parent().velocity.length())

func _process(delta):
    position = get_parent().position + Vector2(0, -100)
    text = str(get_parent().velocity.length())
