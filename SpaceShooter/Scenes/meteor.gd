extends Area2D

var min_speed := 100
var max_speed := 300
var speed := 0

var rotate_speed := 0
var direction_x: float = 0

var rng:= RandomNumberGenerator.new()

var meteorImages: Array[Sprite2D]
var meteorFlashes: Array[AnimatedSprite2D]
var is_cracked := false

var index: int

var item_scene := load("res://Scenes/item.tscn")

func _ready():
	GameState.level_changed.connect(_on_level_changed)
	
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

# 우주선과 부딫힌 경우 (게임오버)
func _on_body_entered(_body: Node2D) -> void:
	if !is_cracked:
		GameState.game_over = true
		play_flash_animation(false)
		
	
# 레이저가 부딫힌 경우
func _on_area_entered(area: Area2D) -> void:
	# 충돌한 레이저 삭제
	area.queue_free()

	# 이미 깨진 경우 아무것도 하지 않음 (중요: 먼저 체크!)
	if is_cracked:
		return

	# 즉시 깨진 상태로 설정 (동시성 문제 방지)
	is_cracked = true

	# 레벨이 오를수록 드랍 확률 감소
	var drop_chance = rng.randf()  # 0.0 ~ 1.0 사이의 난수
	var drop_rate: float
	if GameState.level <= 5:
		drop_rate = 0.3  # 레벨 1~5: 30% 고정
	else:
		# 레벨 6부터: 30% → 5% 점진적 감소 (최소 5%)
		drop_rate = max(0.05, 0.3 * (1 - (GameState.level - 5) * 0.05))

	if drop_chance < drop_rate:
		var item = item_scene.instantiate()
		item.global_position = global_position
		get_tree().root.get_node("Level/Items").add_child(item)

	# 애니메이션 재생
	play_flash_animation(true)




func play_flash_animation(eliminate: bool):
	for img in meteorImages:
		img.visible = false

	# 어떤 meteor가 보였는지 체크 → 그에 맞는 flash 재생
	var flash: AnimatedSprite2D = null
	if index == 0:
		flash = meteorFlashes[0]
	else:
		flash = meteorFlashes[1]

	flash.visible = true
	
	# 애니메이션 끝날 때 메테오 삭제
	if eliminate:
		flash.play("hit_once") # 1회 재생용
		flash.animation_finished.connect(_on_flash_finished, CONNECT_ONE_SHOT)
		
	else:
		flash.play("hit_loop") # 무한 루프용
		
func _on_flash_finished():
	queue_free()

func _on_level_changed(new_level: int) -> void:
	# 레벨이 오를수록 속도 증가폭이 커짐
	var speed_increase = 300 + (new_level * 100)  # 레벨 1: +400, 레벨 2: +500, 레벨 3: +600...
	min_speed += speed_increase
	max_speed += speed_increase
