extends Node2D

var rng:= RandomNumberGenerator.new()

var is_executed := false
var scoring_animation := load("res://Scenes/scoringAnimation.tscn")

func _ready():
	print("spawn")
	rng.randomize()
	
	# ------ Randomize Position ------
	var width = get_viewport().get_visible_rect().size[0]
	var height = get_viewport().get_visible_rect().size[1]
	var random_x = rng.randi_range(0, width)
	var random_y = rng.randi_range(0, height)
	position = Vector2(random_x, random_y)
	
	# 사실 상 yield다.
	await get_tree().create_timer(5.0).timeout

	# 1초간 투명도 0으로 줄이기 (페이드아웃)
	var tween := create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.3) # 1초 동안 a(투명도)를 0으로
	
	# 애니메이션 끝날 때까지 정확히 대기
	await tween.finished  
	
	# 제거
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if (!is_executed):
		is_executed = true
		GameState.add_coin(10)
		$Coin.modulate.a = 0
		
		var score_anim = scoring_animation.instantiate()
		score_anim.position = position
		score_anim.scale = Vector2(2,2)
		
		get_parent().add_child(score_anim)
		
		print("scored up by ...", body)
	
