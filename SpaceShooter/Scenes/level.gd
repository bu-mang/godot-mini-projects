extends Node2D

func _on_timer_timeout() -> void:
	print("timeout")

# 1. load the scene
var meteor_scene: PackedScene = load("res://Scenes/meteor.tscn")
var laser_scene: PackedScene = load("res://Scenes/laser.tscn")
var coin_scene: PackedScene = load("res://Scenes/coin.tscn")

func _on_meteor_spawn_timer_timeout() -> void:
	print("_on_meteor_spawn_timer_timeout")
	# 2. create an instance
	var meteor = meteor_scene.instantiate()
	# 3. attach the node to the scene tree
	$Meteors.add_child(meteor)

func _on_player_laser(pos: Vector2) -> void:
	# 2. create an instance
	var laser = laser_scene.instantiate()
	# 3. attach the node to the scene tree
	$Lasers.add_child(laser)
	
	var laserCoord = pos - Vector2()
	laser.position = laserCoord

func _on_coin_spawn_timer_timeout() -> void:
	print("_on_coin_spawn_timer_timeout")
	# 2. create an instance
	var coin = coin_scene.instantiate()
	# 3. attach the node to the scene tree
	$Coins.add_child(coin)
