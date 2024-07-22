class_name TutorialArea

extends Area2D

@export var tutorial_text: TutorialManager.Section = TutorialManager.Section.INSPIRE_PROMPT
@export var command_string: String
@export var tutorial_manager: TutorialManager
@export var dialog_timeline: DialogicTimeline

func _ready():
    if tutorial_manager == null:
        tutorial_manager = %TutorialManager
    assert(tutorial_manager != null)
    body_entered.connect(_on_body_entered)
    
func _on_body_entered(body: Node2D):
    if body.is_in_group("Player"):
        if dialog_timeline:
            start_dialog()
        if command_string:
            tutorial_manager.prompter_ready.emit(tutorial_text, command_string)
        body_entered.disconnect(_on_body_entered)

func start_dialog():
    Dialogic.timeline_ended.connect(_on_timeline_ended)
    Dialogic.start.call_deferred(dialog_timeline)

func _on_timeline_ended():
    Dialogic.timeline_ended.disconnect(_on_timeline_ended)
