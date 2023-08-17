extends Node3D

signal open_portal()
@onready var gameState := $"/root/GameState"

func _on_timer_timeout():
	open_portal.emit()

func _on_le_door_area_entered():
	if gameState.level_index == 1:
		get_tree().change_scene_to_file("res://Scenes/Level1_No_Gate.tscn")
	if gameState.level_index == 2:
		get_tree().change_scene_to_file("res://Scenes/Level2_Extenders.tscn")
	if gameState.level_index == 3:
		get_tree().change_scene_to_file("res://Scenes/Level3_Not.tscn")
	if gameState.level_index == 4:
		get_tree().change_scene_to_file("res://Scenes/Level4_Or.tscn")
	if gameState.level_index == 5:
		get_tree().change_scene_to_file("res://Scenes/Level5_And.tscn")
	if gameState.level_index == 6:
		get_tree().change_scene_to_file("res://Scenes/Level6_Nor.tscn")
	if gameState.level_index == 7:
		get_tree().change_scene_to_file("res://Scenes/Level7_Nand.tscn")
	pass # Replace with function body.
