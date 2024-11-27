extends Node

@export var serverURL : String = "http://localhost"
@export var serverPort : int = 8080
@export var playerName : String = "player"

var srv = serverURL + ":" + str(serverPort)
var playerId : String = ""

signal getPlayerDone(alive : bool, cards : Array, direction : String)
signal getSurroundingsDone(surroundingsDict : Dictionary)
signal getConfigDone(turnTime : int, haveWon : bool)

enum call {
	POST_PLAYER,
	GET_PLAYER,
	GET_SURROUNDINGS,
	PUT_PLAYER_DIRECTION,
	PUT_PLAYER_CONSUME,
	PUT_PLAYER_DISCARD,
	PUT_PLAYER_PLAY,
	GET_CONFIG
}

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

func postPlayer(name : String):
	_web_request(call.POST_PLAYER, playerName)
	pass

func getPlayer():
	_web_request(call.GET_PLAYER, "")
	pass

func getSurroundings():
	_web_request(call.GET_SURROUNDINGS, "")
	pass

func putDirection(dir : String):
	_web_request(call.PUT_PLAYER_DIRECTION, dir)
	pass

func putConsume(consume : String):
	_web_request(call.PUT_PLAYER_CONSUME, consume)
	pass

func putDiscard(disc : String):
	_web_request(call.PUT_PLAYER_DISCARD, disc)
	pass

func putPlay(play : String):
	_web_request(call.PUT_PLAYER_PLAY, play)
	pass

func _jsonToDict(response_code, body):
	if response_code != 200:
		return ""
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	return json.get_data()
	
func _postPlayerCompleted(result, response_code, headers, body, instance : HTTPRequest):
	var response = _jsonToDict(response_code, body)
	pass

func _getPlayerCompleted(result, response_code, headers, body, instance : HTTPRequest):
	var response = _jsonToDict(response_code, body)
	getPlayerDone.emit(response["Alive"], response["Cards"], response["Direction"])
	pass

func _getPlayerSurroundingsCompleted(result, response_code, headers, body, instance : HTTPRequest):
	var response = _jsonToDict(response_code, body)
	getSurroundingsDone.emit(response)
	pass

func _putPlayerDirectionCompleted(result, response_code, headers, body, instance : HTTPRequest):
	pass

func _putPlayerConsumeCompleted(result, response_code, headers, body, instance : HTTPRequest):
	pass

func _putPlayerDiscardCompleted(result, response_code, headers, body, instance : HTTPRequest):
	pass

func _putPlayerPlayCompleted(result, response_code, headers, body, instance : HTTPRequest):
	pass

func _getConfigCompleted(result, response_code, headers, body, instance : HTTPRequest):
	var response = _jsonToDict(response_code, body)
	getConfigDone.emit(response["TurnTime"], response["HaveWon"])
	pass

func _web_request(action : call, arg : String):
	
	var srvPlayerPrefix = srv+"/player/"+playerId
	var web = HTTPRequest.new()
	add_child(web)
	
	match call:
		call.POST_PLAYER:
			web.request_completed.connect(self._postPlayerCompleted.bind(web))
			web.request(srv+"/player/"+arg, [], HTTPClient.METHOD_POST, "")
		call.GET_PLAYER:
			web.request_completed.connect(self._getPlayerCompleted.bind(web))
			web.request(srvPlayerPrefix, [], HTTPClient.METHOD_GET, "")
		call.GET_SURROUNDINGS:
			web.request_completed.connect(self._getPlayerSurroundingsCompleted.bind(web))
			web.request(srvPlayerPrefix+"/surroundings/"+arg, [], HTTPClient.METHOD_GET, "")
		call.PUT_PLAYER_DIRECTION:
			web.request_completed.connect(self._putPlayerDirectionCompleted.bind(web))
			web.request(srvPlayerPrefix+"/direction/"+arg, [], HTTPClient.METHOD_PUT, "")
		call.PUT_PLAYER_CONSUME:
			web.request_completed.connect(self._putPlayerConsumeCompleted.bind(web))
			web.request(srvPlayerPrefix+"/consume/"+arg, [], HTTPClient.METHOD_PUT, "")
		call.PUT_PLAYER_DISCARD:
			web.request_completed.connect(self._putPlayerDiscardCompleted.bind(web))
			web.request(srvPlayerPrefix+"/discard/"+arg, [], HTTPClient.METHOD_PUT, "")
		call.PUT_PLAYER_PLAY:
			web.request_completed.connect(self._putPlayerPlayCompleted.bind(web))
			web.request(srvPlayerPrefix+"/play/"+arg, [], HTTPClient.METHOD_PUT, "")
		call.GET_CONFIG:
			web.request_completed.connect(self.getConfigCompleted.bind(web))
			web.request(srv+"/config", [], HTTPClient.METHOD_GET, "")
	
	web.queue_free()
	pass

func _ready() -> void:
	pass
