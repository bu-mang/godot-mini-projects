extends CharacterBody2D

#  @export를 통해 인스펙터에서 패러미터 조절을 할 수 있게 된다.
@export var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position = Vector2(-10, 200)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#	Input.get_vector는 이미 normalize(정규화)된 녀석을 반환한다.
	var vector_direction = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	# velocity: 캐릭터 바디 내장 변수
	velocity = vector_direction * speed
	move_and_slide()
	
	
	# Vector2.ZERO: (0, 0) 벡터를 의미하는 상수	
	#var direction = Vector2.ZERO

	#if Input.is_action_pressed("move_left"):
		#direction.x -= 1
	#if Input.is_action_pressed("move_right"):
		#direction.x += 1
	#if Input.is_action_pressed("move_up"):
		#direction.y -= 1
	#if Input.is_action_pressed("move_down"):
		#direction.y += 1

	# 방향을 정규화해서 대각선 이동 속도 보정
	#if direction != Vector2.ZERO:
		# 대각선으로 이동하면 (1,1)이 되기 때문에 길이가 √2 ≈ 1.41이 됨
		# → 대각선이 더 빠르게 이동하는 부작용 발생.
		#direction = direction.normalized() 
		
	#print(direction)
	
	#position += direction * speed * delta
	
	# 초당 speed만큼 움직이기
