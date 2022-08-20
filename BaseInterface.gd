extends Control


signal CalculationComplete(value,base)


func Calc() -> void:
	var n = $BaseConverter.anyToNorm(Global.Base_Input_NUM,Global.Base_Input_Base)
	var res = $BaseConverter.normToAny(n,Global.Base_Output_Base)
	if Global.Base_Input_NUM == 0:
		res = 0
	emit_signal("CalculationComplete",res,Global.Base_Output_Base)

func _on_Input_Base_value_changed(value):
	Global.Base_Input_Base = value
	Calc()


func _on_Output_Base_value_changed(value):
	Global.Base_Output_Base = value
	Calc()


func _on_SpinBox_value_changed(value):
	Global.Base_Input_NUM = value
	Calc()
