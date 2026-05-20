extends RigidBody2D

@export var projectileDamage : int
@export var projectileHitstop : int
@export var projectileSpeed : int

@export var KnockbackOnGroundhit : Vector2
@export var KnockbackOnAirhit : Vector2
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
	%Player.Player_hit(projectileDamage,projectileHitstop,KnockbackOnGroundhit,KnockbackOnAirhit)
	##queue_free()
