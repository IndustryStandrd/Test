extends RayCast3D

@onready var player_interact = $"."

#func _process(delta):
	#if player_interact.is_colliding() and Input.is_action_just_pressed("Interact"):
		#var obj = player_interact.get_collider()
		#if obj and obj.has_method("open"):
			#obj.open()


