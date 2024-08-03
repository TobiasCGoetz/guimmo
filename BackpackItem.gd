extends Node2D

var itemType : int = 0

func _ready():
	self.setItem(0)
	useOff()
	pass

func input():
	$"../../".input_card(self)
	pass

func getItem():
	return itemType

# Order: Food, Wood, Weapon, Dice, Research, None
func setItem(i: int):
	itemType = i
	$Food.visible = false
	$Wood.visible = false
	$Weapon.visible = false
	$Research.visible = false
	$None.visible = false
	if itemType == 0:
		$Food.visible = true
	elif itemType == 1:
		$Wood.visible = true
	elif itemType == 2:
		$Weapon.visible = true
	elif itemType == 4:
		$Research.visible = true
	elif itemType == 5:
		$None.visible = true
	pass

func toggleUse():
	$InUse.visilbe = !$InUse.visible
	pass

func useOff():
	$InUse.visible = false
	pass

func useOn():
	$InUse.visible = true
	pass



