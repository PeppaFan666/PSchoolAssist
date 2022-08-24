extends Node





func _on_Button_pressed():
	$FileDialog.popup(Rect2(Vector2(500,300),Vector2(30,500)))


func _on_FileDialog_file_selected(path):
	write(path)
	
func write(path):
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(Global.set)
	file.close()
	
