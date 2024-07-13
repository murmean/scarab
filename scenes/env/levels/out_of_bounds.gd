extends Area3D



func _on_body_entered(body):
	if body is InteractablePhysicsObject:
		if body.obj_health < body.speed_threshold * 2:
			body.queue_free()
	
	if body:
		body.position = $Marker3D.position
