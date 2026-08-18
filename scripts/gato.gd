extends Area2D

# A mesma matemática do Rato para cravar no Grid
const PASSO_LOGICO_X: int = 25 
const PASSO_LOGICO_Y: int = 50 
const PASSO_VISUAL_PX: int = 50 
const OFFSET_X: int = 50
const OFFSET_Y: int = 100 

# O cérebro da Patrulha (Preencha com as coordenadas do seu mapa)
var caminho: Array[Vector2] = [
	Vector2(50, 350), Vector2(75, 350), Vector2(100, 350), Vector2(125, 350), Vector2(150, 350), Vector2(175, 350), Vector2(200, 350), Vector2(225, 350),
	Vector2(225, 300), Vector2(225, 250), Vector2(225, 200), Vector2(225, 250), Vector2(225, 300), Vector2(225, 350), Vector2(225, 400), Vector2(225, 450), Vector2(225, 500), Vector2(225, 550),
	Vector2(200, 550), Vector2(175, 550), Vector2(150, 550), Vector2(125, 550), Vector2(100, 550), Vector2(75, 550), Vector2(50, 550), Vector2(25, 550),
	Vector2(25, 500), Vector2(25, 450), Vector2(25, 400), Vector2(25, 350), Vector2(50, 350)
]

var indice_atual: int = 0
var indo_frente: bool = true

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	# Colocamos o gato no primeiro quadrado do caminho assim que o jogo começa
	if caminho.size() > 0:
		atualizar_posicao_visual(caminho[0].x, caminho[0].y)

# -----------------------------------------------------
# DESAFIO 7: A IA de Patrulha (O Vai-e-Vem)
# -----------------------------------------------------
func _on_timer_timeout() -> void:
	# Segurança: Só roda a IA se o array tiver sido preenchido
	if caminho.is_empty():
		return
		
	# Para saber se o gato andou pra esquerda ou direita no final, 
	# vamos guardar onde ele estava ANTES de dar o passo:
	var x_anterior = caminho[indice_atual].x
	
	# PASSO 1: O Ping-Pong do Índice

	if (indo_frente == true):
		indice_atual += 1
	else:
		indice_atual -= 1

	# PASSO 2: Bateu na parede do Array? Inverte a direção!
	
	if (indice_atual == caminho.size() - 1):
		indo_frente = false
	elif (indice_atual == 0):
		indo_frente = true
	
	# PASSO 3: O Novo Destino

	var novo_x = caminho[indice_atual].x
	var novo_y = caminho[indice_atual].y
	
	# PASSO 4: O FLIP (Olhando para o lado certo)

	if novo_x > x_anterior:
		sprite.flip_h = true
	elif novo_x < x_anterior:
		sprite.flip_h = false
	
	# PASSO 5: A Execução Visual

	atualizar_posicao_visual(novo_x, novo_y)

# O Tradutor Visual (Idêntico ao do Rato)
func atualizar_posicao_visual(logico_x: int, logico_y: int) -> void:
	var colunas_x: int = logico_x / PASSO_LOGICO_X
	var linhas_y: int = logico_y / PASSO_LOGICO_Y
	
	position.x = OFFSET_X + (colunas_x * PASSO_VISUAL_PX) + 25
	position.y = OFFSET_Y + (linhas_y * PASSO_VISUAL_PX) + 25