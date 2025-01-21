extends Node2D

@onready var button = $Button

# Called when the node enters the scene tree for the first time.
func _ready():
	$ForestSprite.visible = true
	$FarmSprite.visible = false
	$CitySprite.visible = false
	$LabSprite.visible = false
	$EdgeSprite.visible = false
	$Selected.visible = false
	$ZombieCounter.text = "Zombies: 0"
	pass # Replace with function body.

func deselect():
	$Selected.visible = false
	pass

func input():
	$"../".clearSelected()
	$Selected.visible = true
	$"../../".input_direction(self)
	pass

func setTerrain(terrain : int, zombies : int):
	$ForestSprite.visible = false
	$FarmSprite.visible = false
	$CitySprite.visible = false
	$LabSprite.visible = false
	$EdgeSprite.visible = false
	$ZombieCounter.text = "Zombies: %d".format(zombies)
	match (terrain):
		0:
			$ForestSprite.visible = true
		1:
			$FarmSprite.visible = true
		2:
			$CitySprite.visible = true
		3:
			$LabSprite.visible = true
		4:
			$EdgeSprite.visible = true
		_:
			$EdgeSprite.visible = true
			#TODO: Do something useful here
	pass

func setInputSize(size : int):
	$Button.size = Vector2(size, size)
