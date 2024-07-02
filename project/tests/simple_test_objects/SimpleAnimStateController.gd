class_name SimpleAnimStateController extends Node

@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D


var x: float
var y: float
var is_facing_east: bool
var is_facing_west: bool
var is_facing_north: bool
var is_facing_south: bool

# anim state class
class AnimState extends LoteqStateMachine.LState:
    var _actor: CharacterBody2D
    var _animation: StringName
    var _sheet: AnimatedSprite2D
    var _transform: int

    func is_playing():
        return _sheet.animation == _animation
        
    func enter():
        if _animation and !is_playing():
            _sheet.play(_animation)
        if _transform:
            _actor.global_transform.x.x = _transform

    func exit():
        _sheet.stop()

    func _init(sheet: AnimatedSprite2D, actor: CharacterBody2D,  animation: StringName, transform: int = 1): 
        _actor = actor
        _animation = animation
        _sheet = sheet
        _transform = transform

# declare anim states
class RunWest extends AnimState:
    pass

class RunEast extends AnimState:
    pass

class RunNorth extends AnimState:
    pass

class RunSouth extends AnimState:
    pass

# configure anim states
@onready var run_east = RunEast.new(sprite, actor, &"run_side_0")
@onready var run_west = RunWest.new(sprite, actor, &"run_side_0", -1)
@onready var run_south = RunSouth.new(sprite, actor, &"run_down")
@onready var run_north = RunNorth.new(sprite, actor, &"run_up")

# set up state machine
@onready var ANIM_STATE_MACHINE = LoteqStateMachine.new([run_east, run_west, run_south, run_north])

func update_animation_state():
    if is_facing_east:
        ANIM_STATE_MACHINE.change_state(ANIM_STATE_MACHINE.states[0])

    if is_facing_west:
        ANIM_STATE_MACHINE.change_state(ANIM_STATE_MACHINE.states[1])

    if is_facing_south:
        ANIM_STATE_MACHINE.change_state(ANIM_STATE_MACHINE.states[2])

    if is_facing_north:
        ANIM_STATE_MACHINE.change_state(ANIM_STATE_MACHINE.states[3])    

func update_directions(new_x: float, new_y: float):
    if new_x > 0 and new_x > new_y: 
        is_facing_east = true 
        is_facing_west = false
        is_facing_north = false
        is_facing_south = false

    if new_x < 0 and new_x < new_y: 
        is_facing_east = false
        is_facing_west = true
        is_facing_north = false
        is_facing_south = false

    if new_y < 0 and new_y < new_x:
        is_facing_east = false
        is_facing_west = false
        is_facing_north = true
        is_facing_south = false
    
    if new_y > 0 and new_y > new_x:
        is_facing_east = false
        is_facing_west = false
        is_facing_north = false
        is_facing_south = true


func _ready():
    x = actor.velocity.x
    y = actor.velocity.y

func _physics_process(_delta):
    if !actor:
        return
    
    if actor.velocity == Vector2.ZERO:
        sprite.play("idle_front")
        return

    update_directions(actor.velocity.x, actor.velocity.y)
    update_animation_state()
    pass

# func update_animation():
#     # run side east    
#     if is_facing_east: 
#         sprite.play("run_side_0")
#         actor.global_transform.x.x = 1

#     # run side west
#     if is_facing_west:
#         sprite.play("run_side_0")
#         actor.global_transform.x.x = -1

#     # run up north
#     if is_facing_north:
#         sprite.play("run_up")
#         actor.global_transform.x.x = 1

#     # run down south
#     if is_facing_south:
#         sprite.play("run_down")
#         actor.global_transform.x.x = 1
