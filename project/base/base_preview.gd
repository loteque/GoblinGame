extends Area2D

@onready var base_sprite_2 = $BaseSprite2

var can_be_placed:= false:
    get: return !has_overlapping_bodies()
    
# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.

func show_as_invalid():
    base_sprite_2.modulate = Color(Color.CRIMSON)

func show_as_valid():
    base_sprite_2.modulate = Color(Color.WHITE)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    if can_be_placed:
        show_as_valid()
    else:
        show_as_invalid()
