extends Node


func _on_TextEdit_text_changed():
	Global.text = get_parent().text


func _on_Upload_Upload(data):
	get_parent().text = data
