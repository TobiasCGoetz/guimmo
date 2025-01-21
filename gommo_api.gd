extends Node

@export var serverURL : String = "http://localhost"
@export var serverPort : int = 8080

#POST("/player/:name")
#GET("/player/{id}")
#GET("/player/{id}/surroundings")
#PUT("/player/{id}/direction/{dir}")
#PUT("/player/{id}/consume/{card}")
#PUT("/player/{id}/discard/{card}")
#PUT("/player/{id}/play/{card}")
#GET("/config/turnTimer")
#GET("/config/turnLength")
#GET("/config/mapSize")
#GET("/config/hasWon")
#GET("/config")

var postPlayer : HTTPRequest
var getPlayer : HTTPRequest
var getPlayerSurroundings : HTTPRequest
var putPlayerDirection : HTTPRequest
var putPlayerConsume : HTTPRequest
var putPlayerDiscard : HTTPRequest
var putPlayerPlay : HTTPRequest
var getConfig : HTTPRequest

func _postPlayerCompleted(result, response_code, headers, body):
	pass

func _getPlayerCompleted(result, response_code, headers, body):
	pass

func _getPlayerSurroundingsCompleted(result, response_code, headers, body):
	pass

func _putPlayerDirectionCompleted(result, response_code, headers, body):
	pass

func _putPlayerConsumeCompleted(result, response_code, headers, body):
	pass

func _putPlayerDiscardCompleted(result, response_code, headers, body):
	pass

func _putPlayerPlayCompleted(result, response_code, headers, body):
	pass

func _getConfigCompleted(result, response_code, headers, body):
	pass

func _ready() -> void:
	postPlayer = HTTPRequest.new()
	getPlayer = HTTPRequest.new()
	getPlayerSurroundings = HTTPRequest.new()
	putPlayerDirection = HTTPRequest.new()
	putPlayerConsume = HTTPRequest.new()
	putPlayerDiscard = HTTPRequest.new()
	putPlayerPlay = HTTPRequest.new()
	getConfig = HTTPRequest.new()
	
	getPlayer.request_completed.connect(self._postPlayerCompleted)
	getPlayer.request_completed.connect(self._getPlayerCompleted)
	getPlayerSurroundings.request_completed.connect(self._getPlayerSurroundingsCompleted)
	putPlayerDirection.request_completed.connect(self._putPlayerDirectionCompleted)
	putPlayerConsume.request_completed.connect(self._putPlayerConsumeCompleted)
	putPlayerDiscard.request_completed.connect(self._putPlayerDiscardCompleted)
	putPlayerPlay.request_completed.connect(self._putPlayerPlayCompleted)
	getConfig.request_completed.connect(self._getConfigCompleted)
	pass
