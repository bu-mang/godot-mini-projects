extends Area2D

var speed = GameState._laser_speed
var angle_degrees: float = 0.0  # 발사 각도 (도 단위)

func _ready() -> void:
	# GameState의 laser_scale 값 가져오기 (1.0 ~ 1.8)
	var laser_scale = GameState.laser_scale

	# 기본 크기에 scale 적용 (세로는 조금 둔하게)
	var y_scale = (laser_scale - 0.1) if laser_scale == 1.0 else laser_scale * 0.9
	var final_scale = Vector2(4 * laser_scale, 32 * y_scale)

	var tween = create_tween()
	tween.tween_property($Laser, 'scale', final_scale, 0.05).from(Vector2(0,0))

	# 충돌 범위도 scale에 맞게 조정
	scale = Vector2(laser_scale, laser_scale)

	# 레이저 스프라이트를 각도만큼 회전
	rotation_degrees = angle_degrees

func _process(delta: float) -> void:
	# 각도에 따라 이동 방향 계산
	var direction = Vector2(0, -1).rotated(deg_to_rad(angle_degrees))
	position += direction * speed * delta
