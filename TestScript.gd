#@tool
#extends EditorScript
extends Node

# const Security = preload("res://scripts/security.gd")
# var sec = Security.new()

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var lt = LootTable.new()
	print(lt.drop_loot_by_category('Food'))

func _init():
	_run()
