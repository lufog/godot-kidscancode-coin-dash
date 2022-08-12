class_name Player
extends Area2D


signal pickup
signal hurt

@export var speed := 350

var velocity := Vector2.ZERO
var screen_size: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var direction := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * speed, speed * delta)
		animated_sprite.play("run")
		animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, speed * delta)
	
	_move(delta)


func start(start_position: Vector2) -> void:
	position = start_position
	animated_sprite.play("idle")
	set_process(true)


func die() -> void:
	animated_sprite.play("hurt")
	set_process(false)


func _move(delta: float) -> void:
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
