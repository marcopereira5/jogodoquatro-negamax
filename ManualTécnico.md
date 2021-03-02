# Inteligência Artificial 2020/2021

## Manual Técnico - Problema do Quatro

---

- **Unidade Curricular**: Inteligência Artificial
- **Projeto Problema do Quatro** - 2ª Fase
- **Alunos**: - Marco Pereira nº180221019 - Afonso Cunha nº180221017
  <br><br>

### Índice

- [Algoritmo Implementado](#algoritmo-implementado)
- [Tipos Abstratos de Dados](#tipos-abstratos-de-dados)
  - [Nó](#n%C3%B3)
- [Análise Estatística](#an%C3%A1lise-estat%C3%ADstica)
- [Limitações do Projeto](#limita%C3%A7%C3%B5es-do-projeto)

<br>

O objetivo deste manual é fazer a documentação técnica da implementação de um programa, na linguagem _LISP_, cujo objetivo é jogar **Jogo do Quatro** com um humano ou contra outro programa, no contexto da unidade curricular de Inteligência Artificial.

Para o efeito foram criados 3 ficheiros que dividem o projeto em:

- **jogo.lisp**: Implementação da resolução do problema, incluindo a definição dos operadores e função de avaliação, específicos do problema a ser tratado.
- **algoritmo.lisp**: Contém as funções relacionadas com o algoritmo _Negamax com cortes alfa-beta_ independente o domínio da aplicação.
- **interact.lisp**: Contém as funções necessárias para escrever e ler de ficheiros e tratar da interação com o utilizador.

O objetivo principal desta segunda fase do projeto foi a implementação de um algoritmo que consiga retornar a melhor jogada possível de modo a ganhar o jogo - **Jogo do Quatro**. O vencedor é determinado por quem conseguir formar uma diagonal, linha ou coluna com peças que tenham pelo menos uma característica em comum.
<br><br>

## Algoritmo Implementado

O _Negamax_ é, de certa forma, uma formulação do _Minimax_ em que se passa a procurar sempre apenas o máximo, mas se troca o sinal em cada nível, após o backup.

Apesar das influências do _Minimax_, existe a possibilidade do _Negamax_ poder ser mais eficiente, ambos com Alpha-Beta prunning.

Com a facilidade na sua sintaxe e compreensão, a implementação do _Negamax_ foi feita através de, marioritariamente, recursividade.

### Pseudocódigo _NEGAMAX_ com cortes alfa-beta

```
;;; argumentos: nó n, profundidade d, cor c
;;; b = ramificação (número de sucessores)
function negamax (n, d, c &aux bestValue)
    if d = 0 ou n é terminal
        return c * valor heuristico de n
    bestValue := −∞
    para cada sucessor de n (n1, ..., nk,..., nb)
        bestValue := max(bestValue, −negamax(nk, d−1, −c) )
    return bestValue

```

### Implementação em _LISP_

```lisp
(defun negamax (no profundidade fun-sucessores jogador tempo-limite &optional (a most-negative-fixnum) (b most-positive-fixnum)(nos-gerados 0) (cortes 0) (tempo-inicial (get-internal-real-time)))
  "Algoritmo Negamax"
  (let* ((sucessores (ordenar-nos (funcall fun-sucessores no) jogador)))
        (cond
         ((>= (- (get-internal-real-time) tempo-inicial) tempo-limite) (list no (list nos-gerados cortes (- (get-internal-real-time) tempo-inicial))))
         ((or (equal profundidade 0) (null sucessores)) (list no (list nos-gerados cortes (- (get-internal-real-time) tempo-inicial))))
         (t (negamax-aux no profundidade a b jogador sucessores fun-sucessores nos-gerados cortes tempo-limite tempo-inicial))
         )
        )
)
(defun negamax-aux (no profundidade a b jogador sucessores fun-sucessores nos-gerados cortes tempo-limite tempo-inicial)
  "Função auxiliar para o bom funcionamento do Negamax"
  (cond
   ((= (length sucessores) 1) (negamax (car sucessores) (- profundidade 1) fun-sucessores (* -1 jogador) tempo-limite (* a -1) (* b -1) (+ nos-gerados 1) cortes tempo-inicial))
   (t (let* ((car-solucao (negamax (car sucessores) (- profundidade 1) fun-sucessores (* -1 jogador) tempo-limite (* a -1) (* b -1) (+ nos-gerados 1) cortes tempo-inicial))
             (solucao (car car-solucao))
             (maior-f-let (cond
                            ((> (third solucao) (third no)) solucao)
                            ((<= (third solucao) (third no)) no)
                            ))
             (alpha-let (max a (third maior-f-let))))
        (cond
         ((>= alpha-let b) (list no (list(car (second car-solucao)) (+ (second (second car-solucao)) 1) (- (get-internal-real-time) tempo-inicial))))
         (t (negamax-aux no profundidade alpha-let b jogador (cdr sucessores) fun-sucessores (car (second car-solucao)) (second (second car-solucao)) tempo-limite tempo-inicial))
         )
        )
      )
   )
)
```

Dada a complexidade do problema e do algoritmo a implementar, acabámos por criar algumas funções auxiliares de modo a simplificar a implmentação e tornar o algoritmo mais eficiente utilizando por exemplo funções nativas do lisp (por exemplo _sort_)

```lisp
(defun comparar-nos (no-1 no-2)
  "Função que compara o custo de dois nós"
  (cond
   ((< (no-heuristica no-1) (no-heuristica no-2)) no-2)
   (t no-1))
)

(defun compare-nos-decrescente (no-1 no-2)
  "Função comparação para usar no sort"
  (< (no-heuristica no-1) (no-heuristica no-2))
)

(defun compare-nos-crescente(no-1 no-2)
  "Função comparaÃ§Ã£o para usar no sort"
  (> (no-heuristica no-1) (no-heuristica no-2))
)

(defun ordenar-nos (list jogador)
"Função que retorna uma lista ordenada de acordo com o <compare-nos>"
  (cond
   ((null list) nil)
   ((= jogador -1) (sort list 'compare-nos-crescente))
   ((= jogador 1) (sort list 'compare-nos-decrescente))
   )
)
```

## Tipos Abstratos de Dados

É importante referir a captação dos conceitos do domínio do problema em questão e o mapeamento para o tipo abstrato de dados que se implementaram. Construíram-se dois tipos fundamentais:

- Estado
- Nó

### Nó

O conceito de nó, usado nos algoritmos de procura, foi captado tendo em conta as necessidades do problema e é representado por 3 objetos:

- O estado do nó:  
   Que é dividido por duas secções:
  - O Tabuleiro (os zeros indicam casas vazias):
  ```lisp
  (
    ((branca quadrada alta oca) (preta quadrada baixa cheia) (branca quadrada baixa oca) (preta quadrada alta oca))
    ((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0)
    (0 (preta redonda alta cheia) (preta redonda baixa cheia) 0)
    ((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))
  )
  ```
  - A Reserva:
  ```lisp
  (
  	(preta quadrada baixa oca)
  	(branca redonda baixa cheia)
  	(preta quadrada alta cheia)
  )
  ```
- A profundidade do nó:
  `1`
- O valor da função de avaliação do nó:
  `0`
  Imaginando que este nó é um nó pai onde vai correr o algoritmo _Negamax_ a função de avaliação não interessa, daí ser representada com **0**.

## Análise Estatística

De seguida, é mostrada uma análise estátistica às jogadas feita numa partida do Jogo de Quatro - Computador vs Computador. A cada jogada analisa-se estastísticas referentes aos nós analisados, aos cortes e ao tempo gasto. O tempo limite usado para a execução do algoritmo de procura foi **5** segundos.

```lisp
 Jogada: (3 - 3)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 8766
 Cortes: 4038
 Tempo Gasto: 6529

 -----------------------------------

 Jogada: (3 - 0)
 (0 0 0 0)
 (0 0 0 0)
 (0 0 0 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 450
 Cortes: 225
 Tempo Gasto: 1244

 -----------------------------------

 Jogada: (0 - 3)
 (0 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 0 0 0)
 (0 0 0 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 392
 Cortes: 196
 Tempo Gasto: 962

 -----------------------------------

 Jogada: (0 - 0)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 0 0 0)
 (0 0 0 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 338
 Cortes: 169
 Tempo Gasto: 756

 -----------------------------------

 Jogada: (2 - 2)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 0 0 0)
 (0 0 (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 288
 Cortes: 144
 Tempo Gasto: 542

 -----------------------------------

 Jogada: (1 - 1)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 (PRETA REDONDA ALTA CHEIA) 0 0)
 (0 0 (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 242
 Cortes: 121
 Tempo Gasto: 358

 -----------------------------------

 Jogada: (2 - 1)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 (PRETA REDONDA ALTA CHEIA) 0 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 200
 Cortes: 100
 Tempo Gasto: 244

 -----------------------------------

 Jogada: (1 - 2)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 0 (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 162
 Cortes: 81
 Tempo Gasto: 171

 -----------------------------------

 Jogada: (3 - 2)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) 0 (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 128
 Cortes: 64
 Tempo Gasto: 100

 -----------------------------------

 Jogada: (3 - 1)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 (0 (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 98
 Cortes: 49
 Tempo Gasto: 59

 -----------------------------------

 Jogada: (1 - 0)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 ((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) 0)
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 72
 Cortes: 36
 Tempo Gasto: 28

 -----------------------------------

 Jogada: (1 - 3)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 ((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) 0)
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 50
 Cortes: 25
 Tempo Gasto: 12

 -----------------------------------

 Jogada: (2 - 3)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 ((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
 (0 (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA))
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 32
 Cortes: 16
 Tempo Gasto: 5

 -----------------------------------

 Jogada: (2 - 0)
 ((BRANCA REDONDA BAIXA CHEIA) 0 0 (PRETA REDONDA BAIXA CHEIA))
 ((BRANCA QUADRADA BAIXA OCA) (PRETA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA CHEIA) (BRANCA REDONDA ALTA OCA))
 ((PRETA REDONDA ALTA OCA) (BRANCA QUADRADA ALTA OCA) (PRETA QUADRADA ALTA OCA) (PRETA REDONDA BAIXA OCA))
 ((PRETA QUADRADA ALTA CHEIA) (PRETA QUADRADA BAIXA OCA) (BRANCA REDONDA BAIXA OCA) (PRETA QUADRADA BAIXA CHEIA))

 Nos Analisados: 18
 Cortes: 9
 Tempo Gasto: 1

 -----------------------------------
```

## Limitações do Projeto

Na solução encontrada para a implementação do algoritmo em causa, ou seja, o algoritmo de procura, _Negamax_, encontra-se uma limitação que pode interferir ou influenciar, a cima de tudo, a eficiência do mesmo, que é a não implementação da _memoization_, ou seja, a implementação do algoritmo usando uma _hash-table_ que guardaria os valores dos nós. Com essa implmentação feita, permitiria que, ao encontrar um nó já analisado anteriormente, o algoritmo não tivesse de explorar a àrvore até aos nós folha para encontrar o valor dos mesmos, mas, em vez disso, acedesse, pesquisando os valores, à tabela _hash_.
