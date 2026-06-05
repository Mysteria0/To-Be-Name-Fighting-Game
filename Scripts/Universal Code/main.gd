extends Node2D

@export var proj_scene: PackedScene



func _on_projectile_timer_timeout() -> void:
	var proj = proj_scene.instantiate()
	
	var proj_spawn = $Path2D/PathFollow2D
	proj_spawn.progress_ratio = randf()
	
	proj.position = proj_spawn.position
	
	proj.projectileknockdown = "None"
	proj.projectileHits = 1
	proj.projectileDamage = 100
	proj.projectileMovementvector = Vector2(randf_range(-200,-100),randf_range(-15,15))
	proj.Hitstop = 4
	proj.HitstunOnGroundhit = 40
	proj.HitstunOnAirhit = 60
	proj.KnockbackOnGroundhit = Vector2i(-65,-35)
	proj.KnockbackOnAirhit = Vector2i(-900,-120)
	add_child(proj)


func _on_player_death() -> void:
	get_tree().paused = true
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file('res://menu.tscn')


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file('res://menu.tscn')
