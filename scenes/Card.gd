extends TextureButton

@export var cardType : String

@onready var FoodTexture = get_node("FoodTexture").texture
@onready var WeaponTexture = get_node("WeaponTexture").texture
@onready var WoodTexture = get_node("WoodTexture").texture
@onready var CureTexture = get_node("CureTexture").texture

signal cardInput(cardType : String)

func updateType(inputType : String):
	self.cardType = inputType
	print("Updating card with ", self.cardType)
	match self.cardType:
		"Food":
			self.texture_normal = FoodTexture
		"Wood":
			self.texture_normal = WoodTexture
		"Weapon":
			self.texture_normal = WeaponTexture
		"Cure":
			self.texture_normal = CureTexture
		"None":
			self.texture_normal = null
		_:
			self.texture_normal = null

func _on_click():
	emit_signal("cardInput", self.cardType)
	pass

func _ready():
	self.button_up.connect(_on_click)
	
	updateType("Wood")
	
	self.cardType = "None"
	
	pass
