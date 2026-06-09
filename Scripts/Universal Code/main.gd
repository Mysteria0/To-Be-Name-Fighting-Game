extends Node2D

@export var Proj_scene : PackedScene

var difficulty : int
var score : int

func _ready() -> void:
	get_tree().paused = false
	var timer = clamp(4-(.25*difficulty),0.4,4)
	$Timer.start(timer)
	difficulty += 1
	$Score/Points.text = str(score)


func _on_player_death() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file('res://menu.tscn')




func _on_timer_timeout() -> void:
	var randomizer = randi_range(1,difficulty)
	var proj = Proj_scene.instantiate()
	var proj_spawn = $Path2D/PathFollow2D
	proj_spawn.progress_ratio = randi_range(0,1)
	
	if randomizer % 4 == 0:
		projectile_properties(proj,'Soft',1,50,Vector2(-(250+difficulty),0),9,25,30,Vector2(-50,-100),Vector2(-50,-100),'Level_2')
		proj.change_hitbox(Vector2(30,5),Vector2(0,0))
		proj_spawn.progress_ratio = 0.6
	elif randomizer % 3 == 0:
		projectile_properties(proj,'Hard',4,25,Vector2(-(50+difficulty),0),12,35,40,Vector2(-25,-500),Vector2(-75,-200),'Level_3')
		proj.change_hitbox(Vector2(30,30),Vector2(0,0))
	elif randomizer % 2 == 0:
		projectile_properties(proj,'Soft',2,50,Vector2(-(200+difficulty),0),9,25,30,Vector2(-50,-400),Vector2(-50,-400),'Level_2')
		proj.change_hitbox(Vector2(25,15),Vector2(0,0))
	else:
		projectile_properties(proj,'None',1,100,Vector2(-(100+difficulty),0),6,15,20,Vector2(-80,-40),Vector2(-65,-300),'Level_1')
		proj.change_hitbox(Vector2(20,20),Vector2(0,0))
	
	proj.position = proj_spawn.position
	
	
	add_child(proj)

func projectile_properties(proj : RigidBody2D, knockdown : String, hits : int, damage : int, Velocity : Vector2, hitstop : int, hitstunG : int, hitstunA, KnockbackG : Vector2, KnockbackA : Vector2, sprite : String) -> void:
	proj.projectileknockdown = knockdown
	proj.projectileHits = hits
	proj.projectileDamage = damage
	proj.projectileMovementvector = Velocity
	proj.Hitstop = hitstop
	proj.HitstunOnGroundhit = hitstunG
	proj.HitstunOnAirhit = hitstunA
	proj.KnockbackOnGroundhit = KnockbackG
	proj.KnockbackOnAirhit = KnockbackA
	proj.Sprite = sprite

func _on_goal_next_level() -> void:
	var children = get_children()
	for i in children:
		if i.is_in_group('Projectiles'):
			i.queue_free()
	score += 1
	_ready()
