extends LoteqStateMachine


@export var actor: CharacterBody2D
@export var sprite: AnimatedSprite2D


# anim state class
class AnimState extends LState:
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


@onready var idle = AnimState.new(sprite, actor, &"idle_front")
@onready var run_east = AnimState.new(sprite, actor, &"run_side_0")
@onready var run_west = AnimState.new(sprite, actor, &"run_side_0", -1)
@onready var run_south = AnimState.new(sprite, actor, &"run_down")
@onready var run_north = AnimState.new(sprite, actor, &"run_up")


func _ready():

    states = {
        &"idle": idle,
        &"run_east": run_east,
        &"run_west": run_west,
        &"run_south": run_south,
        &"run_north": run_north,
        }    

    ready_state = idle


var is_idle: bool = true
var direction: Direction
enum Direction{
    NORTH,
    SOUTH,
    EAST,
    WEST
}


func update_idle():
    
    if actor.velocity != Vector2.ZERO:
        is_idle = false
        return
    
    is_idle = true


func update_direction(new_x: float, new_y: float):
    if new_x > 0 and new_x > new_y: 
        direction = Direction.EAST

    if new_x < 0 and new_x < new_y:
        direction = Direction.WEST

    if new_y < 0 and new_y < new_x:
        direction = Direction.NORTH

    if new_y > 0 and new_y > new_x:
        direction = Direction.SOUTH


func change_animation_state():
    
    match direction:
        Direction.EAST:
            if is_idle:
                change_state(idle)
            else:
                change_state(run_east)

        Direction.WEST:
            if is_idle:
                change_state(idle)
            else:
                change_state(run_west)
        
        Direction.SOUTH:
            if is_idle:
                change_state(idle)
            else:    
                change_state(run_south)

        Direction.NORTH:
            if is_idle:
                change_state(idle)
            else:
                change_state(run_north)


func _physics_process(_delta):

    if !actor:
        return

    update_idle()
    update_direction(actor.velocity.x, actor.velocity.y)
    change_animation_state()