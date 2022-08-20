extends HSlider


func _on_Input_Base_value_changed(value):
	$Value.text = str(value)
