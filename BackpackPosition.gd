extends Marker2D


var items = []
var itemSize = 256
var itemGap = 16

func input_pressed(caller):
	pass

func setItems(cardArray):
	for x in 4:
		items[x].setItem(cardArray[x])
	pass

func _ready():
	var positions = [itemGap, 2*itemGap+itemSize]
	items.append(get_node("./BackpackItem0"))
	items.append(get_node("./BackpackItem1"))
	items.append(get_node("./BackpackItem2"))
	items.append(get_node("./BackpackItem3"))
	items[0].translate(Vector2(positions[0], positions[0]))
	items[1].translate(Vector2(positions[1], positions[0]))
	items[2].translate(Vector2(positions[0], positions[1]))
	items[3].translate(Vector2(positions[1], positions[1]))
	pass

