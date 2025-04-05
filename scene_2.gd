extends Node2D

func _ready():
	$Label.text = "How May We Help?"
	$Label.modulate = Color.WHITE
	
	$Button1.text = "I Have a Question"
	$Button2.text = "Nevermind"



func _on_button_1_pressed() -> void:
	get_tree().change_scene_to_file("res://scene_3.tscn")
	

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://scene_4.tscn")
	
