extends Node2D

func _on_timer_timeout() -> void:
	print("timeout")

# 1. load the scene
var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var laser_scene: PackedScene = load("res://Scenes/laser.tscn")
var fuel_scene: PackedScene = load("res://Scenes/fuel.tscn")
var bg_star = load("res://Assets/bg-star.png")

const MAX_FUEL = 8

const MIN_FUEL_DISTANCE := 150.0  # 다른 fuel과 이 거리 이상 떨어지게
const MAX_REPOSITION_TRIES := 10 # 너무 많이 도는 것 방지용

func _ready() -> void:
	var stars_node = $BG/Stars
	var rng = RandomNumberGenerator.new()
	var viewport_size = get_viewport().get_visible_rect().size
	
	for i in range(20):
		# 1. 스프라이트 불러오기 + 텍스쳐 설정
		var star := Sprite2D.new()
		star.texture = bg_star
		
		# 2. 스케일/투명도 설정
		var randomScale = rng.randf_range(0.05, 0.08)
		star.scale = Vector2(randomScale, randomScale)
		
		star.modulate.a = 0.5
		
		star.position = Util.random_non_overlapping_position(
			viewport_size,
			stars_node.get_children(),
			MIN_FUEL_DISTANCE,
			MAX_REPOSITION_TRIES
		)
		
		# 4. 배경에 추가
		stars_node.add_child(star)

# 메테오 리스폰 시
func _on_meteor_spawn_timer_timeout() -> void:
	if GameState.game_over == true:
		return
	  
	# 2. create an instance
	var meteor = meteor_scene.instantiate()
	# 3. attach the node to the scene tree
	$Meteors.add_child(meteor)

# 레이저 발사 시
func _on_player_laser(pos: Vector2) -> void:
	if GameState.game_over == true:
		return

	# GameState.laser_count에 따라 레이저 여러 개 생성 (최대 5개)
	var laser_count = min(5, GameState.laser_count)
	var spacing = 40  # 레이저 간 간격

	# 레이저가 중앙을 기준으로 좌우 대칭되게 배치
	var start_offset = -(laser_count - 1) * spacing / 2.0

	for i in range(laser_count):
		var laser = laser_scene.instantiate()
		$Lasers.add_child(laser)

		# x 좌표를 간격만큼 떨어뜨려 배치
		var offset_x = start_offset + (i * spacing)
		laser.position = pos + Vector2(offset_x, 0)

# 동전 리스폰 시
func _on_fuel_spawn_timer_timeout() -> void:
	var length = $Fuels.get_children().size()
	
	if GameState.game_over == true || length >= MAX_FUEL:
		return
		
	# 2. create an instance
	var fuel = fuel_scene.instantiate()
	# 3. attach the node to the scene tree
	$Fuels.add_child(fuel)
