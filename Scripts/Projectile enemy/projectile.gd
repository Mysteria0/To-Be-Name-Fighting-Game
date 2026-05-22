extends RigidBody2D

## Damage dealt to the target on hit
@export var projectileDamage : int
## How long the target stays in their hurt state
@export var projectileHitstop : int
## how fast and what direction the projectile goes across the screen
@export var projectileMovementvector : Vector2i
## How many times the projectile can hit a valid target before it dissapears
@export var projectileHits : int

## Knockback dealt to target on grounded hit. negative value to push away, positive value to pull in. Number should be bigger than expected due to friction
@export var KnockbackOnGroundhit : Vector2i
## Knockback dealt to target on air hit. negative values to push away, positive to pull in. Values should be smaller to produce inteded effects
@export var KnockbackOnAirhit : Vector2i

var disabledtimer : int

signal hit_opponent

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if disabledtimer > 0:
		disabledtimer -= 1
	elif disabledtimer == 0:
		$CollisionShape2D.set_deferred("disabled", false)
		disabledtimer = -1


func _on_body_entered(body: Node) -> void:
	hit_opponent.emit()



func _on_hit_opponent() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	disabledtimer = projectileHitstop
	projectileHits -= 1
	if projectileHits <= 0:
		$Sprite2D.play("Explode")
	%Player.Player_hit(projectileDamage,projectileHitstop,KnockbackOnGroundhit,KnockbackOnAirhit)
	##queue_free()
