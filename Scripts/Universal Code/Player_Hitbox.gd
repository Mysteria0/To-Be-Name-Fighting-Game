extends Area2D

@export var player : CharacterBody2D


var new_shape : Vector2
var new_position : Vector2

func _ready() -> void:
	Change_Hitbox(Vector2(24,52),Vector2(0,6))
	

func _process(_delta: float) -> void:
	$Hitbox.shape.size = new_shape
	$Hitbox.position = new_position


func Change_Hitbox(Shape : Vector2, new_POS : Vector2) -> void:
	new_shape = Shape
	new_position = new_POS
	
