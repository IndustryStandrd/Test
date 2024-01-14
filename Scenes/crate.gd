extends CSGBox3D

var is_open = false
var audio_player = AudioStreamPlayer3D.new()
var open_audio_stream = load("res://Assets/Sounds/DRWRWood_Wooden drawer opening (ID 1499)_BSB.ogg")
var close_audio_stream = load("res://Assets/Sounds/DRWRWood_Wooden drawer closing (ID 1500)_BSB.ogg")

func _ready():
	self.add_child(audio_player)

func on_interact(interactor, interaction_raycast) -> bool:
	print("%s touched by %s" % [self, interactor])
	#print("Material: %s" % self.get_material())
	if is_open:
		close()
	else:
		open()
	return true

func open() -> void:
	audio_player.stream = open_audio_stream
	audio_player.play()
	print("opened crate")
	is_open = true
	
func close() -> void:
	audio_player.stream = close_audio_stream
	audio_player.play()
	print("closed crate")
	is_open = false
