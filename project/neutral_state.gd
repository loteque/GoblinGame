extends State

class_name NeutralState

@onready var animated_sprite = %AnimatedSprite2D

@onready var idle: State = $Idle
@onready var collect = %Collect

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func enter_state():
    pass
    # set idle state?

func update(delta):
    # if enemy, combat.
    if tracked_objects.includes("Scrap"):
        machine.change_state(collect)
        
    # If scrap, scavange.
    machine.change_state(idle)
    pass
    
    

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass
