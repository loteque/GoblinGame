class_name TutorialArea

extends Area2D

@export var tutorial_text: TutorialManager.Section = TutorialManager.Section.INSPIRE_PROMPT
@export var command_string: String = "call"
@export var tutorial_manager: TutorialManager

func _ready():
    if tutorial_manager == null:
        tutorial_manager = %TutorialManager
    assert(tutorial_manager != null)
    body_entered.connect(_on_body_entered)
    
func _on_body_entered(body: Node2D):
    if body.is_in_group("Player"):
        tutorial_manager.prompter_ready.emit(tutorial_text, command_string)
        body_entered.disconnect(_on_body_entered)
        
