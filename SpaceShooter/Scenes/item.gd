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
