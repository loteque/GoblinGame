extends HBoxContainer

var text: String = ""

@onready var message_panel = $MessagePanel

func _ready():
    message_panel.text = text
