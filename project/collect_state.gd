extends State

## Collect target
class_name CollectState

@onready var animated_sprite = %AnimatedSprite2D

@onready var actor_core = %ActorCore

var target: Scrap

func collect():
    if not target == null and !target.is_on_cooldown():
        target.get_collected()
        ResourceManager.scrap_collected.emit(actor_core.actor.team)

func enter_state(data: Dictionary = {}):
    super.enter_state()
    target = data.get("target")
    animated_sprite.play("collect_scrap")
    #if target:
        #animated_sprite.play("collect_scrap")

func exit_state():
    super.exit_state()
    animated_sprite.stop()

func update(delta):
    collect()
