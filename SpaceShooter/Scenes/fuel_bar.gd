extends ProgressBar

var tween: Tween
var previous_value: float = 100.0

func _ready() -> void:
	# ProgressBar 초기 설정
	min_value = 0
	max_value = 100
	value = GameState.fuel
	previous_value = GameState.fuel
	show_percentage = false

	# Fuel 변경 시그널 연결
	GameState.fuel_changed.connect(_on_fuel_changed)

func _on_fuel_changed(fuel_amount: int) -> void:
	# 기존 Tween이 있으면 중지
	if tween:
		tween.kill()

	# fuel이 증가하면 즉시 변경, 감소하면 애니메이션
	if fuel_amount > previous_value:
		# 증가: 즉시 변경
		value = fuel_amount
	else:
		# 감소: 부드럽게 변경
		tween = create_tween()
		tween.tween_property(self, "value", fuel_amount, 0.3)

	previous_value = fuel_amount
