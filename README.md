# Inteligência Artificial 2020/2021

## Manual de Utilizador - Problema do Quatro

---

- **Unidade Curricular**: Inteligência Artificial
- **Projeto Problema do Quatro** - 2ª Fase
- **Alunos**: - Marco Pereira nº180221019 - Afonso Cunha nº180221017
  <br><br>

### Índice

- [Introdução](#introdu%C3%A7%C3%A3o)
- [Instalação e utilização](#instala%C3%A7%C3%A3o-e-utiliza%C3%A7%C3%A3o)
  - [Instalação](#instala%C3%A7%C3%A3o)
  - [Iniciar o programa](#inicio-do-programa)
- [Input/Output](#inputoutput) - [Valores recebidos](#valores-recebidos) - [Outputs](#outputs) - [Análise da solução e medidas de desempenho](#an%C3%A1lise-da-solu%C3%A7%C3%A3o-e-medidas-de-desempenho)
- [Exemplo do programa](#exemplo-do-programa)
  - [Humano vs Computador](#humano-vs-computador)
    - [Vez do Humano](#vez-do-humano)
    - [Vez do Computador](#vez-do-computador)
    - [Fim de Jogo](#fim-de-jogo)
  - [Computador vs Computador](#computador-vs-computador)

<br><br>

### Introdução

---

Este manual visa a ser um guia compreensivo para o correcto utilizamento do programa **Problema do Quatro**, um programa desenvolvido utilizando a linguagem de programação funcional _[LISP](https://en.wikipedia.org/wiki/LISP)_. O problema do quatro é um jogo constituído por um tabuleiro de 4 x 4 casas e um conjunto de 16 peças, que possuem traços característicos de forma e de cor. Existem quatro tipos de características:

- **Branca ou Preta**
- **Alta ou Baixa**
- **Quadrada ou Redonda**
- **Cheia ou Oca**

Isto significa que as 16 peças do jogo encontram-se divididas da seguinte forma, pelas características mencionadas:

- Existem 8 peças brancas e 8 peças pretas
- Existem 8 peças altas e 8 peças baixas
- Existem 8 peças quadradas e 8 peças redondas
- Existem 8 peças cheias e 8 peças ocas

Adicionalmente, em vez de ser vários jogadores a jogarem, o programa em causa tem implementado dois modos de jogo: o primeiro permite a um jogador enfrentar o computador, enquanto o outro modo demonstra o funcionamento do programa a jogar coom um outra versão de ele próprio.

Para tal foram implementados o algoritmo _[Negamax](https://en.wikipedia.org/wiki/Negamax)_ com _[cortes alfa-beta](https://en.wikipedia.org/wiki/Alpha%E2%80%93beta_pruning)_ para determinar a melhor jogada possível em cada iteração do programae e assim simular as jogadas do computador.

<br>

### Instalação e utilização

---

#### Instalação

Para o correcto funcionamento do programa, é **necessário** ter os seguintes ficheiros na mesma pasta:

- **jogo.lisp**: Implementação da resolução do problema, incluindo a definição dos operadores e função de avaliação, específicos do problema a ser tratado..
- **algoritmo.lisp**: Contém as funções relacionadas com o algoritmo _Negamax com cortes alfa-beta_ independente o domínio da aplicação.
- **interact.lisp**: Contém as funções necessárias para escrever e ler de ficheiros e tratar da interação com o utilizador.

**Importante**: É apenas necessário o compilar o ficheiro **interact.lisp**
Antes de compilar o ficheiro _interact.lisp_, no próprio, é necessário mudar a seguinte directoria para a directoria utilizada na execução do programa, aquela onde se encontram os referidos ficheiros:

```lisp
(defun current-dir()
  "C:/Users/Home/Desktop/AI/Projecto/Fase2/Fase_2/"
)

(compile-file (concatenate 'string (current-dir) "jogo.lisp"))
(compile-file (concatenate 'string (current-dir) "algoritmo.lisp"))
(load (concatenate 'string (current-dir) "jogo.64ofasl"))
(load (concatenate 'string (current-dir) "algoritmo.64ofasl"))
```

#### Inicio do programa

Após abrir o programa, execute a função _start_. Esta função irá dar inicio ao programa e, consequentemente, o seguinte menu aparecerá:

```lisp
_______________________________________
|                                     |
|           JOGO DO QUATRO            |
|                                     |
|        Escolha um modo de jogo      |
|                                     |
|            1 - Humano x PC          |
|            2 - PC x PC              |
|                                     |
|              0 - Sair               |
|_____________________________________|
```

Este menu será o menu recorrente que servirá como interface para o utilizador onde terá diferentes opções:

- **Humano x PC** - Que dará inicio ao modo de jogo entre utilizador e computador
- **PC x PC** - Que dará inicio ao modo de jogo entre computadores
- **Sair** - Que terminará o programa
  Para navegar pelos menus, apenas prima o número desejado, seguido de _Enter_.
  <br><br>

### Input/Output

---

#### Valores recebidos

O input recebido do utilizador será do tipo numérico e representará ou as diferentes opções do menu ou informações necessárias para o decorrer do jogo, o valor numérico irá ser traduzido para uma ação ou escolha.

Os valores números númericos recebidos serão escolhas feitas pelo utilizador relativamente à peça escolhida e à posição que colocá-la.

<br>

#### Outputs

Em ambos os modos, em cada jogada, tanto do utilizador como do computador, será apresentada a indicação da jogada realizada e do aspecto do tabuleiro após a mesma.
Abaixo segue um exemplo de uma jogada por parte do utilizador:

```lisp
Tabuleiro (Ultimo a jogar - Jogador 1):
 (0 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 0 0 0)
 (0 0 0 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))
```

Neste caso vê-se o estado do tabuleiro após a jogada do Jogador 1 no modo de jogo PC x PC
<br>

Na jogada do utilizador, no modo Humano vs PC, é perguntada linha e coluna em que quer ser inserida a peça e qual a peça que deseja colocar na posição indicada, apresentando a lista de peças ainda disponíveis. Após ser feita a jogada, é mostrado o tabuleiro atualizado:
<br>
Escolha da posição

```lisp
 - Indique a linha para colocar a peça (1 - 4): 2
 - Indique a coluna para colocar a peça (1 - 4): 1
```

<br>
Escolha da peça da lista de peças disponíveis:

```lisp
 1 - (BRANCA QUADRADA BAIXA CHEIA)
 2 - (BRANCA QUADRADA ALTA CHEIA)
 3 - (BRANCA REDONDA ALTA OCA)
 4 - (PRETA REDONDA ALTA OCA)
 5 - (PRETA REDONDA BAIXA OCA)
 6 - (PRETA QUADRADA ALTA OCA)
 7 - (BRANCA QUADRADA BAIXA OCA)
 8 - (PRETA QUADRADA BAIXA OCA)
 9 - (BRANCA REDONDA ALTA CHEIA)
 10 - (PRETA REDONDA ALTA CHEIA)
-----------------------------
 - Indique a peça que quer colocar no tabuleiro: 9
```

<br>
Atualização do tabuleiro com a jogada do utilizador
```lisp
 Tabuleiro (Ultimo a jogar - Jogador) 
 ((BRANCA QUADRADA ALTA OCA) 0 0 0)
 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA BAIXA CHEIA) 0)
 (0 0 (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA))
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))
```
<br>

Final de jogo e apresentação do tabuleiro e vencedor:

```lisp
 Tabuleiro (Ultimo a jogar - Computador):
 ((BRANCA QUADRADA ALTA OCA) 0 0 0)
 ((BRANCA REDONDA ALTA CHEIA) 0 (PRETA REDONDA BAIXA CHEIA) 0)
 ((PRETA QUADRADA ALTA OCA) 0 (BRANCA REDONDA BAIXA OCA) (BRANCA REDONDA BAIXA CHEIA))
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))


 Resultado: O Computador Ganhou
```

<br>

A informação sobre a jogada do computador, bem como a informação estatística que a acompanha, que será explicada na próxima secção deste manual, também será guardada num ficheiro denominado de **log.dat** na directoria **C:/Users/Home/Desktop/AI/Projecto/Fase2/Fase_2/log.dat**.

##### Análise da solução e medidas de desempenho

Em cada jogada do computador, tal como referido na secção acima, é possível analisar-se os seguintes dados:

- **O estado do tabuleiro do jogo após a jogada**;
- **Número de nós analisados** - Número de possibilidades que o algoritmo analisou ao todo;
- **Número de cortes efectuados** - Número de jogadas analisadas que o algoritmo definiu como caminhos inválidos ou desnecessários para a procura da melhor jogada;
- **Tempo gasto** - Valor em segundos do tempo que o algoritmo demorou a ser executado. <br> <br>

### Exemplo do programa

---

Inicialmente o utilizador encontra um menu inicial em que poderá escolher entre dois modos de jogo: **PC vs PC** e **Humano vs PC**. Aqui também poderá optar por finalizar o programa, como foi apresentado em **Outputs**

#### Humano vs Computador

---

Ao ser escolha esta opção, o seguinte ecrã é apresentado:

```lisp
_______________________________________
|                                     |
|      JOGO DO QUATRO - 1ª Jogada     |
|                                     |
|             1 - Humano              |
|              2 - PC                 |
|                                     |
|             0 - Sair                |
|_____________________________________|
Escolha um modo: 2
```

Aqui o utilizador escolhe quem faz a primeira jogada ou se volta ao menu inicial (opção _Sair_) e dá inicio ao jogo.
<br>
Após inicio do jogo, é apresentado o tabuleiro incial vazio e é feito a primeira jogada, se for o computador então esta é feita automáticamente.

```lisp
 Tabuleiro (Ultimo a jogar - Jogador)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)


 Tabuleiro (Ultimo a jogar - Computador):
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 (PRETA QUADRADA BAIXA CHEIA))
```

Após a jogada do computador ou após começo do jogo, o utilizador terá a oportunidade de fazer a sua jogada, indicando a posição onde pretende colocar a peça e selecionando-a.

##### Vez do Humano

```lisp
 - Indique a linha para colocar a peça (1 - 4): 2
 - Indique a coluna para colocar a peça (1 - 4): 1
 1 - (BRANCA QUADRADA BAIXA CHEIA)
 2 - (BRANCA QUADRADA ALTA CHEIA)
 3 - (BRANCA REDONDA ALTA OCA)
 4 - (PRETA REDONDA ALTA OCA)
 5 - (PRETA REDONDA BAIXA OCA)
 6 - (PRETA QUADRADA ALTA OCA)
 7 - (BRANCA QUADRADA BAIXA OCA)
 8 - (PRETA QUADRADA BAIXA OCA)
 9 - (BRANCA REDONDA ALTA CHEIA)
 10 - (PRETA REDONDA ALTA CHEIA)
-----------------------------
 - Indique a peça que quer colocar no tabuleiro: 9
```

Depois da jogada do utilizador, o tabuleiro é atualizado e mostrado e é a vez da jogada do computador

##### Vez do Computador

```lisp
Tabuleiro (Ultimo a jogar - Jogador)
 ((BRANCA REDONDA ALTA OCA) (BRANCA QUADRADA BAIXA CHEIA) 0 0)
 ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA CHEIA) 0 0)
 (0 0 0 0)
 ((PRETA REDONDA BAIXA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))


 Tabuleiro (Ultimo a jogar - Computador):
 ((BRANCA REDONDA ALTA OCA) (BRANCA QUADRADA BAIXA CHEIA) 0 0)
 ((PRETA REDONDA BAIXA OCA) (PRETA QUADRADA ALTA CHEIA) 0 0)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 0)
 ((PRETA REDONDA BAIXA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))
```

##### Fim de Jogo

Este ciclo de jogadas entre utilizador e computadores irá se manter até seja encontrado um vencedor. O vencedor é determinado por quem conseguir acabar um linha, coluna ou diagonal com peças que tenham pelo menos uma característica em comum entre elas.

```lisp
Resultado: O Computador Ganhou
```

E assim termina o modo **Humano x PC**.
<br>
<br>

#### Computador vs Computador

---

Depois de selecionar a opção de PC vs PC, à semelhança do modo **Humano x PC**, irá ser feita a apresentação do tabuleiro vazio.

```lisp
Tabuleiro (Ultimo a jogar - Jogador 2)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
```

Em que duas versões do programa, denominadas como Jogador 1 e Jogador 2 irão competir entre sim até o jogo terminar.

<br>

```lisp

Tabuleiro (Ultimo a jogar - Jogador 1):
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 ((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

Tabuleiro (Ultimo a jogar - Jogador 2)
((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
(0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

Tabuleiro (Ultimo a jogar - Jogador 1):
((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
(0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA))
((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

Tabuleiro (Ultimo a jogar - Jogador 2)
((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
((PRETA REDONDA ALTA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA))
((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))
```

<br>

```lisp
 Resultado: Jogador 2 Ganhou
```

Exemplo das últimas 4 jogadas do jogo e respetivo vencedor.
Neste exemplo o jogador 2 ganhou após colocar uma peça preta, redonda, alta e oca na posição **(3,1)** (linha, coluna).
<br><br>
