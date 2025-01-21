extends Marker2D


var directions = ["NW", "NN", "NE", "WW", "CE", "EE", "SW", "SS", "SE"]
var tiles = []
var tileSize = 256
var tileGap = 16
var yOffset = 32

func input_pressed(caller):
	pass 

func clearSelected():
	for tile in tiles:
		tile.deselect()
	pass

func _ready():
	var positions = [tileGap, 2*tileGap+tileSize, 3*tileGap+2*tileSize]
	tiles.append(get_node("./NWTile"))
	tiles.append(get_node("./NNTile"))
	tiles.append(get_node("./NETile"))
	tiles.append(get_node("./WWTile"))
	tiles.append(get_node("./CETile"))
	tiles.append(get_node("./EETile"))
	tiles.append(get_node("./SWTile"))
	tiles.append(get_node("./SSTile"))
	tiles.append(get_node("./SETile"))
	
	tiles[0].translate(Vector2(positions[0], positions[0]+yOffset))
	tiles[1].translate(Vector2(positions[1], positions[0]+yOffset))
	tiles[2].translate(Vector2(positions[2], positions[0]+yOffset))
	tiles[3].translate(Vector2(positions[0], positions[1]+yOffset))
	tiles[4].translate(Vector2(positions[1], positions[1]+yOffset))
	tiles[5].translate(Vector2(positions[2], positions[1]+yOffset))
	tiles[6].translate(Vector2(positions[0], positions[2]+yOffset))
	tiles[7].translate(Vector2(positions[1], positions[2]+yOffset))
	tiles[8].translate(Vector2(positions[2], positions[2]+yOffset))
	pass
