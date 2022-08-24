extends TextEdit

var rules : Dictionary = {}
var sets : Dictionary = {}

signal output(value)

func _ready():
	#add_keyword_color("|", Color(0.542969, 0.231186, 0.135742))
	add_keyword_color("let", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("collect", Color(0.406166, 0.542969, 0.135742))
	add_keyword_color("into", Color(0.406166, 0.542969, 0.135742))
	#add_keyword_color(" x ", Color(0.065308, 0.368376, 0.417969))
	add_keyword_color("xI", Color(0.065308, 0.368376, 0.417969))
	
	add_keyword_color("for", Color(0.417969, 0.371131, 0.065308))
	add_keyword_color("by", Color(0.417969, 0.371131, 0.065308))
	add_keyword_color("until", Color(0.417969, 0.371131, 0.065308))
	add_keyword_color("is", Color(0.417969, 0.371131, 0.065308))
	
	add_keyword_color("unin", Color(0.417969, 0.065308, 0.26368))
	add_keyword_color("intr", Color(0.417969, 0.065308, 0.26368))
	add_keyword_color("compound", Color(0.417969, 0.065308, 0.26368))
	add_keyword_color("conform", Color(0.417969, 0.065308, 0.26368))
	
	add_keyword_color("get", Color(0.660156, 0.479484, 0.051575))
	add_keyword_color("check",Color(0.660156, 0.479484, 0.051575))
	add_keyword_color("out",Color(0.660156, 0.479484, 0.051575))
	
	add_keyword_color("real",Color(0.373517, 0.008774, 0.449219))
	add_keyword_color("rational",Color(0.373517, 0.008774, 0.449219))
	add_keyword_color("irrational",Color(0.373517, 0.008774, 0.449219))
	

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
		if "collect" in line:
			eval_collect(line)
		if "check" in line: # line = check a for 10
			eval_check(line)
		if "out" in line:
			eval_out(line)
		if "compound" in line:
			eval_compound(line)
		if "conform" in line:
			eval_conform(line)
		if "get" in line:
			eval_get(line)
			
func eval_get(line: String) -> void:
	var l2 = line.split("until")
	var num = clean(l2[1])
	
	var l3 = l2[0].split("get")
	var key = clean(l3[1])
	
	var res = ""
	
	for i in range(int(num)+1):
		if process_rule(key,str(i)):
			res+= str(i) + ","
	if len(res) == 0:
		res += "null,"
	var fin = ""
	for i in range(len(res)-1):
		fin += res[i]
	var st = "%s = %s until %s"
	st = st % [key,fin,num]
	emit_signal("output",st)
	
func eval_conform(line: String) -> void:
	var l2 = line.split("by")
	var keyList = l2[1].split("into")
	var key = clean(keyList[1])
	var two = clean(keyList[0])
	var startList = l2[0].split("conform")
	var one = clean(startList[1])
	var oneList = sets[one].split(",")
	
	
	var res = ""
	
	for x in oneList:
		if process_rule(two,x):
			res += x + ","
	if len(res) == 0:
		res += "null,"
	var fin = ""
	for i in range(len(res)-1):
		fin += res[i]
	sets[key] = fin
	
func eval_compound(line: String) -> void:
	var l2 = line.split("compound")
	l2 = l2[1].split("into")
	var newset = []
	if "intr" in l2[0]:
		var l3 = l2[0].split("intr")
		var one = sets[clean(l3[0])]
		var two = sets[clean(l3[1])]
		var intone = []
		var inttwo = []
		for i in one.split(","):
			intone.append(int(i))
		for i in two.split(","):
			inttwo.append(int(i))
		for i in intone:
			if i in inttwo:
				if (i in newset):
					continue
				newset.append(i)
		for i in inttwo:
			if i in intone:
				if (i in newset):
					continue
				newset.append(i)
	if "unin" in l2[0]:
		var l3 = l2[0].split("unin")
		var one = sets[clean(l3[0])]
		var two = sets[clean(l3[1])]
		var intone = []
		var inttwo = []
		for i in one.split(","):
			intone.append(int(i))
		for i in two.split(","):
			inttwo.append(int(i))
		for i in intone:
			if (i in newset):
				continue
			newset.append(i)
		for i in inttwo:
			if (i in newset):
				continue
			newset.append(i)
	var res = ""
	newset = Array(newset)
	newset.sort()
	for i in newset:
		res += str(i) + ","
	if len(newset) == 0:
		res += "null,"
	var fin = ""
	for i in range(len(res)-1):
		fin += res[i]
	sets[clean(l2[1])] = fin

	
func eval_out(line: String) -> void:
	var l2 = line.split("out")
	var st = "%s = %s"
	var key =clean(l2[1])
	st = st % [key,sets[key]]
	
	emit_signal("output",st)

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
	
func eval_collect(line : String) -> void:
	var l = line.split("=") #l = [let A, {xI x < 6}]
	
	#begin getting varName 
	var l2 = l[0].split("collect") # l2 = [,  A 0]
	var varName = clean(l2[1]) # varName = A
	#finish getting varName 
	
	#begin getting Rule
	l2 = l[1] #l2 = [{, x<6}}
	
	var l3 = clean(l2,[" ","{","}"])
	sets[varName] = l3


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
	var right = split[2]
	var check = split[1]
	match check:
		">":
			return left > float(right)
		"<":
			return left < float(right)
		"|":
			return left == float(right)
		">|":
			return left >= float(right)
		"<|":
			return left <= float(right)
		"is":
			if right == "real":
				return not("i" in split[0])
			if right == "rational":
				if "."  in split[0]:
					var decs = []
					var split2 = split[0].split(".")
					for i in split2[1]:
						if i in decs:
							continue
						decs.append(i)
					if len(decs) > len(split2[1]) /2:
						return false
				return true	
			if right == "irrational":
				if "."  in split[0]:
					var decs = []
					var split2 = split[0].split(".")
					for i in split2[1]:
						if i in decs:
							continue
						decs.append(i)
					if len(decs) > len(split2[1]) /2:
						return true
				return false
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
