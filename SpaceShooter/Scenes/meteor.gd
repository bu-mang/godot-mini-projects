extends Area2D

var is_collided := false

var min_speed := 100
var max_speed := 500
var speed := 0

var rotate_speed := 0
var direction_x: float = 0

var rng:= RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	$GrayMeteor.visible = false
	$RedMeteor.visible = false
	var meteorImages: Array[Sprite2D] = [$GrayMeteor, $RedMeteor]
	
	
	# ------ Randomize Position ------
	# get_viewport().get_visible_rect() -> [1280, 720]
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	# ------ Randomize Rotate ------
	var random_rotation = rng.randi_range(0, 360)
	rotation_degrees = random_rotation
	rotate_speed = rng.randi_range(5, 100)
	
	# ------ Direction X ------
	direction_x = rng.randf_range(-1, 1)
	
	# ------ Randomize Speed ------
	speed = rng.randi_range(min_speed, max_speed)
	
	# ------ Randomize Asset Image ------
	var index = rng.randi_range(0, meteorImages.size() - 1)
	meteorImages[index].visible = true

func _process(delta):
	if is_collided == false:
		position += Vector2(direction_x, 1.0) * speed * delta
		rotation_degrees += rotate_speed * delta

func _on_body_entered(body: Node2D) -> void:
	print('body entered')
	print(body)
