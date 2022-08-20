extends Node

var letters = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

func GenrateDictionary():
	var s := ""
	for i in range(26):
		s += str(i + 10)  + ":" + "\'" + letters[i] + "\'" + ","
	return s

var conversion_table = {0: '0', 1: '1', 2: '2', 3: '3', 4: '4',
					5: '5', 6: '6', 7: '7',
					8: '8', 9: '9',10:'A',11:'B',12:'C'
					,13:'D',14:'E',15:'F',16:'G',17:'H'
					,18:'I',19:'J',20:'K',21:'L',
					22:'M',23:'N',24:'O',25:'P',26:'Q',27:'R',
					28:'S',29:'T',30:'U',
					31:'V',32:'W',33:'X',34:'Y',35:'Z',
}
 
func anyToNorm(num : int,x : int) -> int:
	var n := str(num)
	var z := 0
	for i in range(len(n)):
		var t := int(n[len(n)-1-i])
		z += t * pow(x,i)
		
	return z

func normToAny(orig:int,base : int) -> String:
	var result = ''
	while(orig > 0):
		var remainder = orig % base
		result = conversion_table[remainder] + result
		orig = floor(orig / base)
 
	return result
 
func Convert(num: int, x :int, y :int) -> String:
	return normToAny(anyToNorm(num,x),y)

#func _ready():
	#var oct = anytonorm(2845,8)
	#print(floor(21/2))
	#print(1%2)
	#print(oct)
	#print(normtoany(590,16))
	#print(GenrateDictionary())
	#print((188%16) % 10)
	#print(normToAny(oct,35))
