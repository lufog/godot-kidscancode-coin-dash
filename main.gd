extends Node


@export var coin_scene: PackedScene
@export var playtime := 30.0

var level: int
var score: int
var time_left: float
var screen_size: Vector2
var playing := false

@onready var player: Player = $Player
@onready var coin_container: Node = $CoinContainer
@onready var player_start: Position2D = $PlayerStart
@onready var game_timer: Timer = $GameTimer


func _ready() -> void:
	randomize()
	screen_size = get_viewport().get_visible_rect().size
	player.screen_size = screen_size
	player.hide()
	new_game()


func _process(_delta: float) -> void:
	if coin_container.get_child_count() == 0:
		level += 1
		time_left += 5
		_spawn_coins()


func new_game() -> void:
	playing = true
	level = 1
	time_left = playtime
	player.start(player_start.position)
	player.show()
	game_timer.start()
	_spawn_coins()


func _spawn_coins() -> void:
	for i in range(4 + level):
		var coin := coin_scene.instantiate() as Coin
		coin_container.add_child(coin)
		coin.screen_size = screen_size
		coin.position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
