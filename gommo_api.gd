extends Node

@export var serverURL : String = "http://localhost"
@export var serverPort : int = 8080

enum call {
	POST_PLAYER,
	GET_PLAYER,
	GET_PLAYER_SURROUNDINGS,
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

func _web_request(action : call, instance : HTTPRequest):
	var web = HTTPRequest.new()
	add_child(web)
	
	match call:
		POST_PLAYER:
			web.request_completed.connect(self._http_request_completed.bind(web))
		GET_PLAYER:
		GET_PLAYER_SURROUNDINGS:
		PUT_PLAYER_DIRECTION:
		PUT_PLAYER_CONSUME:
		PUT_PLAYER_DISCARD:
		PUT_PLAYER_PLAY:
		GET_CONFIG:
	
	instance.queue_free()
	
	getPlayer.request_completed.connect(self._postPlayerCompleted)
	getPlayer.request_completed.connect(self._getPlayerCompleted)
	getPlayerSurroundings.request_completed.connect(self._getPlayerSurroundingsCompleted)
	putPlayerDirection.request_completed.connect(self._putPlayerDirectionCompleted)
	putPlayerConsume.request_completed.connect(self._putPlayerConsumeCompleted)
	putPlayerDiscard.request_completed.connect(self._putPlayerDiscardCompleted)
	putPlayerPlay.request_completed.connect(self._putPlayerPlayCompleted)
	getConfig.request_completed.connect(self._getConfigCompleted)
		
	web.request(serverURL+":"+str(serverPort)+endpoint, [], method, body)
	pass

func _ready() -> void:
	
	
	pass