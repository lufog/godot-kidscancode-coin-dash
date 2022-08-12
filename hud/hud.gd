class_name Hud
extends CanvasLayer


signal start_game

@onready var score_label: Label = $MarginContainer/ScoreLabel 
@onready var time_label: Label = $MarginContainer/TimeLabel
@onready var message_label: Label = $MessageLabel
@onready var message_timer: Timer = $MessageTimer
@onready var start_button: Button = $StartButton


func update_score(value: int) -> void:
	score_label.text = str(value)


func update_time(value: int) -> void:
	time_label.text = str(value)


func show_game_over() -> void:
	show_message("Game Over")
	await message_timer.timeout
	start_button.show()
	show_message("Coin Dash", false)


func show_message(text: String, auto_hide := true) -> void:
	message_label.text = text
	message_label.show()
	
	if auto_hide:
		message_timer.start()
		await message_timer.timeout
		message_label.hide()


func _on_start_button_pressed() -> void:
	start_button.hide()
	message_label.hide()
	start_game.emit()
