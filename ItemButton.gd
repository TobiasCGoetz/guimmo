extends Button

func _ready():
	connect("pressed", Callable(self, "_button_pressed"))
	pass

func _button_pressed():
	$"../".input()
	pass

