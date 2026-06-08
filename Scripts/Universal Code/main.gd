extends Node2D

@export var proj_scene: PackedScene

var difficulty : int

func _ready() -> void:
	get_tree().paused = false
	difficulty += 1
	$Timer.start(3)


func _on_player_death() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file('res://menu.tscn')




func _on_timer_timeout() -> void:
	var proj = proj_scene.instantiate()
	
	var proj_spawn = $Path2D/PathFollow2D
	proj_spawn.progress_ratio = randi_range(0,1)
	
	proj.position = proj_spawn.position
	
	proj.projectileknockdown = "None"
	proj.projectileHits = 1
	proj.projectileDamage = 100
	proj.projectileMovementvector = Vector2(randf_range(-200,-100),0)
	proj.Hitstop = 4
	proj.HitstunOnGroundhit = 20
	proj.HitstunOnAirhit = 30
	proj.KnockbackOnGroundhit = Vector2i(-65,-35)
	proj.KnockbackOnAirhit = Vector2i(-45,-250)
	add_child(proj)


func _on_goal_next_level() -> void:
	_ready()
