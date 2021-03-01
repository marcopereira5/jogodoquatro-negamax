;;;; jogo.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 2� projeto
;;;; Autor: Marco Pereira N� 180221019 / Afonso Cunha N� 180221017


;;;; Constantes:
;;;;
(defvar *jogador2* -1)
(defvar *jogador1* 1)
(defvar *tabuleiro* '(
          (
          (
           (0 0 0 0) (0 0 0 0) (0 0 0 0) (0 0 0 0)
           )
          (
           (branca quadrada baixa cheia)
           (branca quadrada alta cheia)
           (branca redonda alta oca)
           (preta redonda alta oca)
           (branca redonda baixa oca)
           (preta redonda baixa oca)
           (branca quadrada alta oca)
           (preta quadrada alta oca)
           (branca quadrada baixa oca)
           (preta quadrada baixa oca)
           (branca redonda alta cheia)
           (preta redonda alta cheia)
           (branca redonda baixa cheia)
           (preta redonda baixa cheia)
           (preta quadrada alta cheia)
           (preta quadrada baixa cheia)
           )
          )
          0
          0
          NIL
        )
)


(defun teste-a ()
"Fun��o que representa um tabuleiro de teste"
  '(
    (
		(
			((branca quadrada alta oca) (preta quadrada baixa cheia) 0 (preta quadrada alta oca)) 
			((branca redonda alta oca) (preta redonda alta oca) (branca redonda alta cheia) 0) 
			(0 (preta redonda alta cheia) (preta redonda baixa cheia) 0) 
			((branca redonda baixa oca) (branca quadrada alta cheia) (preta redonda baixa oca) (branca quadrada baixa cheia))
		)
		(
			(branca quadrada baixa oca)
			(preta quadrada baixa oca)
			(branca redonda baixa cheia)
			(preta quadrada alta cheia)
		)
	)
    0
    2
    NIL
    )
)

(defun tabuleiro (no)
"Fun��o que retorna o tabuleiro"
  (cond 
   ((null no) nil)
   (t (car (car no)))
   )
)

(defun no-estado (no)
"Fun��o que retorna o estado do no"
  (car no)
)

(defun reserva (no)
"Fun��o que retorna as pe�as de reserva"
  (cond 
   ((null no) nil)
   (t (cadr (car no)))
   )
)

(defun no-profundidade (no)
"Fun��o que retorna a profundidade do no"
  (cond 
   ((null no) nil)
   (t (cadr no)))
)

(defun no-pai (no)
"Fun��o que retorna o no pai do no"
  (cond 
   ((null no) nil)
   (t (cadddr no)))
)

(defun no-custo (no)
"Fun��o que retorna o custo do n�"
  (+ (caddr no) (cadr no))
)

(defun no-heuristica (no)
"Fun��o que retorna a heuristica do n�"
  (caddr no)
)

(defun linha (index list)
"Fun��o que retorna a linha do tabuleiro do index passado por argumento"
  (cond 
   ((null list) nil)
   (t (nth index list))
   )
)

(defun coluna (index list)
"Fun��o que retorna a coluna do tabuleiro do index passado por argumento"
  (cond 
   ((or (< index 0) (null list)) nil)
   (t (cons (nth index (car list)) (coluna index (cdr list)))))
)

(defun celula (l-index c-index list)
"Fun��o que retorna a c�lula numa determinada posicao"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null list)) nil)
   (t (nth c-index (nth l-index list)))
   )
)

(defun diagonal-1 (list)
"Fun��o que retorna a primeira diagonal"
  (cond 
   ((null list) nil)
   (t (list (nth 0 (nth 0 list)) (nth 1 (nth 1 list)) (nth 2 (nth 2 list)) (nth 3 (nth 3 list)))))
)

(defun diagonal-2 (list)
"Fun��o que retorna a segunda diagonal"
  (cond 
   ((null list) nil)
   (t (list (nth 3 (nth 0 list)) (nth 2 (nth 1 list)) (nth 1 (nth 2 list)) (nth 0 (nth 3 list)))))
)

(defun casa-vaziap (l-index c-index list)
"Fun��o que indica se uma determianda casa est� ocupada ou n�o"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null list)) nil)
   ((equal (nth c-index (nth l-index list)) 0) t)
   (t nil)
   )
)

(defun remover-peca (piece list)
"Fun��o que remove uma peca de uma lista"
  (cond 
   ((or (null piece) (null list)) nil)
   ((equal (car list) piece) (remover-peca piece (cdr list)))
   (t (cons (car list) (remover-peca piece (cdr list)))))
)

