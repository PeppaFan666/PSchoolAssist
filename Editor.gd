extends TextEdit

var rules : Dictionary = {}

signal output(value)

func _ready():
	#add_keyword_color("|", Color(0.542969, 0.231186, 0.135742))
	add_keyword_color("let", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("get", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("check", Color(0.406166, 0.542969, 0.135742))
	#add_keyword_color(" x ", Color(0.065308, 0.368376, 0.417969))
	add_keyword_color("xI", Color(0.065308, 0.368376, 0.417969))
	
	add_keyword_color("for", Color(0.417969, 0.065308, 0.26368))
	add_keyword_color("unin", Color(0.417969, 0.065308, 0.26368))
	add_keyword_color("intr", Color(0.417969, 0.065308, 0.26368))

func run(code : String) -> void:
	var lines := code.split(";")
	for line in lines:
		if "let" in line: # line = let A = {xI x < 6}
			if "unin" in line:
				eval_unin(line)
				continue
			if "intr" in line:
				eval_intr(line)
				continue
			eval_let(line)
		if "check" in line: # line = check a for 10
			eval_check(line)

func eval_unin(line: String) -> void:
	var l = line.split("=") #l =[let c ,  a unin b]
	#begin getting varName 
	var l2 = l[0].split("let") # l2 = [,  c ]
	var varName = clean(l2[1]) # varName = c
	#finish getting varName 
	var unin = l[1].split(" ")
	var rule = clean(unin[1]) + "-" +  clean(unin[2]) + "-" +  clean(unin[3])
	rules[varName] = rule
func eval_intr(line: String) -> void:
	var l = line.split("=") #l =[let c ,  a intr b]
	#begin getting varName 
	var l2 = l[0].split("let") # l2 = [,  c ]
	var varName = clean(l2[1]) # varName = c
	#finish getting varName 
	var intr = l[1].split(" ")
	var rule = clean(intr[1]) + "-" +  clean(intr[2]) + "-" +  clean(intr[3])
	rules[varName] = rule

func eval_let(line : String) -> void:
	var l = line.split("=") #l = [let A, {xI x < 6}]
	
	#begin getting varName 
	var l2 = l[0].split("let") # l2 = [,  A 0]
	var varName = clean(l2[1]) # varName = A
	#finish getting varName 
	
	#begin getting Rule
	l2 = l[1].split("xI") #l2 = [{, x<6}}
	var l3 = clean(l2[1],["{","}"]).split(" ") #rule = x<6
	var rule = clean(l3[1])+ " " + clean(l3[2]) + " " + clean(l3[3])
	#finish getting Rule
	rules[varName] = rule #finish parsing


func eval_check(line : String) -> void:
	var l = line.split("for") #l = [check a ,  10]
	#get key
	var dirtyKey = l[0].split("check") #dirtyKey = [,  a ]
	var key = clean(dirtyKey[1]) # a
	#finish get key
	var x = clean(l[1]) #x = 10
	var res = process_rule(key,x)
	var st = ""
	if res:
		st = "%s is in set %s"
	else:
		st = "%s is not in set %s"
	emit_signal("output", st % [x,key.to_upper()])


func process_rule(key: String,x : String) -> bool:
	var rule = rules[key]
	
	if "unin" in rule:
		var l2 = rule.split("-")
		if process_rule(l2[0],x):
			return true
		if process_rule(l2[2],x):
			return true
		return false
	if "intr" in rule:
		var l2 = rule.split("-")
		if process_rule(l2[0],x) and process_rule(l2[2],x):
			return true
		return false
	
	var s = ""
	for letter in rule:
		if letter == "x":
			letter = x
		s += letter
	rule = s
	var split = rule.split(" ")
	var left = float(split[0])
	var right = float(split[2])
	var check = split[1]
	match check:
		">":
			return left > right
		"<":
			return left < right
		"|":
			return left == right
		">|":
			return left >= right
		"<|":
			return left <= right
	return false

func get_all(input: String,from : int) -> String:
	var s = ""
	for i in range(from,len(input)):
			s+= input[i]
	return s

func clean(input: String,removes = [" "]) -> String:
	var s = ""
	for i in input:
		if not i in removes:
			s+= i
	return s

func _on_Button_pressed():
	run(text)




func _on_Editor_text_changed():
	Global.set = text


func _on_Upload_Upload(data):
	text = data
