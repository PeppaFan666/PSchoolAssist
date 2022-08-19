extends Node

func _on_Button_pressed():
	$FileDialog.popup(Rect2(Vector2(500,300),Vector2(30,500)))

signal Upload(data)


func _on_FileDialog_file_selected(path):
	var file = File.new()
	file.open(path, File.READ)
	emit_signal("Upload",file.get_as_text())
