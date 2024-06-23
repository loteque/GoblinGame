extends State

class_name DeliverScarapState
#@onready var animated_sprite = %AnimatedSprite2D
@onready var actor_core = %ActorCore
@onready var animated_sprite = %AnimatedSprite2D
@onready var idle = $Idle

@onready var collector: CollectorComponent = %Collector


func deliver():
    var delivered_amount = collector.deliver_scrap()
    assert(delivered_amount == 1) # current we assume we collect 1 at a time
    ResourceManager.scrap_collected.emit(actor_core.actor.team)

func enter_state(data: Dictionary = {}):
    super.enter_state()
    actor_core.actor.sfx_manager.play_rand("scrap")
    animated_sprite.play("collect_scrap")
    deliver()

func exit_state():
    super.exit_state()
    
    animated_sprite.stop()

func update(_delta):
    machine.change_state(idle)
