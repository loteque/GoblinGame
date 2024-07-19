extends Area2D

class_name GoblinCommandComponent

# Who the goblins will follow
@export var leader: Node2D

var followers: Array[Actor] = []
var is_leading: bool = false
var enabled = true

@onready var call_range_indicator = %CallRangeIndicator
@onready var call_range_indicator_timer = %CallRangeIndicatorTimer

func _ready():
    body_exited.connect(_on_body_exited)
    call_range_indicator.visible = false

func _input(event):
    if event.is_action_pressed("call") and enabled:
        call_goblins()

func _on_body_exited(body):
    if body.is_in_group("NPC") and leader == body.player and body.should_follow_player:
        followers.erase(body)
        leader.lost_follower.emit()
        body.unfollow(leader)

func get_followers():
    return followers

func get_closts_follower():
    return followers

## Remove closest follower and return it
func pop_closest_follower():
    followers.sort_custom(_sort_by_distance)
    var closest = followers.pop_front()
    if len(followers) == 0:
        is_leading = false
    return closest

func _sort_by_distance(a: Node2D, b: Node2D) -> bool:
    var distance_a = self.global_position.distance_to(a.global_position)
    var distance_b = self.global_position.distance_to(b.global_position)
    return distance_a < distance_b

func call_goblins():
    leader.sfx_manager.play_rand("recruit")
    var bodies = get_overlapping_bodies()
    var goblins = bodies.filter(func(node: Node2D): return node.is_in_group("NPC"))
    var allied_goblins = goblins.filter(func(node: Actor): return node.team == leader.team) as Array[Actor]
    if len(allied_goblins) > 0:
        lead(allied_goblins)
        leader.lead_goblin.emit()



func show_call_indicator():
    call_range_indicator_timer.start()
    call_range_indicator.visible = true
    await call_range_indicator_timer.timeout
    call_range_indicator.visible = false

func lead(new_followers: Array):
    is_leading = true
    followers.assign(new_followers)
    make_follow(followers)
    show_call_indicator()

func make_follow(targets: Array[Actor]):
    for target in targets:
        target.follow(leader)
