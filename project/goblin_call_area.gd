extends Area2D

var goblins = []

# Who the goblins will follow
@export var leader: Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
    pass # Replace with function body.


func call_goblins():
    #get colliding golins
    var bodies = get_overlapping_bodies()
    var goblins = bodies.filter(func(node: Node2D): return node.is_in_group("NPC"))
    var allied_goblins = goblins.filter(func(node: Node2D): return node.team == leader.team)
    goblins.assign(allied_goblins)
    make_follow(goblins)
    #on same team
    #Seta ll should_follow_player
    pass

func make_follow(targets: Array[Node2D]):
    for target in targets:
        target.follow(leader)

func _input(event):
    if event.is_action("call"):
        call_goblins()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
    pass

func release_goblins():
    #get colliding golins
    #on same team
    #Seta ll should_follow_player
    pass
