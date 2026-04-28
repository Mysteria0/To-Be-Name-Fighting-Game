class_name State
extends Node

@export var animation_name : String

var parent : CharacterBody2D
var Current_Motion : String
var Current_Attack : String

func enter() -> void:
	parent.animations.play(animation_name)
	
func exit() -> void:
	pass
	
func process_input(_event: InputEvent) -> State:
	return null
	
func process_frame(_delta: float) -> State:
	return null
	
func process_physics(_delta: float) -> State:
	return null
