extends CharacterBody2D

#  @export를 통해 인스펙터에서 패러미터 조절을 할 수 있게 된다.
@export var speed = 500

signal laser(pos: Vector2)

var can_shoot := true

func _ready() -> void:
	# $...은 노드 트리 로딩이 끝난 후에만 접근 가능하기 때문에 전역스코프에선 사용 불가
	var size = get_viewport().get_visible_rect().size
	var widthCoord = size[0] / 2
	var heightCoord = size[1] - 100
	position = Vector2(widthCoord, heightCoord)
	z_index = 1

func _process(_delta) -> void:
	#	Input.get_vector는 이미 normalize(정규화)된 녀석을 반환한다.
	var vector_direction = Input.get_vector('move_left', 'move_right', 'move_up', 'move_down')
	# velocity: 캐릭터 바디 내장 변수
	velocity = vector_direction * speed
	move_and_slide()
	
	# just_pressed는 holding해도 처음 트리거 된 한 번만 발생하고
	# pressed는 홀딩 시 계속 이벤트가 발생한다 (per frame)
	if Input.is_action_just_pressed("shoot") and can_shoot:
		can_shoot = false  # 쿨타임 시작
		laser.emit($LaserStartPosition.global_position)
		$LaserCoolDownTimer.start()  # 0.5초 쿨타임 타이머

func _on_laser_cool_down_timer_timeout() -> void:
	print("coolDown")
	can_shoot = true