(defun substituir-list (index list element &optional (count 0))
"Fun��o auxiliar que substitui um elemento numa lista"
  (cond 
   ((null list) '())
   ((= index count) (cons element (substituir-list index (cdr list) element (+ count 1))))
   (t (cons (car list) (substituir-list index (cdr list) element (+ count 1)))))
)

(defun substituir-posicao (index piece line)
"Fun��o que substitu� uma peca numa determinada linha"
  (cond 
   ((or (< index 0) (null piece) (null line)) nil)
   (t (substituir-list index line piece))
   )
)

(defun substituir (l-index c-index piece list)
"Fun��o que substitui uma peca numa lista/tabuleiro"
  (cond 
   ((or (< l-index 0) (< c-index 0) (null piece) (null list)) nil)
   (t (substituir-posicao l-index (substituir-posicao c-index piece (linha l-index list)) list)))
)

(defun operador (l-index c-index piece no)
"Fun��o que realiza uma jogada e retorna o estado seguinte"
    (cond 
     ((casa-vaziap l-index c-index (tabuleiro no)) (list (substituir l-index c-index piece (tabuleiro no)) (remover-peca piece (reserva no))))
     (t nil)
     )
)

(defun operadores ()
"Fun��o que retorna os operadores/jogadas poss�veis"
  '((0 0) (0 1) (0 2) (0 3) (1 0) (1 1) (1 2) (1 3) (2 0) (2 1) (2 2) (2 3) (3 0) (3 1) (3 2) (3 3))
)

(defun check-line (line)
"Fun��o que retorna o numero de vezes que a caracteristica mais comum aparece numa linha"
  (max
  (count 'branca (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (first x)))) line):test #'equal)
  (count 'preta (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (first x)))) line):test #'equal)
  (count 'redonda (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (second x)))) line):test #'equal)
  (count 'quadrada (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (second x)))) line):test #'equal)
  (count 'alta (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (third x)))) line):test #'equal)
  (count 'baixa (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (third x)))) line):test #'equal)
  (count 'cheia (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (fourth x)))) line):test #'equal)
  (count 'oca (mapcar #'(lambda (x) (cond
                                     ((atom x) 0)
                                     (t (fourth x)))) line):test #'equal)
  )
)

(defun check_empty (line)
  "Fun��o que verifica se uma linha est� vazia"
  (count 0 line)
)

(defun fun_avaliacao (no)
  "Fun��o de avalia��o do negamax"
   (+
  (fun_avaliacao_aux (linha 0 (car no)))
  (fun_avaliacao_aux (linha 1 (car no)))
  (fun_avaliacao_aux (linha 2 (car no)))
  (fun_avaliacao_aux (linha 3 (car no)))
  (fun_avaliacao_aux (coluna 0 (car no)))
  (fun_avaliacao_aux (coluna 1 (car no)))
  (fun_avaliacao_aux (coluna 2 (car no)))
  (fun_avaliacao_aux (coluna 3 (car no)))
  (fun_avaliacao_aux (diagonal-1 (car no)))
  (fun_avaliacao_aux (diagonal-2 (car no))))
)

(defun fun_avaliacao_aux (line)
  "Fun��o auxiliar de avalia��o do negamax"
  (let ((NUMBER_SAME_CHARACTHERISTICS (check-line line)))
    (cond 
     ((and (= NUMBER_SAME_CHARACTHERISTICS 3) (= (check_empty line) 1)) -100)
     ((= NUMBER_SAME_CHARACTHERISTICS 4) 1000)
     ((and (= NUMBER_SAME_CHARACTHERISTICS 2) (= (check_empty line) 2)) 10)
     ((and (= NUMBER_SAME_CHARACTHERISTICS 1) (= (check_empty line) 3)) 1)
     (t 0))
    )
)

(defun end-condition (no)
"Fun��o que indica se o no um chegou � condi��o final / Condi��o final - Quando existem 4 caracteristicas iguais numa linha"
  (let ((NUMBER_SAME_CHARACTHERISTICS (max
  (check-line (linha 0 (tabuleiro no)))
  (check-line (linha 1 (tabuleiro no)))
  (check-line (linha 2 (tabuleiro no)))
  (check-line (linha 3 (tabuleiro no)))
  (check-line (coluna 0 (tabuleiro no)))
  (check-line (coluna 1 (tabuleiro no)))
  (check-line (coluna 2 (tabuleiro no)))
  (check-line (coluna 3 (tabuleiro no)))
  (check-line (diagonal-1 (tabuleiro no)))
  (check-line (diagonal-2 (tabuleiro no))))))
  (cond 
   ((= NUMBER_SAME_CHARACTHERISTICS 4) t)
   (t nil)))
)

(defun novo-sucessor (no l-index c-index piece)
"Fun��o que retorna um novo sucessor de um determinado n� no contexto do problema"
  (let 
      ((oper (operador l-index c-index piece no)))
    (cond 
     ((null oper) nil)
     (t (list oper (1+ (no-profundidade no)) (fun_avaliacao oper) l-index c-index)
))))

(defun sucessores (no)
"Fun��o que retorna os sucessores de um determinado no"
  (remove NIL (mapcan #'(lambda (operador) (remove NIL (mapcar #'(lambda (peca) (novo-sucessor no (car operador) (cadr operador) peca)) (reserva no)))) (operadores)))
)



