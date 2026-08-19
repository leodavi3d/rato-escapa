extends Control

@onready var jingle: AudioStreamPlayer = $Jingle
@onready var timer_cena: Timer = $TimerCena

func _ready() -> void:
	# Assim que a cena nasce, a melodia toca e o relógio começa a contar
	jingle.play()
	timer_cena.start()

func _on_timer_cena_timeout() -> void:
	get_tree().change_scene_to_file("res://scenes/calabouco.tscn")