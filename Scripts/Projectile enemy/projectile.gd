extends RigidBody2D

@export var projectileDamage : int
@export var projectilespeed : int

signal hit_opponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node) -> void:
	hit_opponent.emit()



func _on_hit_opponent() -> void:
	%Player.health -= projectileDamage
	%Player.hurt = true
	%Player.knockbackvector = Vector2(-1,-1)
	%Player.hitstun = 10
	queue_free()
