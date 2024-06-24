class_name TutorialManager extends CanvasLayer

@export_category("Panel Fade Times")
@export var prompt_time: float
@export var response_time: float


class TutorialConnector:
    var manager: TutorialManager
    var prompter_connection: Node
    var ui_connection: VBoxContainer

    func _init(manager_node: TutorialManager, connection_node: Node, ui_node: VBoxContainer):
        manager = manager_node
        prompter_connection = connection_node
        ui_connection = ui_node


class PanelConfigurator:
    const Panel_Scene = preload("res://tutorial_manager/message_panel.tscn")
    var message: String
    var panel: Control
    var action_str: String

    func create_panel():
        var _button_str: String
        if action_str != "":
            _button_str = ActionsProperty.Device.get_input_from_inputmap(action_str)
            _button_str = " :  " + _button_str
        panel = Panel_Scene.instantiate()
        panel.text = message + _button_str

    func _init(panel_message: String, panel_action_str: String = ""):
        message = panel_message
        action_str = panel_action_str
        create_panel()

var section_1: bool = true
var section_2: bool = true
var section_3: bool = true
func _deactivate_section(response_section):
    match response_section:
        Section.INSPIRE_RESPONSE:
            section_1 = false
        Section.THROW_RESPONSE:
            section_2 = false
        Section.BUILD_RESPONSE:
            section_3 = false


func is_tutorial_active() -> bool:
    var active: bool = section_1 or section_2 or section_3
    return active


var panels: Dictionary = {
    Section.INSPIRE_PROMPT: null,
    Section.INSPIRE_RESPONSE: null,
    Section.THROW_PROMPT: null,
    Section.THROW_RESPONSE: null,
    Section.BUILD_PROMPT: null,
    Section.BUILD_RESPONSE: null,
}


func _add_panel(section: int, connector: TutorialConnector, action_str: String = ""):
    var config = PanelConfigurator.new(sections.get(section), action_str)
    var panel = config.panel
    connector.ui_connection.add_child(panel)
    panels[section] = panel


signal prompter_ready(section: Section, connector: TutorialConnector, action_str: String)
func _on_prompter_ready(section, connector, action_str):
    
    if !panels[section]: 
        _add_panel(section, connector, action_str)


signal section_success(section: Section, new_section: Section, connector: TutorialConnector)
func _on_section_success(section, new_section, connector):
    
    if !panels[new_section]:
        _add_panel(new_section, connector)
    
    await get_tree().create_timer(prompt_time).timeout
    if panels[section] != null:
        panels[section].free()
        panels[section] = null

    await get_tree().create_timer(response_time).timeout
    if panels[new_section] != null:
        push_warning("trying to free panel: " + str(new_section))
        panels[new_section].free()
        panels[new_section] = null
        _deactivate_section(new_section)

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