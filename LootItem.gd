class_name LootItem extends Resource

var id = -1
var name = 'Generic Item'
var texture = null
var category = null
var sub_category = null
var description = "No description"
var drop_chance = 0.0

func _init():
    pass

# Calculate a whether we drop or not
func didDrop():
    var rand_val = randf()
    # If we get 0, by some chance...try again.
    if rand_val == 0.0:
        rand_val = randf()
    return rand_val <= drop_chance and rand_val > 0

# Makes the default string output when printing include the id and name
func _to_string():
    var format_string = "<%s#%s>"
    var base_response = format_string % [get_class(),get_instance_id()]
    return base_response + " -> %s:%s" % [id, name]
