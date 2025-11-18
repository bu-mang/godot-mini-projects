extends Node2D

var rng:= RandomNumberGenerator.new()

func _ready():
	print("spawn")
	rng.randomize()
	
	# ------ Randomize Position ------
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(0, height)
	position = Vector2(random_x, random_y)

func _process(delta):
	print(delta, "delta")
	pass

func _on_body_entered(body: Node2D) -> void:
	print('Coin Entered')
	print(body)
