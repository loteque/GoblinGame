extends Node2D

var max_amount: int = 10
var current_amount: int = 10
@onready var collection_timer = $CollectionTimer

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass


func despawn():
    queue_free()

func get_collected():
    collection_timer.start()
    await collection_timer.timeout
    if current_amount > 0:
        current_amount -= 1
    if current_amount <= 0:
        despawn()
    
    
