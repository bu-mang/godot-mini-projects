# ScoreLabel.gd
extends Label

func _ready() -> void:
	# 초기 스코어 반영
	text = "Coin: " + str(GameState.coin)

	# 스코어 바뀔 때마다 텍스트 갱신
	GameState.coin_changed.connect(_on_coin_changed)

func _on_coin_changed(new_coin: int) -> void:
	text = "Coin: " + str(new_coin)
