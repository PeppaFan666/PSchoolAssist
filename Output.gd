extends TextEdit



func _on_Editor_output(value):
	text += "\n    " + value 


func _on_Clear_pressed():
	text = ""
