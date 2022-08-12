class_name Powerup
extends Area2D


var screen_size: Vector2

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var shine_timer: Timer = $ShineTimer


func _ready() -> void:
	shine_timer.wait_time = randf_range(1, 2)
	shine_timer.start()


func pickup() -> void:
	collision_layer = 0
	var tween := create_tween()
	tween.tween_property(animated_sprite, "scale", animated_sprite.scale * 3, 0.3) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(animated_sprite, "self_modulate", Color.TRANSPARENT, 0.3) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	await tween.finished
	queue_free()


func _on_lifetime_timer_timeout() -> void:
	queue_free()


func _on_shine_timer_timeout() -> void:
	animated_sprite.play()


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("obstacles"):
		position = Vector2(randf_range(0, screen_size.x), randf_range(0, screen_size.y))
