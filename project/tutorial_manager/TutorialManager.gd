class_name TutorialManager extends CanvasLayer

@export_category("Panel Fade Times")
@export var prompt_time: float
@export var response_time: float

class TutorialConnector:
    var manager: TutorialManager
    var prompter_connection: Node
    var ui_connection: CanvasLayer

    func _init(manager_node: TutorialManager, connection_node: Node, ui_node: CanvasLayer):
        manager = manager_node
        prompter_connection = connection_node
        ui_connection = ui_node

class PanelConfigurator:
    const Panel_Scene = preload("res://tutorial_manager/message_panel.tscn")
    var message: String
    var panel: Node
    var text_edit: TextEdit

    func create_panel():
        panel = Panel_Scene.new()
        text_edit = panel.get_node("Message")
        text_edit.text = message

    func _init(panel_message: String):
        message = panel_message
        create_panel()

var _success: int

func _add_panel(section: int, connector: TutorialConnector) -> Node:
    var config = PanelConfigurator.new(sections.get(section))
    connector.ui_connector.add_child(config.panel)
    return config.panel

signal prompter_ready(section: Section, connector: TutorialConnector)
func _on_prompter_ready(section, connector):
    var panel = _add_panel(section, connector)
    await section_success
    if _success == section:
        await get_tree().create_timer(prompt_time).timeout
        panel.free()


signal section_success(section: Section, new_section: Section, connector: TutorialConnector)
func _on_section_success(section, new_section, connector):
    _success = section
    var panel = _add_panel(new_section, connector)
    await get_tree().create_timer(response_time).timeout
    panel.free()


func _ready():
    prompter_ready.connect(_on_prompter_ready)
    section_success.connect(_on_section_success)
    


enum Section{
    INSPIRE_PROMPT = 10,
    INSPIRE_RESPONSE = 19,
    THROW_PROMPT = 20,
    THROW_RESPONSE = 29,
    BUILD_PROMPT = 30,
    BUILD_RESPONSE = 39,
}

@export_category("Inspire tutorial")
@export_multiline var inspire_prompt: String
@export_multiline var inspire_response: String
@export_category("Throw tutorial")
@export_multiline var throw_prompt: String
@export_multiline var throw_response: String
@export_category("Build tutorial")
@export_multiline var build_prompt: String
@export_multiline var build_response: String

@onready var sections: Dictionary = {
    Section.INSPIRE_PROMPT: inspire_prompt, 
    Section.INSPIRE_RESPONSE: inspire_response,
    Section.THROW_PROMPT: throw_prompt,
    Section.THROW_RESPONSE: throw_response,
    Section.BUILD_PROMPT: build_prompt,
    Section.BUILD_RESPONSE: build_response,
    }