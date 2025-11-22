extends Node

# 게임오버 상태
signal is_game_over_changed(game_over: bool)
var game_over: bool = false:
	set(value):
		game_over = value
		is_game_over_changed.emit(game_over)
	get:
		return game_over

# 스코어
signal coin_changed(new_coin: int)
var coin: int = 0:
	set(value):
		coin = value
		coin_changed.emit(coin)
	get:
		return coin

func add_coin(amount: int) -> void:
	coin += amount

func reset_coin() -> void:
	coin = 0



# 체력
signal hp_changed(new_score: int)
var hp: int = 100:
	set(value):
		hp = value
		hp_changed.emit(hp)
	get:
		return hp

func add_hp(amount: int) -> void:
	hp += amount

func reset_hp() -> void:
	hp = 0



# 공격 옵션(레이저 갯수)
signal laser_count_changed(new_score: int)
var laser_count: int = 1:
	set(value):
		laser_count = value
		laser_count_changed.emit(laser_count)
	get:
		return laser_count

func add_laser_count(amount: int) -> void:
	laser_count += amount

func reset_laser_count() -> void:
	laser_count = 1



# 공격 옵션(레이저 빠르기)
signal laser_speed_changed(new_speed: int)
var laser_speed: int = 800:
	set(value):
		laser_speed = value
		laser_speed_changed.emit(laser_speed)
	get:
		return laser_speed

func add_laser_speed(amount: int) -> void:
	laser_speed += amount

func reset_laser_speed() -> void:
	laser_speed = 800



# 공격 옵션(레이저 쿨타임)
signal laser_spawn_time_changed(new_spawn_time: float)
var laser_spawn_time: float = 1.0:
	set(value):
		laser_spawn_time = value
		laser_spawn_time_changed.emit(laser_spawn_time)
	get:
		return laser_spawn_time

func decrease_laser_spawn_time(amount: float) -> void:
	laser_spawn_time -= amount

func reset_laser_spawn_time() -> void:
	laser_spawn_time = 1.0
	
	
# 공격 옵션(레이저 각도)
enum LaserSpreadType { NARROW, WIDE }
signal laser_spread_type_changed(new_spread_type: LaserSpreadType)
var laser_spread_type: LaserSpreadType = LaserSpreadType.NARROW:
	set(value):
		laser_spread_type = value
		laser_spread_type_changed.emit(laser_spread_type)
	get:
		return laser_spread_type

func reset_laser_spread() -> void:
	laser_spread_type = LaserSpreadType.NARROW



# 난이도
signal level_changed(new_score: int)
var level: int = 100:
	set(value):
		level = value
		level_changed.emit(level)
	get:
		return level

func add_level(amount: int) -> void:
	level += amount

func reset_level() -> void:
	level = 0
