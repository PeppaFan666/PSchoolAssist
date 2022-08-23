extends TextEdit

var rules : Dictionary = {}

func _ready():
	#add_keyword_color("|", Color(0.542969, 0.231186, 0.135742))
	add_keyword_color("let", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("get", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("check", Color(0.406166, 0.542969, 0.135742))
	#add_keyword_color(" x ", Color(0.065308, 0.368376, 0.417969))
	add_keyword_color("xI", Color(0.065308, 0.368376, 0.417969))
	
	add_keyword_color("for", Color(0.417969, 0.065308, 0.26368))

func run(code : String) -> void:
	var lines := code.split(";")
	for line in lines:
		if "let" in line: # line = let A = {xI x < 6}
			var l = line.split("=") #l = [let A, {xI x < 6}]
			
			#begin getting varName 
			var l2 = l[0].split("let") # l2 = [,  A 0]
			var varName = clean(l2[1]) # varName = A
			#finish getting varName 
			
			#begin getting Rule
			l2 = l[1].split("xI") #l2 = [{, x<6}}
			var rule = clean(l2[1],[" ","{","}"]) #rule = x<6
			#finish getting Rule
			rules[varName] = rule #finish parsing
			print(rules)


func clean(input: String,removes = [" "]) -> String:
	var s = ""
	for i in input:
		if not i in removes:
			s+= i
	return s

func _on_Button_pressed():
	run(text)
