# Rato Escapa 🐀

Um jogo *Grid-Based* de raciocínio e fuga desenvolvido na Godot Engine 4. Projeto acadêmico focado em Lógica de Programação, Matemática Vetorial e Level Design, construído durante a graduação em Tecnologia em Jogos Digitais no IFRJ.

## 🎮 Sobre o Projeto

"Rato Escapa" é uma experiência de puzzle onde o jogador controla um rato em um calabouço, movendo-se casa por casa em uma grade abstrata (800x600 mapeada em uma viewport Ultrawide). O objetivo é navegar por uma matriz de colisão estática rigorosa (blockout), evitar obstáculos e escapar antes de ser pego.

### ⚙️ Arquitetura e Tech Art
A lógica do jogo não utiliza a física de colisão padrão da engine (como `CollisionShape2D` ou física de corpos rígidos para bloqueio), mas sim um **Sistema de Colisão em Matriz (Grid Mapping)** construído do zero via GDScript.
* **Segurança de Matriz:** A verificação de limites e obstáculos utiliza a função `.has()` em um `Array[Vector2]`.
* **Separação de Eixos:** Resolução de espaço lógico escalonado independente da resolução visual do asset.
* **Level Design Estrito:** Blockout das áreas de restrição mapeados em malha perfeita.

## 🛠️ Tecnologias Utilizadas
* **Engine:** Godot 4.x
* **Linguagem:** GDScript (Tipagem forte e arquitetura DRY)
* **Arte:** Imagem do exercício PDF da faculdade / Adobe Photoshop 

## 👨‍💻 Desenvolvedor
**Léo Davi** @leodavi3d
* 3D Artist (Hard Surface & Game-Ready Assets) | Indie Game Dev
* [LinkedIn](https://www.linkedin.com/in/leodavi3d/) | [Portfólio / FAB](https://www.artstation.com/leodavi3d)

---
*Projeto em desenvolvimento - Ciclo V0.1.0 (Alpha).*