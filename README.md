# Documentação do Projeto 🚧

## Introdução
Este documento serve como uma introdução ao código do projeto, que está atualmente em desenvolvimento. O jogo, ainda em fase de construção, utiliza Assembly para criar uma experiência interativa baseada em gráficos. 🚧

## Estrutura do Código

### Segmentos Definidos
- **STACK SEGMENT**: Reserva espaço para a pilha do programa.
- **DATA SEGMENT**: Define variáveis e constantes utilizadas pelo jogo.
- **CODE SEGMENT**: Contém o código executável do jogo, incluindo procedimentos para desenhar elementos na tela e manipular a lógica do jogo.

### Principais Componentes
- **Janela do Jogo**: Definida por `WINDOW_W` e `WINDOW_H`, estabelece o tamanho da janela do jogo.
- **Bola**: A bola, com posição inicial (`BALL_ORIGINAL_X`, `BALL_ORIGINAL_Y`), posição atual (`BALL_X`, `BALL_Y`), tamanho (`BALL_SIZE`) e velocidade (`BALL_VEL_X`, `BALL_VEL_Y`), é um elemento central do jogo.
- **Raquetes**: Posições e dimensões das raquetes são definidas (`PADDLE_L_X`, `PADDLE_L_Y`, `PADDLE_R_X`, `PADDLE_R_Y`, `PADDLE_WIDTH`, `PADDLE_HEIGHT`).

### Lógica do Jogo
- **Inicialização**: O procedimento `MAIN` configura o segmento de dados e o modo gráfico.
- **Movimentação da Bola**: `MOVE_BALL` atualiza a posição da bola com base em sua velocidade e verifica colisões com as bordas da janela.
- **Desenho dos Elementos**: `DRAW_BALL` e `DRAW_PADDLES` são responsáveis por desenhar a bola e as raquetes na tela.
- **Controle de Tempo**: Utiliza `TIME_AUX` para controlar a atualização dos elementos na tela.

### Procedimentos Auxiliares
- **`CLR_SCR`**: Limpa a tela.
- **`RESET_BALL_POSITION`**: Reposiciona a bola em sua posição inicial após uma colisão.

## 🚧 Em Desenvolvimento 🚧
Este código está em uma fase inicial de desenvolvimento. Muitas funcionalidades estão pendentes, e ajustes serão necessários para completar o jogo. A documentação será atualizada conforme o projeto evolui.

## Contribuições
Contribuições são bem-vindas! Se você tem ideias ou deseja contribuir com o projeto, por favor, sinta-se à vontade para colaborar.

## Conclusão
Este documento oferece uma visão geral do estado atual do código do jogo. O projeto está em uma fase emocionante de desenvolvimento, com muitas oportunidades para inovação e melhoria. Agradecemos seu interesse e apoio ao projeto! 🌟