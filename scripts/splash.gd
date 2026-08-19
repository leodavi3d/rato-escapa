extends Control

# Referências
@onready var animacao: AnimationPlayer = $AnimationPlayer
@onready var sfx_start: AudioStreamPlayer = $SFXStart
@onready var press_start_label: Label = $PressStartLabel

@onready var timer_pisca: Timer = $TimerPisca

# Variável de estado: o jogador só pode apertar start quando essa variável virar 'true'
var pode_iniciar: bool = false

func _ready() -> void:
	# Quando a cena nascer, mandamos o AnimationPlayer rodar a timeline chamada "abertura"
	animacao.play("abertura")

	if not MusicaTema.playing:
		MusicaTema.play()

func liberar_start() -> void:
	print("GATILHO FUNCIONOU! O Start está liberado.")
	pode_iniciar = true
	timer_pisca.start()

func _unhandled_input(event: InputEvent) -> void:	
	if pode_iniciar and event.is_pressed() and event.is_action("ui_accept"):
		pode_iniciar = false
		timer_pisca.stop()
		press_start_label.modulate.a = 1.0

		sfx_start.play()
		MusicaTema.stop()
		await get_tree().create_timer(1.0).timeout
		get_tree().change_scene_to_file("res://scenes/stage_screen.tscn")

	
func _on_timer_pisca_timeout() -> void:
	if press_start_label.modulate.a == 0.0:
		press_start_label.modulate.a = 1.0
	else:
		press_start_label.modulate.a = 0.0
