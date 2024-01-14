extends RayCast3D

@onready var player_interact = $"."

func _process(delta):
	if player_interact.is_colliding() and Input.is_action_just_pressed("Interact"):
		print("Openingplayer_interact")

