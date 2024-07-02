@tool
extends EditorPlugin

func _enter_tree():
    add_custom_type("LoteqStateMachine", "Node", preload("src/machine.gd"), preload("icon.png"))

func _exit_tree():
    remove_custom_type("LoteqStateMachine")