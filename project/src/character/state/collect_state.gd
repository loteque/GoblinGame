extends State

## Collect target
class_name CollectState

@onready var animated_sprite = %AnimatedSprite2D
@onready var actor_core = %ActorCore
@onready var actor: Actor = actor_core.actor
@onready var collector: CollectorComponent = %Collector
@onready var collect_timer: Timer = Timer.new()

@export var collection_time: float = 1

var target: Scrap
var is_collecting: bool = false

func _ready():
    add_child(collect_timer)
    collect_timer.one_shot = true

func collect():
    if not target == null and !target.is_on_cooldown():
        target.get_collected()
        collector.collect(target)
        actor.collected_scrap.emit()

func enter_state(data: Dictionary={}):
    if is_collecting:
        return
    super.enter_state()
    target = data.get("target")
    animated_sprite.play("collect_scrap")
    collect_timer.start(collection_time)
    await collect_timer.timeout
    actor_core.actor.sfx_manager.play_rand("scrap")

func exit_state():
    super.exit_state()
    animated_sprite.stop()
    is_collecting = false

func update(_delta):
    collect()
