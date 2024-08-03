extends Node2D

var tileArray = []
var cardArray = []

var tileDict = {
	"playersPlanMoveNorth" : 0,
	"playersPlanMoveEast": 0,
	"playersPlanMoveSouth": 0,
	"playersPlanMoveWest": 0,
	"zombieCount" : 0,
	"playerCount" : 0,
	"tileType" : "",
}

@export var serverURL : String = "http://localhost"
@export var serverPort : int = 8080

@export var getPlayerDelta : float = 0.5
@export var getSurroundingsDelta : float = 0.3
@export var getConfigDelta : float = 60.0
var getPlayerTimer : Timer
var getSurroundingsTimer : Timer
var getConfigTimer : Timer

var web : HTTPRequest

var playerName : String = "topi"
var playerToken : String = ""
var playerAlive : bool = true

var gameTimer : int = 60
var gameOver : bool = false

var mapDict = {
	"NW" : tileDict,
	"NN" : tileDict,
	"NE" : tileDict,
	"WW" : tileDict,
	"CE" : tileDict,
	"EE" : tileDict,
	"SW" : tileDict,
	"SS" : tileDict,
	"SE" : tileDict
}

var inputStringArray = [
	"DISABLED",
	"NORTH",
	"DISABLED",
	"WEST",
	"STAY",
	"EAST",
	"DISABLED",
	"SOUTH",
	"DISABLED"
]

func _http_request_completed(result, response_code, headers, body, action, webInstance):
	if response_code != 200:
		pass
	print(action)
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	match action:
		"getConfig":
			print("Matched ", action)
			self.gameTimer = response['TurnTime']
			self.gameOver = response['HaveWon']
		"getSurroundings":
			for key in response:
				get_node("./rootContainer/Map/"+key).updateByDict(response[key])
		"getPlayer":
			print("Matched ", action)
			self.playerAlive = response['Alive']
			for i in range(4):
				cardArray[i].updateType(response['Cards'][i])
			for tile in tileArray:
				tile.set_pressed(false)
			match response['Direction']:
				"North":
					get_node("rootContainer/Map/NN").set_pressed(true)
				"East":
					get_node("rootContainer/Map/EE").set_pressed(true)
				"South":
					get_node("rootContainer/Map/SS").set_pressed(true)
				"West":
					get_node("rootContainer/Map/WW").set_pressed(true)
		"setDirection":
			print("Matched ", action)
		"setConsume":
			print("Matched ", action)
		"setPlayer":
			print("Matched ", action)
			self.playerToken = response
			print("Player token is ", self.playerToken)
	webInstance.queue_free()
	pass

func _moveInput(inputString : String):
	print("Input sent with '"+inputString+"'")
	_web_request(
		HTTPClient.METHOD_PUT,
		"/player/"+playerToken+"/direction/"+inputString,
		 "",
		 "setDirection"
		)
	pass

func _cardInput(cardType : String):
	print("Consume sent with "+cardType)
	_web_request(
		HTTPClient.METHOD_PUT,
		"/player/"+playerToken+"/consume/"+cardType,
		"",
		"setConsume"
		)
	pass

func _ready():
	register_player(self.playerName)
	tileArray = get_node("rootContainer/Map").get_children()
	for i in range(len(tileArray)):
		tileArray[i].setId(inputStringArray[i])
		tileArray[i].moveInput.connect(_moveInput)
	cardArray = get_node("rootContainer/Cards").get_children()
	for i in range(len(cardArray)):
		cardArray[i].cardInput.connect(_cardInput)
	
	#Regular updates by timer
	getPlayerTimer = Timer.new()
	getSurroundingsTimer = Timer.new()
	getConfigTimer = Timer.new()
	add_child(getPlayerTimer)
	add_child(getSurroundingsTimer)
	add_child(getConfigTimer)
	getPlayerTimer.timeout.connect(query_player)
	getSurroundingsTimer.timeout.connect(query_surroundings)
	getConfigTimer.timeout.connect(query_config)
	getSurroundingsTimer.start(getSurroundingsDelta)
	getPlayerTimer.start(getPlayerDelta)
	getConfigTimer.start(getConfigDelta)
	pass

func set_direction(direction : String):
	pass

func query_config():
	var error = _web_request(HTTPClient.METHOD_GET, "/config", "", "getConfig")
	pass

func query_player():
	print("queryPlayer->playerToken: ", playerToken)
	var error = _web_request(HTTPClient.METHOD_GET, "/player/"+playerToken, "", "getPlayer")
	pass

func query_surroundings():
	var error = _web_request(HTTPClient.METHOD_GET, "/player/"+playerToken+"/surroundings", "", "getSurroundings")
	pass

func register_player(name : String):
	self.playerName = name
	var error = _web_request(HTTPClient.METHOD_POST, "/player/"+playerName, "", "setPlayer")
	pass

func _web_request(method : HTTPClient.Method, endpoint : String, body : String, action : String):
	web = HTTPRequest.new()
	add_child(web)
	if not web.request_completed.is_connected(self._http_request_completed):
		web.request_completed.connect(self._http_request_completed.bind(action, web))
	web.request(serverURL+":"+str(serverPort)+endpoint, [], method, body)
