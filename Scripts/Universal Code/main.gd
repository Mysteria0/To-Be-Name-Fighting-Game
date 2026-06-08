extends Node2D

@export var proj_scene: PackedScene

var difficulty : int

func _ready() -> void:
	get_tree().paused = false
	difficulty += 1

func _on_projectile_timer_timeout() -> void:
	var proj = proj_scene.instantiate()
	
	var proj_spawn = $Path2D/PathFollow2D
	proj_spawn.progress_ratio = randf()
	
	proj.position = proj_spawn.position
	var randomproj = randi_range(0,0)
	
	if randomproj == 0:
		proj.projectileknockdown = "None"
		proj.projectileHits = 1
		proj.projectileDamage = 100
		proj.projectileMovementvector = Vector2(randf_range(-200,-100),0)
		proj.Hitstop = 4
		proj.HitstunOnGroundhit = 40
		proj.HitstunOnAirhit = 60
		proj.KnockbackOnGroundhit = Vector2i(-65,-35)
		proj.KnockbackOnAirhit = Vector2i(-45,-250)
	if randomproj == 1:
		proj.projectileknockdown = "Soft"
		proj.projectileHits = 2
		proj.projectileDamage = 54
		proj.projectileMovementvector = Vector2(randf_range(-100,-50),0)
		proj.Hitstop = 16
		proj.HitstunOnGroundhit = 100
		proj.HitstunOnAirhit = 100
		proj.KnockbackOnGroundhit = Vector2i(-100,-50)
		proj.KnockbackOnAirhit = Vector2i(-83,-100)
		proj.modulate = Color(205,128,87)
	add_child(proj)


func _on_player_death() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file('res://menu.tscn')


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file('res://main.tscn')
		difficulty += 1
		
