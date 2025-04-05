extends Node2D

func _ready():
	$Label.text = "That's Okay. 
	Have a Good day!"
	$Label.modulate = Color.WHITE
	
	
	$Button.text = "Exit"
	
func _on_button_pressed() -> void:
	get_tree().quit()
	return
	
