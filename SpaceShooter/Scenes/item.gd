extends Area2D

var rng = RandomNumberGenerator.new()
var index: int
var item_sprites: Array[Sprite2D]

func _ready() -> void:
	item_sprites = [$big_shot, $wide_shot, $add_shot, $fast_shot]
	
	for item in item_sprites:
		item.visible = false
	
	index = rng.randi_range(0, 3)
	item_sprites[index].visible = true
	
	body_entered.connect(on_item_body_entered)

func on_item_body_entered(_body: Node2D) -> void:
	item_sprites[index].visible = false
	

func make_player_power_up():
	pass
	#GameState.laser_speed
	#GameState.laser_spread_type
	#GameState.laser_spawn_time
	#GameState.laser_count
