extends Node2D

func _on_timer_timeout() -> void:
	print("timeout")

# 1. load the scene
var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var laser_scene: PackedScene = load("res://Scenes/laser.tscn")
var coin_scene: PackedScene = load("res://Scenes/coin.tscn")
var bg_star = load("res://Assets/bg-star.png")

func _ready() -> void:
	var stars_node = $BG/Stars
	
	var rng = RandomNumberGenerator.new()
	
	var screen_size = get_viewport().get_visible_rect().size
	var screen_width = screen_size[0]
	var screen_height = screen_size[1]
	
	for i in range(20):
		# 1. 스프라이트 불러오기 + 텍스쳐 설정
		var star := Sprite2D.new()
		star.texture = bg_star
		
		# 2. 스케일/투명도 설정
		var randomScale = rng.randf_range(0.05, 0.08)
		star.scale = Vector2(randomScale, randomScale)
		
		star.modulate.a = 0.5
		
		# 3. 좌표 설정
		var star_x = rng.randf_range(0, screen_width)
		var star_y = rng.randi_range(0, screen_height)
		star.position = Vector2(star_x, star_y)
		
		# 4. 배경에 추가
		stars_node.add_child(star)

# 플레이 시간 측정
func _process(delta: float) -> void:
	if not GameState.game_over:
		GameState.elapsed_time += delta

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
	
	# 2. create an instance
	var laser = laser_scene.instantiate()
	# 3. attach the node to the scene tree
	$Lasers.add_child(laser)
	
	var laserCoord = pos - Vector2()
	laser.position = laserCoord

# 동전 리스폰 시
func _on_coin_spawn_timer_timeout() -> void:
	if GameState.game_over == true:
		return
		
	# 2. create an instance
	var coin = coin_scene.instantiate()
	# 3. attach the node to the scene tree
	$Coins.add_child(coin)
