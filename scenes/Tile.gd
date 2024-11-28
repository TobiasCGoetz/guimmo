extends TextureButton

@export var playersPlanMoveNorth : int
@export var playersPlanMoveEast : int
@export var playersPlanMoveSouth : int
@export var playersPlanMoveWest : int

@export var zombieCount : int
@export var playerCount : int

@export var tileType : String

var tileId : String
@onready var ForestTexture = get_node("ForestTexture").texture
@onready var FarmTexture = get_node("FarmTexture").texture
@onready var CityTexture = get_node("CityTexture").texture
@onready var MountainTexture = get_node("MountainTexture").texture
@onready var LaboratoryTexture = get_node("LaboratoryTexture").texture
@onready var EDGETexture = get_node("EDGETexture").texture

signal moveInput(buttonId : String)

func updateByDict(newState : Dictionary):
	#Copy data
	#Planning data
	self.playersPlanMoveNorth = newState["PlayersPlanMoveNorth"]
	self.playersPlanMoveEast = newState["PlayersPlanMoveEast"]
	self.playersPlanMoveSouth = newState["PlayersPlanMoveSouth"]
	self.playersPlanMoveWest = newState["PlayersPlanMoveWest"]
	#Tile data
	self.zombieCount = newState["ZombieCount"]
	self.playerCount = newState["PlayerCount"]
	#Tile type
	self.tileType = newState["TileType"]
	updatePlayerPlans()
	updateTileData()
	pass

func updateTileData():
	updateData()
	updatePlayerPlans()
	updateTerrain()
	pass

func updateData():
	get_node("./zombieIcon/zombieCount").text = str(self.zombieCount)
	get_node("./playerIcon/playerCount").text = str(self.playerCount)
	if (self.zombieCount > 0):
		get_node("./zombieIcon").show()
	else:
		get_node("zombieIcon").hide()
	if (self.playerCount > 0):
		get_node("playerIcon").show()
	else:
		get_node("playerIcon").hide()
	pass

func updatePlayerPlans():
	get_node("./NorthArrow/NorthText").text = str(self.playersPlanMoveNorth)
	get_node("./EastArrow/EastText").text = str(self.playersPlanMoveEast)
	get_node("./SouthArrow/SouthText").text = str(self.playersPlanMoveSouth)
	get_node("./WestArrow/WestText").text = str(self.playersPlanMoveWest)
	pass

func updateTerrain():
	match self.tileType:
		"Forest":
			self.texture_normal = ForestTexture
		"City":
			self.texture_normal = CityTexture
		"Farm":
			self.texture_normal = FarmTexture
		"Laboratory":
			self.texture_normal = LaboratoryTexture
		"Mountain":
			self.texture_normal = MountainTexture
		"EDGE":
			self.texture_normal = EDGETexture
		_:
			self.texture_normal = EDGETexture
	pass

func getId():
	return self.tileId

func setId(newId : String):
	self.tileId = newId
	pass

func _on_move():
	emit_signal("moveInput", self.tileId)
	pass

func _ready():
	self.button_up.connect(_on_move)
	
	self.playerCount = 0
	self.zombieCount = 0
	self.tileType = "EDGE"
	self.playersPlanMoveNorth = 0
	self.playersPlanMoveEast = 0
	self.playersPlanMoveSouth = 0
	self.playersPlanMoveWest = 0
	
	updatePlayerPlans()
	updateTerrain()
	updateData()
	pass
