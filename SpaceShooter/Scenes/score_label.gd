# ScoreLabel.gd
extends Label

func _ready() -> void:
	# 초기 스코어 반영
	text = "Fuel: " + str(GameState.fuel)

	# 스코어 바뀔 때마다 텍스트 갱신
	GameState.fuel_changed.connect(_on_fuel_changed)

func _on_fuel_changed(fuel_amount: int) -> void:
	text = "Fuel: " + str(fuel_amount)
