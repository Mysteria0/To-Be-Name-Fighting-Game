class_name projectile 
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
## What kind of knockdown the projectile has on hit, choices are: "None", "Soft" and "Hard"
@export var projectileknockdown : String
## how fast and what direction the projectile goes across the screen
@export var projectileMovementvector : Vector2

## Knockback dealt to target on grounded hit. negative value to push away, positive value to pull in. Number should be bigger than expected due to friction
@export var KnockbackOnGroundhit : Vector2i
## Knockback dealt to target on air hit. negative values to push away, positive to pull in. Values should be smaller to produce inteded effects
@export var KnockbackOnAirhit : Vector2i


@export var Sprite : String

enum Knockdowntypes {
	None = 1,
	Soft = 2,
	Hard = 3
}

var disabledtimer : int
var dead : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	linear_velocity = projectileMovementvector
	$Sprite2D.play(Sprite)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if disabledtimer > 0:
		disabledtimer -= 1
		linear_velocity *= 0
	elif disabledtimer == 0:
		$Area2D/Hitbox.set_deferred('disabled', false)
		disabledtimer = -1
	elif disabledtimer == -1:
		linear_velocity = projectileMovementvector
		disabledtimer = -2

func change_hitbox(Shape : Vector2, new_POS : Vector2) -> void:
	$Area2D.Change_Hitbox(Shape,new_POS)

func _on_sprite_2d_animation_finished() -> void:
	queue_free()





func _on_area_2d_area_entered(area: Area2D) -> void:
	if !dead and !area.is_in_group('Projectiles'):
		$Area2D/Hitbox.set_deferred('disabled', true)
		disabledtimer = Hitstop-1
		area.player.Player_hit(projectileDamage,Hitstop,HitstunOnGroundhit,HitstunOnAirhit,KnockbackOnGroundhit,KnockbackOnAirhit,Knockdowntypes[projectileknockdown])
		projectileHits -= 1
	if projectileHits <= 0:
		$Sprite2D.play(Sprite + '_Explode')
		$Area2D/Hitbox.set_deferred('disabled', true)
		linear_velocity *= 0
		disabledtimer = -2
		dead = true


func _on_body_entered(body: Node) -> void:
	if body is TileMapLayer:
		$Sprite2D.play(Sprite + '_Explode')
		$Area2D/Hitbox.set_deferred('disabled', true)
		linear_velocity *= 0
		disabledtimer = -2
		dead = true
