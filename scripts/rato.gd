extends Area2D

# -------------------------------------------------------------
# 1. AS REGRAS DO SEU BLOCKOUT (Game Design)
# -------------------------------------------------------------
# Quantos pontos a variável ganha/perde a cada clique
const PASSO_LOGICO_X: int = 25 
const PASSO_LOGICO_Y: int = 50 

# O tamanho real do quadrado na tela (50x50 pixels)
const PASSO_VISUAL_PX: int = 50 

# A "gordura" da borda vermelha (1 quadrado à esquerda, 1 no topo)
const OFFSET_X: int = 50
const OFFSET_Y: int = 50

# -------------------------------------------------------------
# 2. A POSIÇÃO LÓGICA DO RATO (A Mente do Jogo)
# -------------------------------------------------------------
# Exatamente as coordenadas da casa onde você escreveu "Rato"
var ratox: int = 750
var ratoy: int = 100

var score = 0
@onready var score_label: Label = $"../HUD/ScoreLabel"

var vivo: bool = true

@export var textura_porta_aberta: Texture2D

@onready var porta_sprite: Sprite2D = $"../Porta/Sprite2D"

@onready var sfx_comer: AudioStreamPlayer = $SFX_Comer
@onready var bgm_fase1: AudioStreamPlayer = %BGM_Fase1

# -----------------------------------------------------
# DESAFIO 1: Declare o Array de Paredes
# -----------------------------------------------------

# PASSO ÚNICO: 
# Crie uma variável chamada 'paredes' que seja tipada como um Array[Vector2].

var paredes: Array[Vector2] = [
	# -- Pilastra top-right --
	Vector2(725, 100), Vector2(725, 50), Vector2(700, 100), Vector2(700, 50),
	# -- Pilastra bottom-right --
	Vector2(700, 325), Vector2(700, 350), Vector2(725, 325), Vector2(725, 350),
	# -- Pilastra bottom-left --
	Vector2(125, 500), Vector2(150, 500), Vector2(175, 500),
	# -- Pilastra top-left --
	Vector2(125, 50), Vector2(125, 100), Vector2(150, 50), Vector2(150, 100), Vector2(175, 50), Vector2(175, 100),
	# -- Plaque bottom-right --
	Vector2(650, 500), Vector2(650, 550), Vector2(675, 500), Vector2(675, 550),

	# -- River top --
	Vector2(550, 0), Vector2(575, 0), Vector2(600, 0), 
	Vector2(550, 50), Vector2(575, 50), Vector2(600, 50),
	Vector2(425, 100), Vector2(450, 100), Vector2(475, 100), Vector2(500, 100), Vector2(525, 100), Vector2(550, 100), Vector2(575, 100), Vector2(600, 100),
	Vector2(425, 150), Vector2(450, 150), Vector2(475, 150),
	Vector2(425, 200), Vector2(450, 200), Vector2(475, 200),
	Vector2(325, 250), Vector2(350, 250), Vector2(375, 250), Vector2(400, 250), Vector2(425, 250), Vector2(450, 250), Vector2(475, 250), Vector2(500, 250), Vector2(525, 250), Vector2(550, 250),
	Vector2(325, 300), Vector2(350, 300), Vector2(375, 300), Vector2(400, 300), Vector2(425, 300), Vector2(450, 300), Vector2(475, 300), Vector2(500, 300), Vector2(525, 300), Vector2(550, 300),

	# -- River down --
	Vector2(275, 400), Vector2(300, 400), Vector2(325, 400), Vector2(350, 400), Vector2(375, 400), Vector2(400, 400), Vector2(425, 400), Vector2(450, 400), Vector2(475, 400),
	Vector2(275, 450), Vector2(300, 450), Vector2(325, 450), Vector2(350, 450), Vector2(375, 450), Vector2(450, 450), Vector2(425, 450), Vector2(450, 450), Vector2(475, 450),
	Vector2(275, 500), Vector2(300, 500), Vector2(325, 500), Vector2(350, 500), Vector2(375, 500), Vector2(400, 500), Vector2(425, 500), Vector2(450, 500), Vector2(475, 500), Vector2(500, 500), Vector2(525, 500), Vector2(550, 500), Vector2(575, 500), Vector2(600, 500),
	Vector2(275, 550), Vector2(300, 550), Vector2(325, 550), Vector2(350, 550), Vector2(375, 550), Vector2(400, 550), Vector2(425, 550), Vector2(450, 550), Vector2(475, 550), Vector2(550, 550), Vector2(575, 550), Vector2(600, 550),
	Vector2(550, 600), Vector2(575, 600), Vector2(600, 600),
	]

