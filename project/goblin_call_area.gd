extends Area2D

# Who the goblins will follow
@export var leader: Node2D

var followers: Array[Node2D] = []
var is_leading: bool = false

@onready var call_range_indicator = %CallRangeIndicator
@onready var call_range_indicator_timer = %CallRangeIndicatorTimer

func _ready():
    call_range_indicator.visible = false

func _input(event):
    if event.is_action_pressed("call"):
        if is_leading:
            release_goblins()
        else:
            call_goblins()

func call_goblins():
    var bodies = get_overlapping_bodies()
    var goblins = bodies.filter(func(node: Node2D): return node.is_in_group("NPC"))
    var allied_goblins = goblins.filter(func(node: Node2D): return node.team == leader.team)
    if len(allied_goblins) > 0:
        lead(allied_goblins)

func show_call_indicator():
    call_range_indicator_timer.start()
    call_range_indicator.visible = true
    await call_range_indicator_timer.timeout
    call_range_indicator.visible = false

func lead(new_followers: Array[Node2D]):
    is_leading = true
    followers.assign(new_followers)
    make_follow(followers)
    show_call_indicator()

func make_follow(targets: Array[Node2D]):
    for target in targets:
        target.follow(leader)

func make_unfollow(targets: Array[Node2D]):
    for target in targets:
        target.unfollow(leader)

func release_goblins():
    make_unfollow(followers)
    followers.assign([])
    is_leading = false
