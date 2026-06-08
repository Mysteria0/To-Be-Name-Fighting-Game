extends Sprite2D

signal Next_level

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Players"):
		get_tree().paused = true
		await get_tree().create_timer(1.0).timeout
		Next_level.emit()
