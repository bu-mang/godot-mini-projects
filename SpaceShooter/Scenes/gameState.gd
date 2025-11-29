extends Node

# 게임오버 상태
var _game_over := false
signal is_game_over_changed(game_over: bool)
var game_over: bool = false:
	set(value):
		_game_over = value
		is_game_over_changed.emit(_game_over)
	get:
		return _game_over


# 난이도
var _level := 1
signal level_changed(new_level: int)
var level:
	set(value):
		_level = value
		level_changed.emit(_level)
	get:
		return _level

func add_level(amount: int) -> void:
	level += amount

func reset_level() -> void:
	level = 1
		
var game_timer: Timer

var _elapsed_time: float = 0.0 
var elapsed_time:
	set(value):
		_elapsed_time = value
	get:
		return _elapsed_time

# 스코어
var _fuel: int = 100
signal fuel_changed(new_fuel: int)
var fuel:
	set(value):
		_fuel = value
		fuel_changed.emit(_fuel)
	get:
		return _fuel

func add_fuel(amount: int) -> void:
	fuel = min(100, fuel + amount)

func reset_fuel() -> void:
	fuel = 100
	
	
	
	
# 체력
var _hp: int = 100
signal hp_changed(new_score: int)
var hp:
	set(value):
		_hp = value
		hp_changed.emit(_hp)
	get:
		return _hp

func add_hp(amount: int) -> void:
	hp += amount

func reset_hp() -> void:
	hp = 0
	
	
	
# 공격 옵션(레이저 갯수)
var _laser_count: int = 1
signal laser_count_changed(new_score: int)
var laser_count:
	set(value):
		_laser_count = value
		laser_count_changed.emit(_laser_count)
	get:
		return _laser_count

func add_laser_count(amount: int) -> void:
	laser_count += amount

func reset_laser_count() -> void:
	laser_count = 1



# 공격 옵션(레이저 빠르기)
var _laser_speed: int = 800
signal laser_speed_changed(new_speed: int)
var laser_speed:
	set(value):
		_laser_speed = value
		laser_speed_changed.emit(_laser_speed)
	get:
		return _laser_speed

func add_laser_speed(amount: int) -> void:
	var temp = _laser_speed + amount
	laser_speed = min(1600, temp)  # 최대 1600으로 제한


func reset_laser_speed() -> void:
	laser_speed = 800



# 공격 옵션(레이저 쿨타임)
var _laser_spawn_time: float = 1.0
signal laser_spawn_time_changed(new_spawn_time: float)
var laser_spawn_time:
	set(value):
		_laser_spawn_time = value
		laser_spawn_time_changed.emit(_laser_spawn_time)
	get:
		return _laser_spawn_time

func decrease_laser_spawn_time(amount: float) -> void:
	var temp = laser_spawn_time - amount
	laser_spawn_time = max(0.2, temp)

func reset_laser_spawn_time() -> void:
	laser_spawn_time = 1.0
	
	
# 공격 옵션(레이저 각도)
var _is_wide_shot: bool = false
signal wide_shot_changed(is_wide: bool)
var is_wide_shot:
	set(value):
		_is_wide_shot = value
		wide_shot_changed.emit(_is_wide_shot)
	get:
		return _is_wide_shot

func activate_wide_shot() -> void:
	is_wide_shot = true

func reset_wide_shot() -> void:
	is_wide_shot = false
	

# 공격 옵션(레이저 크기)
var _laser_scale: float = 1.0
signal laser_scale_changed(new_spawn_time: float)
var laser_scale:
	set(value):
		_laser_scale = value
		laser_scale_changed.emit(_laser_scale)
	get:
		return _laser_scale

func upgrade_laser_scale() -> void:
	# 0.1씩 증가, 최대 1.8 (8단계: 1.0 -> 1.1 -> 1.2 -> ... -> 1.8)
	laser_scale = min(1.8, _laser_scale + 0.1)

func reset_laser_scale() -> void:
	laser_scale = 1.0
	
	
func _ready() -> void:
	# 타이머 생성
	game_timer = Timer.new()
	game_timer.wait_time = 1.0
	game_timer.autostart = true
	game_timer.one_shot = false
	add_child(game_timer)

	game_timer.timeout.connect(_on_game_timer_timeout)

func _on_game_timer_timeout() -> void:
	# 게임 오버면 연료 감소 중지
	if game_over:
		return
	
	# 게임 시간: 1초마다 증가
	elapsed_time += 1

	# 10초마다 레벨 업 (1,2,3,4,...)
	var temp_level = 1 + floor(elapsed_time / 10.0)
	if level < temp_level:
		level = temp_level  # setter 통해 level_changed 시그널 emit

	# 연료 레벨 별 감소
	fuel -= min(3, level)  # fuel setter 통해 fuel_changed emit

	# 0 이하로 떨어지면 게임오버
	if fuel <= 0:
		fuel = 0           # fuel_changed 한 번 더 emit
		game_over = true   # is_game_over_changed emit
