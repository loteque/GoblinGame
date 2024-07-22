extends Area2D

@export var tutorial_manager: TutorialManager

func _ready():
    if tutorial_manager == null:
        tutorial_manager = %TutorialManager
    assert(tutorial_manager != null)
    body_entered.connect(_on_body_entered)
    
func _on_body_entered(body: Node2D):
    if body.is_in_group("Player"):
        if body.goblin_call_component.followers.size() < 1:
            start_dialog()
        body_entered.disconnect(_on_body_entered)

func start_dialog():
    const _071_BRING_GOBLINS = preload("res://src/dialog/tutorial/071-bring-goblins.dtl")
    Dialogic.start.call_deferred(_071_BRING_GOBLINS)
