extends Label

@export var scrap: Scrap

# Called when the node enters the scene tree for the first time.
func _ready():
    if not scrap:
        scrap = get_parent()
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    var label_text = str(scrap.current_amount) + " / " + str(scrap.max_amount)
    text = label_text
