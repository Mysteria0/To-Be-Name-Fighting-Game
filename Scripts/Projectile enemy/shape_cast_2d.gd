extends ShapeCast2D
@onready var parent := $".."

func _physics_process(delta: float) -> void:
	if is_colliding() and parent.disabledtimer == 0:
		for i in get_collision_count():
			var Collider = get_collider(i)
			#if Collider.is_in_group("Players"):
				#Collider.velocity *= 0
				#Collider.global_position -= collisionpoint
			#else:
				#parent.global_position -= collisionpoint
				#parent.projectileHits = 0
			Collider.position += Collider.velocity
	force_shapecast_update()
