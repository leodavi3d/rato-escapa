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

# -----------------------------------------------------
# DESAFIO 1: Declare o Array de Paredes
# -----------------------------------------------------

# PASSO ÚNICO: 
# Crie uma variável chamada 'paredes' que seja tipada como um Array[Vector2].

var paredes: Array[Vector2] = [Vector2(725, 100), Vector2(750, -50)]
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

# PASSO 1: Fora da função _unhandled_input (pode ser lá embaixo no script), 
# crie uma nova função chamada 'tentar_mover'.
# Ela deve receber três argumentos: alvo_x (int), alvo_y (int) e espelhar (bool).

# PASSO 2: Dentro dessa nova função 'tentar_mover', repita a sua lógica genial.
# Crie a variável 'destino' empacotando o alvo_x e alvo_y no Vector2.

# PASSO 3: Faça a checagem 'if not paredes.has(destino):'.
# DENTRO desse 'if', atualize a variável global 'ratox' recebendo o 'alvo_x', 
# o 'ratoy' recebendo o 'alvo_y', e o sprite.flip_h recebendo o 'espelhar'.
# Em seguida, ainda dentro do 'if', chame atualizar_posicao_visual() e imprimir_status().

# PASSO 4: Agora, volte lá na sua função _unhandled_input.
# Dentro do 'elif event.is_action_pressed("ui_left"):', você só precisa de UMA linha de código.
# Chame a função tentar_mover(), passando os cálculos matemáticos direto dentro dos parênteses.
# Exemplo para a esquerda: tentar_mover(ratox - PASSO_LOGICO_X, ratoy, true)

# PASSO 5: Faça o mesmo para as outras três direções (direita, cima, baixo), 
# ajustando apenas a matemática do X, do Y e o true/false do espelhamento do rato.

func tentar_mover(alvo_x: int, alvo_y: int, espelhar: bool ) -> void:

	# -----------------------------------------------------
# DESAFIO 4: A Cerca Elétrica (Limites do Mapa)
# -----------------------------------------------------

	if (alvo_x < 0 or alvo_x > 800):
		return

	if (alvo_y < 0 or alvo_y > 600):
		return

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
