extends Control

@onready var voz_game_over: AudioStreamPlayer = $VozGameOver
@onready var game_over_label: Label = $GameOverLabel
@onready var fade_overlay: ColorRect = $FadeOverlay

func _ready() -> void:
	game_over_label.modulate.a = 0.0
	var tween: Tween = create_tween()
	tween.tween_property(game_over_label, "modulate:a", 1.0, 4.0)


func _on_timer_voz_timeout() -> void:
	voz_game_over.play()

	await get_tree().create_timer(4.0).timeout
	_iniciar_fade_out()

func _iniciar_fade_out() -> void:
	var tween_fade: Tween = create_tween()

	tween_fade.tween_property(fade_overlay, "modulate:a", 1.0, 2.5)
	tween_fade.tween_callback(_voltar_para_menu)

func _voltar_para_menu() -> void:
		get_tree().change_scene_to_file("res://scenes/splash.tscn")
