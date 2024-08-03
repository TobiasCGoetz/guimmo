extends Node2D

@export var tileSize = 256

var tiles = []
var directions = ["NW", "NN", "NE", "WW", "CE", "EE", "SW", "SS", "SE"]

var libmo : moLib

func _ready():
	#UI setup
	tiles = get_node("MapPosition").get_children()
	$Timer.set_global_position(Vector2(960, 50))
	
	#Init libmo
	libmo = moLib.new()
	libmo.setup()
	libmo.setWeb($Web/CreatePlayer, $Web/GetPlayer, $Web/GetGame, $Web/GetMap, $Web/SetInput)
	libmo.setUI($BackpackPosition)
	libmo.setTiles(tiles)
	pass

#Input order: North, East, South, West, Stay
func input_direction(tile):
	var dir = 4
	if tile == tiles[1]:
		dir = 0
	elif tile == tiles[5]:
		dir = 1
	elif tile == tiles[7]:
		dir = 2
	elif tile == tiles[3]:
		dir = 3
	#Call endpoint with int as path argument
	#$SetInput.request(api_moveURL+String(dir), [], false, HTTPClient.METHOD_PUT)
	pass

#Input type order: Consume, Discard, Play
#Input order: Food, Wood, Weapon, Dice, Research, None
func input_card(item):
	var itemType = item.getItem()
	libmo.input(item, itemType)
	pass

func _process(delta):
	libmo._process(delta)
	pass