# Dentro dos colchetes [ ], adicione dois objetos Vector2():
# 1. O quadrado vermelho que está imediatamente à esquerda do Rato (olhe no seu mapa do Photoshop).
# 2. O quadrado vermelho que está imediatamente acima do Rato.
# Lembre-se de separar os dois Vector2() por uma vírgula.

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# O rato nasce virado para a esquerda e a cena o coloca na posição correta
	sprite.flip_h = true
	atualizar_posicao_visual()
	imprimir_status()

# -----------------------------------------------------
# DESAFIO 3: O Segurança Universal (Regra DRY)
# -----------------------------------------------------

func tentar_mover(alvo_x: int, alvo_y: int, espelhar: bool ) -> void:

	if vivo == false:
		return

	# 1. CERCA ELÉTRICA COM PASSE VIP PARA A PORTA
	if alvo_x == -25 and alvo_y == 350:
		if score < 4:
			return # Porta trancada
	elif alvo_x < 0 or alvo_x > 800:
		return # Bateu na lateral do mapa

	# Limite de Cima e Baixo (Continua normal)
	if alvo_y < 0 or alvo_y > 600:
		return

	# 2. PRANCHETA DO SEGURANÇA (Obstáculos Internos)
	var destino = Vector2(alvo_x, alvo_y)

	if not paredes.has(destino):
		ratox = alvo_x
		ratoy = alvo_y
		sprite.flip_h = espelhar        
		atualizar_posicao_visual()
		imprimir_status()

func _unhandled_input(event: InputEvent) -> void:
	# Filtro de hardware: ignora comandos duplicados de segurar a tecla
	if not event.is_pressed() or event.is_echo():
		return
	
	# Manipulamos APENAS as variáveis lógicas, ignorando os pixels por enquanto
	if event.is_action_pressed("ui_right"):
		tentar_mover(ratox + PASSO_LOGICO_X, ratoy, false)		
		
	elif event.is_action_pressed("ui_left"):
		tentar_mover(ratox - PASSO_LOGICO_X, ratoy, true)	

	elif event.is_action_pressed("ui_down"):
		tentar_mover(ratox, ratoy + PASSO_LOGICO_Y, sprite.flip_h)
		
	elif event.is_action_pressed("ui_up"):
		tentar_mover(ratox, ratoy - PASSO_LOGICO_Y, sprite.flip_h)
		

	# Se uma seta foi pressionada, a tela obedece à lógica
	#if moveu:
	#	atualizar_posicao_visual()
	#	imprimir_status()

# -------------------------------------------------------------
# 3. TRADUTOR: LÓGICA PARA TELA (O Motor Gráfico)
# -------------------------------------------------------------
func atualizar_posicao_visual() -> void:
	# PASSO A: Descobrir em qual "coluna" e "linha" da malha verde o rato está.
	# Ex: Se ratox = 750, então 750 / 25 = 30ª Coluna.
	var colunas_x: int = ratox / PASSO_LOGICO_X
	var linhas_y: int = ratoy / PASSO_LOGICO_Y
	
	# PASSO B: Multiplicar a coluna pelo tamanho do quadrado (50px).
	# PASSO C: Somar o OFFSET (50px) para pular a parede vermelha.
	# PASSO D: Somar 25px (metade do quadrado) para o pivô cravar no meio da casa.
	position.x = OFFSET_X + (colunas_x * PASSO_VISUAL_PX) + 25
	position.y = OFFSET_Y + (linhas_y * PASSO_VISUAL_PX) + 100

func imprimir_status() -> void:
	print("Coordenada Lógica -> X: ", ratox, " | Y: ", ratoy)


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("cheese"):
		sfx_comer.play()
		score = score + 1		
		score_label.text = str(score) 
		area.queue_free.call_deferred()
		
		if score == 4:
			porta_sprite.texture = textura_porta_aberta
	
	elif area.is_in_group("enemy"):
		vivo = false
		sprite.hide()
		
		bgm_fase1.stop()
		if MusicaTema.playing:
			MusicaTema.stop()
		
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")

	elif area.is_in_group("exit"):
		
		bgm_fase1.stop()
		if MusicaTema.playing:
			MusicaTema.stop()
		
		get_tree().change_scene_to_file("res://scenes/win_screen.tscn")
