extends CSGBox3D

func on_interact(interactor, interaction_raycast) -> bool:
	print("%s touched by %s" % [self, interactor])
	#print("Material: %s" % self.get_material())
	open()
	return true

func open() -> void:
	print("opened door")
	get_tree().change_scene_to_file("res://Scenes/level_2_test.tscn")
