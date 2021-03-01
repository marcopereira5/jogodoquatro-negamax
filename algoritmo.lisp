;;;; algoritmo.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 2º projeto
;;;; Autor: Marco Pereira Nº 180221019 / Afonso Cunha Nº 180221017

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

(defun criar-solucao (no nos-gerados cortes)
  "Função que cria uma solução para um certo no"
  (list no nos-gerados cortes)
)

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
  "Função comparaçãoo para usar no sort"
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