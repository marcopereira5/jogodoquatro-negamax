;;;; interact.lisp
;;;; Disciplina de IA - 2020 / 2021
;;;; 2º projeto
;;;; Autor: Marco Pereira Nº 180221019 / Afonso Cunha Nº 180221017


(defun current-dir()
  "C:/Users/Home/Desktop/AI/Projecto/Fase2/Fase_2/"
)

"Compila os ficheiros ncessários para o funcionamento do algortimo"
(compile-file (concatenate 'string (current-dir) "jogo.lisp"))
(compile-file (concatenate 'string (current-dir) "algoritmo.lisp"))
(load (concatenate 'string (current-dir) "jogo.64ofasl"))
(load (concatenate 'string (current-dir) "algoritmo.64ofasl"))

(defun jogar-nega(estado profundidade tempo)
  "Função auxiliar que executa o negamax"
  (negamax estado profundidade 'sucessores 1 tempo)
)

(defun jogar (estado tempo)
  "Função para o torneio"
  (let* ((novo-estado (criar-no-torneio estado)) (negamax-run (negamax novo-estado 4 'sucessores 1 tempo)))
    (list (list (fourth (car negamax-run)) (fifth (car negamax-run))) (car (car negamax-run))))
)

(defun criar-no-torneio (estado)
  "Função que cria um nó com um dado estado"
  (list estado 0 0)
)

(defun comecar-jogo-computador-computador (no jogador profundidade)
  "Função que começa o jogo Computador vs Computador"
  (let ((no-atualizado (jogar-nega no profundidade 5000)))
    (progn 
      (cond 
       ((= jogador -1) (format t "~% Tabuleiro (Ultimo a jogar - Jogador 1): ~%" jogador))
       (t (format t "~% Tabuleiro (Ultimo a jogar - Jogador 2) ~%" jogador)))
      (mostrar-tabuleiro (tabuleiro no))
      (format t "~%")
      (cond 
       ((end-condition no) (cond 
                        ((= jogador -1) (format t "~% Resultado: Jogador 1 Ganhou"))
                        (t (format t "~% Resultado: Jogador 2 Ganhou"))))
       (t (escrever-estatisticas (car no-atualizado) (car (cadr no-atualizado)) (cadr (cadr no-atualizado)) (caddr (cadr no-atualizado))) (comecar-jogo-computador-computador (car no-atualizado) (* -1 jogador) 2)))))
)

(defun comecar-jogo-jogador-computador(no jogador tempo &optional (profundidade 2))
  "Função que começa o jogo Jogador vs Computador"
  (cond 
           ((= jogador -1) (format t "~% Tabuleiro (Ultimo a jogar - Computador): ~%"))
           (t (format t "~% Tabuleiro (Ultimo a jogar - Jogador) ~%")))
          (mostrar-tabuleiro (tabuleiro no))
          (format t "~%")
  (cond 
     ((end-condition no) (cond 
                        ((= jogador -1) (format t "~% Resultado: O Computador Ganhou"))
                        (t (format t "~% Resultado: O Jogador Ganhou"))))
     (t (progn
          (cond 
           ((= jogador -1) (comecar-jogo-jogador-computador (jogada-jogador no) (* -1 jogador) tempo (1+ profundidade)))
           ((= jogador 1) (let ((jogada (jogar-nega no profundidade tempo)))
                            (escrever-estatisticas (car jogada) (car (cadr jogada)) (cadr (cadr jogada)) (caddr (cadr jogada)))
                            (comecar-jogo-jogador-computador (car jogada) (* -1 jogador) tempo (1+ profundidade))))))))
  
)


(defun mostrar-tabuleiro (tabuleiro)
  "Função que coloca o tabuleiro de maneira percetÃ­vel para o utilizador"
  (cond 
   ((null tabuleiro) "")
   (t (write-line (concatenate 'string " " (write-to-string (car tabuleiro)))) (mostrar-tabuleiro (cdr tabuleiro))))
)

(defun jogada-jogador (no)
  "Função que executa a jogada do jogar"
  (let* ((linha (escolher-linha)) (coluna (escolher-coluna)) (peca (escolher-peca no)) (sucessor (novo-sucessor no (1- linha) (1- coluna) peca)))
    (cond 
     ((null sucessor) (format t " Casa Ocupada! ~%") (jogada-jogador no))
     (t sucessor)))
)

(defun escolher-linha ()
  "Função que pede um linha ao utilizador"
  (progn 
    (format t " - Indique a linha para colocar a peçaa (1 - 4): ")
    (let ((linha (read)))
      (cond 
       ((or (not (numberp linha)) (< linha 1) (> linha 4)) (progn (format t "Linha InvÃ¡lida ~%") (escolher-linha)))
       (t linha))))
)

(defun escolher-coluna ()
  "Função que pede uma coluna ao utilizador"
  (progn 
    (format t " - Indique a coluna para colocar a peçaa (1 - 4): ")
    (let ((coluna (read)))
      (cond 
       ((or (not (numberp coluna)) (< coluna 1) (> coluna 4)) (progn (format t "Linha InvÃ¡lida ~%") (escolher-coluna)))
       (t coluna))))
)

(defun escolher-peca (no)
  "Função que pede uma peca ao utilizador"
  (let ((reserva (reserva no)))
    (progn
      (mostrar-reserva reserva)
      (format t " - Indique a peça que quer colocar no tabuleiro: ")
      (let ((peca (read)))
        (cond
         ((or (not (numberp peca)) (< peca 1) (> peca (list-length reserva))) (progn (format t "PeÃ§a InvÃ¡lida~%") (escolher-peca no)))
         (t (nth (1- peca) reserva))))))
)

(defun escolher-tempo ()
  "Função que pede um tempo ao utilizador"
  (progn
    (format t "Indique o tempo máximo de jogo do computador (Entre 1000-5000 millisegundos): ")
    (let ((tempo (read)))
      (cond 
       ((or (not (numberp tempo)) (< tempo 1000) (> tempo 5000)) (format t "Tempo inválido ~%") (escolher-tempo))
       (t tempo))))
)

(defun mostrar-reserva (reserva &optional (count 1))
  "Função que mostra a reserva de uma maneira percetível"
  (cond
   ((null reserva) (format t "-----------------------------~%"))
   (t (progn (format t " ~d - ~d~%" count (car reserva)) (mostrar-reserva (cdr reserva) (1+ count)))))
)

(defun menu-inicial()
  "Função que mostra o menu inicial"
 (progn
   (format t "~%_______________________________________")
   (format t "~%|                                     |")
   (format t "~%|           JOGO DO QUATRO            |")
   (format t "~%|                                     |")
   (format t "~%|        Escolha um modo de jogo      |")
   (format t "~%|                                     |")
   (format t "~%|            1 - Humano x PC          |")
   (format t "~%|            2 - PC x PC              |")
   (format t "~%|                                     |")
   (format t "~%|              0 - Sair               |")
   (format t "~%|_____________________________________|~%")  
  )
)

(defun escolher-jogador-menu()
  "Função que mostra o menu secundario"
 (progn
   (format t "~%_______________________________________")
   (format t "~%|                                     |")
   (format t "~%|      JOGO DO QUATRO - 1ª Jogada     |")
   (format t "~%|                                     |")
   (format t "~%|             1 - Humano              |")
   (format t "~%|              2 - PC                 |")
   (format t "~%|                                     |")
   (format t "~%|             0 - Sair                |")
   (format t "~%|_____________________________________|~%")  
  )
)

(defun escolher-modo ()
  "Função que pede ao utilizador para escolher um modo"
  (format t "Escolha um modo: ")
  (let ((modo (read)))
    (cond 
     ((or (not (numberp modo)) (< modo 0) (> modo 2)) (format t "Modo Inválido ~%") (escolher-modo))
     (t modo)))
)

(defun escrever-estatisticas (no nos-analisados cortes tempo)
  "Função que escreve as estatisticas para uma ficheiro"
  (with-open-file (str (make-pathname :host "C" :directory '(:absolute "Users" "Home" "Desktop" "AI" "Projecto" "Fase2" "Fase_2") :name "log" :type "dat")
                     :direction :output
                     :IF-DOES-NOT-EXIST :create
                     :if-exists :append)
  (format str " Jogada: (~d - ~d) ~%~d ~% Nos Analisados: ~d ~% Cortes: ~d ~% Tempo Gasto: ~d ms ~%~% ----------------------------------- ~%~%" (fourth no) (fifth no) (mostrar-tabuleiro2 (tabuleiro no)) nos-analisados cortes tempo)
  )
)


(defun start ()
  "Função que inicia o jogo"
  (menu-inicial)
  (let ((escolha (escolher-modo)))
    (cond
     ((= escolha 0) nil)
     ((= escolha 1) (escolher-jogador-menu) (let* 
                        ((escolha2 (escolher-modo)) (tempo (escolher-tempo)))
                                              (cond 
                                               ((= escolha2 0) (start))
                                               ((= escolha2 1) (comecar-jogo-jogador-computador *tabuleiro* -1 tempo) (start))
                                               (t (comecar-jogo-jogador-computador *tabuleiro* 1 tempo) (start)))))
     (t (comecar-jogo-computador-computador *tabuleiro* 1 10) (start))))
)


(defun mostrar-tabuleiro2 (tabuleiro)
  "Função que coloca o tabuleiro de maneira percetível para o utilizador"
    (format nil " ~d ~% ~d ~% ~d ~% ~d ~%" (car tabuleiro) (cadr tabuleiro) (caddr tabuleiro) (cadddr tabuleiro))
)



