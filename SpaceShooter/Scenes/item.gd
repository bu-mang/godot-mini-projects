extends CharacterBody2D

var rng = RandomNumberGenerator.new()
var index: int
var item_sprites: Array[Sprite2D]

var speed = 300
var direction: Vector2

func _ready() -> void:
	item_sprites = [$big_shot, $fast_shot, $add_shot, $wide_shot]

	for item in item_sprites:
		item.visible = false

	var max_index = 2 if GameState.is_wide_shot else 3
	index = rng.randi_range(0, max_index)
	item_sprites[index].visible = true

	# 랜덤한 초기 방향 설정
	direction = Vector2(
		rng.randf_range(-1, 1),
		rng.randf_range(-1, 1)
	).normalized()

	# PlayerDetector Area2D로 Player 감지
	$PlayerDetector.body_entered.connect(_on_player_detected)

	# 5초 후 자동 삭제 타이머
	var lifetime_timer = Timer.new()
	lifetime_timer.wait_time = 5.0
	lifetime_timer.one_shot = true
	lifetime_timer.autostart = true
	lifetime_timer.timeout.connect(_on_lifetime_timeout)
	add_child(lifetime_timer)

	# 3초 후 점멸 시작 타이머 (수명 5초 - 점멸 2초 = 3초)
	var blink_start_timer = Timer.new()
	blink_start_timer.wait_time = 3.0
	blink_start_timer.one_shot = true
	blink_start_timer.autostart = true
	blink_start_timer.timeout.connect(_on_blink_start)
	add_child(blink_start_timer)


func _physics_process(delta: float) -> void:
	if GameState.game_over:
		return

	velocity = direction * speed
	var collision = move_and_collide(velocity * delta)

	# 벽과의 충돌 처리 (물리)
	if collision:
		var collider = collision.get_collider()
		# 벽(StaticBody2D)에 부딪히면 튕김
		if collider is StaticBody2D:
			direction = direction.bounce(collision.get_normal())

# Player 감지 (Area2D)
func _on_player_detected(body: Node2D) -> void:
	if body.name == "Player":
		item_sprites[index].visible = false
		make_player_power_up()
		queue_free()
	

func make_player_power_up():
	match index:
		0:  # big_shot
			GameState.upgrade_laser_scale()
		1:  # fast_shot
			GameState.add_laser_speed(200)
			GameState.decrease_laser_spawn_time(0.1)
		2:  # add_shot
			GameState.add_laser_count(1)
		3:  # wide_shot
			GameState.activate_wide_shot()

func _on_lifetime_timeout() -> void:
	queue_free()

func _on_blink_start() -> void:
	# 0.2초 간격으로 깜빡이는 타이머 (빠른 점멸)
	var blink_timer = Timer.new()
	blink_timer.wait_time = 0.2
	blink_timer.autostart = true
	blink_timer.timeout.connect(_on_blink_tick)
	add_child(blink_timer)

func _on_blink_tick() -> void:
	# 현재 보이는 아이템 스프라이트를 토글
	item_sprites[index].visible = !item_sprites[index].visible
