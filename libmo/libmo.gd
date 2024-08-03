extends Object
class_name moLib

var player : moPlayer
var game : moGame
var minimap : moMap
var getPlayer : HTTPRequest
var createPlayer : HTTPRequest
var getGame : HTTPRequest
var getMap : HTTPRequest
var setInput : HTTPRequest

var backpack : Marker2D

var deltaT : float = 0.0

var playerToken : String
var playerCreated: bool = false

@export var updateDeltaMs : int = 1000
@export var playerName : String = "TestPlayer"
@export var playerID : String = ""

@export var serverURL : String = "http://localhost:8080"
@export var playerPath : String = "/player/"
@export var configPath : String = "/config"
@export var mapPath : String = "/surroundings"

var getPlayerPath : String = ""
var getMapPath : String = ""
var getConfigPath : String = ""

func setup():
	player = moPlayer.new()
	game = moGame.new()
	minimap = moMap.new()
	pass

func registerPlayer():
	createPlayer.request(serverURL + playerPath + playerName, [], HTTPClient.METHOD_POST)
	pass

func setWeb(webCreate, webPlayer, webGame, webMap, webInput):
	getPlayer = webPlayer
	createPlayer = webCreate
	getGame = webGame
	getMap = webMap
	setInput = webInput
	createPlayer.connect("request_completed", Callable(self, "_on_player_created"))
	getPlayer.connect("request_completed", Callable(self, "_on_player_queried"))
	getGame.connect("request_completed", Callable(self, "_on_game_queried"))
	getMap.connect("request_completed", Callable(self, "_on_map_queried"))
	setInput.connect("request_completed", Callable(self, "_on_input_sent"))
	registerPlayer()
	pass

func setUI(backPack):
	backpack = backPack
	pass

func _on_player_created(result, response_code, headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var json = test_json_conv.get_data()
	playerID = json
	playerCreated = true
	getPlayerPath = serverURL + playerPath + playerID
	getConfigPath = serverURL + configPath
	getMapPath = serverURL + playerPath + playerID + mapPath
	pass

func _on_player_queried(result, response_code, headers, body):
	var test_json_conv = JSON.new()
	test_json_conv.parse(body.get_string_from_utf8())
	var json = test_json_conv.get_data()
	backpack.setItems(json.result["Cards"])
	pass

func _on_game_queried(result, response_code, headers, body):
	pass

func _on_map_queried(result, response_code, headers, body):
	pass

func _on_input_sent(result, response_code, headers, body):
	pass



func input(item, itemType):
	if itemType == 0 || itemType == 1:
		#$SetInput.request(api_consumeURL+String(itemType), [], false, HTTPClient.METHOD_PUT)
		pass
	elif itemType == 2:
		#$SetInput.request(api_playURL+String(itemType), [], false, HTTPClient.METHOD_PUT)
		pass
	pass


func setTiles(inputTiles):
	minimap.setTiles(inputTiles)
	pass

func _process(delta):
	deltaT += delta
	if (deltaT > updateDeltaMs):
		player.update()
		game.update()
		minimap.update()
		deltaT = 0.0
	pass

#Input type order: Consume, Discard, Play
#Input order: Food, Wood, Weapon, Dice, Research, None
#func input_card(item):
#	var itemType = item.getItem()
#	if itemType == 0 || itemType == 1:
#		#$SetInput.request(api_consumeURL+String(itemType), [], false, HTTPClient.METHOD_PUT)
#		pass
#	elif itemType == 2:
#		#$SetInput.request(api_playURL+String(itemType), [], false, HTTPClient.METHOD_PUT)
#		pass
#	pass


