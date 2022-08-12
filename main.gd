extends Node


@export var coin_scene: PackedScene
@export var playtime := 30

var level: int
var score: int:
	get:
		return score
	set(value):
		score = value
		hud.update_score(score)

var time_left := 0:
	get:
		return time_left
	set(value):
		time_left = value
		hud.update_time(time_left)

var screen_size: Vector2
var playing := false

@onready var hud: Hud = $HUD
@onready var player: Player = $Player
@onready var coin_container: Node = $CoinContainer
@onready var player_start: Position2D = $PlayerStart
@onready var game_timer: Timer = $GameTimer


func _ready() -> void:
	randomize()
	screen_size = get_viewport().get_visible_rect().size
	player.screen_size = screen_size
	player.hide()


func _process(_delta: float) -> void:
	if playing and coin_container.get_child_count() == 0:
		level += 1
		time_left += 5
		spawn_coins()


func new_game() -> void:
	playing = true
	level = 1
	time_left = playtime
	player.start(player_start.position)
	player.show()
	game_timer.start()
	spawn_coins()


func game_over() -> void:
	playing = false
	game_timer.stop()
	for coin in coin_container.get_children():
		coin.queue_free()
	hud.show_game_over()
	player.die()


func spawn_coins() -> void:
	for i in range(4 + level):
		var coin := coin_scene.instantiate() as Coin
		coin_container.add_child(coin)
		coin.screen_size = screen_size
		coin.position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))


func _on_game_timer_timeout() -> void:
	time_left -= 1
	if time_left <= 0:
		game_over()


func _on_player_pickup() -> void:
	score += 1


func _on_player_hurt() -> void:
	game_over()
