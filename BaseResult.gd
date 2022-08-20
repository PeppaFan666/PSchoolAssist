extends RichTextLabel



func _on_BaseInterface_CalculationComplete(value, base):
	var s = "The Result Is: %s in %s base"
	text = s % [str(value),str(base)]
