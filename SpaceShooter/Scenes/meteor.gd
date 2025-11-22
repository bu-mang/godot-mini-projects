extends Area2D

var min_speed := 300
var max_speed := 500
var speed := 0

var rotate_speed := 0
var direction_x: float = 0

var rng:= RandomNumberGenerator.new()

var meteorImages: Array[Sprite2D]
var meteorFlashes: Array[AnimatedSprite2D]
var is_cracked := false

var index: int

func _ready():
	rng.randomize()
	$GrayMeteor.visible = false
	$RedMeteor.visible = false
	$Grayflash.visible = false
	$Redflash.visible = false
	
	meteorImages = [$GrayMeteor, $RedMeteor]
	meteorFlashes = [$Grayflash, $Redflash]
	
	# ------ Randomize Position ------
	# get_viewport().get_visible_rect() -> [1280, 720]
	var width = get_viewport().get_visible_rect().size[0]
	var random_x = rng.randi_range(100, width - 100)
	var random_y = rng.randi_range(-150, -50)
	position = Vector2(random_x, random_y)
	
	# ------ Randomize Rotate ------
	var random_rotation = rng.randi_range(0, 360)
	rotation_degrees = random_rotation
	rotate_speed = rng.randi_range(5, 100)
	
	# ------ Direction X ------
	if position.x < 100:
		direction_x = rng.randf_range(0.1, 1.0)
	elif position.x > width - 100:
		direction_x = rng.randf_range(-1.0, -0.1)
	else:
		direction_x = rng.randf_range(-0.5, 0.5)
	
	# ------ Randomize Speed ------
	speed = rng.randi_range(min_speed, max_speed)
	
	# ------ Randomize Asset Image ------
	index = rng.randi_range(0, meteorImages.size() - 1)
	meteorImages[index].visible = true

func _process(delta):
	if !is_cracked && GameState.game_over == false:
		position += Vector2(direction_x, 1.0) * speed * delta
		rotation_degrees += rotate_speed * delta

func _on_body_entered(body: Node2D) -> void:
	if !is_cracked:
		print('body entered', body)
		GameState.game_over = true
	
func _on_area_entered(area: Area2D) -> void:
	# 충돌한 레이저 삭제
	area.queue_free()

	is_cracked = true

	# Meteor 본체 숨기기
	for img in meteorImages:
		img.visible = false

	# 어떤 meteor가 보였는지 체크 → 그에 맞는 flash 재생
	var flash: AnimatedSprite2D = null
	if index == 0:
		flash = meteorFlashes[0]
	else:
		flash = meteorFlashes[1]

	flash.visible = true
	flash.play("default")  # 애니메이션 재생

	# 애니메이션 끝날 때 메테오 삭제
	flash.animation_finished.connect(_on_flash_finished)
	
func _on_flash_finished():
	queue_free()
	
