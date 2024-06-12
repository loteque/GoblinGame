## Copryright (c) 2023 - Present Drew Billings, Jonathan David Lewis
## This file is part of the InputGroxler Library/Plugin
@tool
extends Node

var current_controller: GroxledController
var joypad: GroxledController.Joypad
var keyboard_mouse: GroxledController.KeyboardMouse

func get_controller() -> GroxledController:
	return current_controller

func _ready() -> void:
	var controller = GroxledController.new()
	joypad = controller.Joypad.new()
	keyboard_mouse = controller.KeyboardMouse.new()
	current_controller = keyboard_mouse

func _unhandled_input(event) -> void:
	if event is InputEventJoypadMotion:
		current_controller = joypad

	if event is InputEventKey:
		current_controller = keyboard_mouse
	
	if event is InputEventMouseMotion && event.relative != Vector2.ZERO:
		current_controller = keyboard_mouse
