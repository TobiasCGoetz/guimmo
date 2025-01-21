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

@export var getPlayerDelta : float = 0.5
@export var getSurroundingsDelta : float = 0.3
@export var getConfigDelta : float = 60.0
var getPlayerTimer : Timer
var getSurroundingsTimer : Timer
var getConfigTimer : Timer

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

@onready var gApi = $gommoApi

func handleGetPlayerDone(alive : bool, cards : Array, direction : String):
	self.playerAlive = alive
	for i in range(4):
		cardArray[i].updateType(cards[i])
	for tile in tileArray:
		tile.set_pressed(false)
	match direction:
		"North":
			get_node("rootContainer/Map/NN").set_pressed(true)
		"East":
			get_node("rootContainer/Map/EE").set_pressed(true)
		"South":
			get_node("rootContainer/Map/SS").set_pressed(true)
		"West":
			get_node("rootContainer/Map/WW").set_pressed(true)
	pass

func handleGetSurroundingsDone(surroundings : Dictionary):
	for key in surroundings:
		get_node("./rootContainer/Map/"+key).updateByDict(surroundings[key])
	pass

func handleGetConfigDone(turnTime : int, haveWon : bool):
	self.gameTimer = turnTime
	self.gameOver = !haveWon
	pass

func _moveInput(inputString : String):
	print("Input sent with '"+inputString+"'")
	gApi.putDirection(inputString)
	pass

func _cardInput(cardType : String):
	print("Consume sent with "+cardType)
	gApi.putConsume(cardType)
	pass

func _ready():
	#Setup
	register_player("Player")
	tileArray = get_node("rootContainer/Map").get_children()
	for i in range(len(tileArray)):
		tileArray[i].setId(inputStringArray[i])
		tileArray[i].moveInput.connect(_moveInput)
	cardArray = get_node("rootContainer/Cards").get_children()
	for i in range(len(cardArray)):
		cardArray[i].cardInput.connect(_cardInput)
	
	#Wire up API signals
	gApi.getPlayerDone.connect(handleGetPlayerDone)
	gApi.getSurroundingsDone.connect(handleGetSurroundingsDone)
	gApi.getConfigDone.connect(handleGetConfigDone)
	
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

func query_config():
	gApi.getConfig()
	pass

func query_player():
	gApi.getPlayer()
	pass

func query_surroundings():
	gApi.getSurroundings()
	pass

func register_player(name : String):
	gApi.postPlayer(name)
	pass
