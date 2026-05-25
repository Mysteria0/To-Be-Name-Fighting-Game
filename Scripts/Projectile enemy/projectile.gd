extends RigidBody2D

## Damage dealt to the target on hit
@export var projectileDamage : int
## How long the target stays in their hurt state while hit on the ground
@export var HitstunOnGroundhit : int
## How long the target stays in their hurt state while hit in the air
@export var HitstunOnAirhit : int
## How long the target stays in place after getting hit
@export var Hitstop : int
## How many times the projectile can hit a valid target before it dissapears
@export var projectileHits : int
## how fast and what direction the projectile goes across the screen
@export var projectileMovementvector : Vector2i

## Knockback dealt to target on grounded hit. negative value to push away, positive value to pull in. Number should be bigger than expected due to friction
@export var KnockbackOnGroundhit : Vector2i
## Knockback dealt to target on air hit. negative values to push away, positive to pull in. Values should be smaller to produce inteded effects
@export var KnockbackOnAirhit : Vector2i

var disabledtimer : int
var dead : bool

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

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.transform.origin = global_position
	
func _physics_process(delta: float) -> void:
	apply_force(projectileMovementvector)


func _on_body_entered(body: Node) -> void:
	if !dead and body != TileMapLayer:
		$CollisionShape2D.set_deferred("disabled", true)
		disabledtimer = Hitstop+1
		%Player.Player_hit(projectileDamage,Hitstop,HitstunOnGroundhit,HitstunOnAirhit,KnockbackOnGroundhit,KnockbackOnAirhit)
	projectileHits -= 1
	if projectileHits <= 0:
		$Sprite2D.play("Explode")
		dead = true


func _on_sprite_2d_animation_finished() -> void:
	queue_free()
