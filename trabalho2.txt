.section .data

#02-03-2016

mensagem_begin:    		.asciz "\nPrograma Iniciado: Multiplicação de duas matrizes\n"
mensagem_valor_m:  		.asciz "\nDigite o valor de M: "
mensagem_valor_n:  		.asciz "\nDigite o valor de N: "
mensagem_valor_p:  		.asciz "\nDigite o valor de P: "
mensagem_matriz_a: 		.asciz "\nMatriz A: (%d x %d)\n"
mensagem_matriz_b:     		.asciz "Matriz B: (%d x %d)\n"
sucesso_multiplicacao: 		.asciz "\nA multiplicação foi realizada com sucesso!\n"
mensagem_matriz_preenchida_a: 	.asciz "\nMatriz preenchida (A)\n"
mensagem_matriz_preenchida_b: 	.asciz "\nMatriz preenchida (B)\n"
mensagem_matriz_preenchida_c: 	.asciz "\nMatriz preenchida (C)\n"

mostra_elemento: 	.asciz 	"%lf\t"
mostra_elemento2: 	.asciz 	"%d\t"
quebra_linha: 		.asciz "\n"

formato1: 		.asciz "%lf"
formato2: 		.asciz "%d"

NomeArquivoEntrada: .space 50

nomearqout: 	.double 0
valor: 		.double 0

valor_m: 	.int	0
valor_n: 	.int 	0
valor_p: 	.int 	0

matriz_a: .space 1800
	tam_matriz_a: 	 .int 0
	constante_salto: .int 0

matriz_b: .space 1800
	tam_matriz_b: 	.int 0
	salto_matriz_b: .int 0

matriz_c: .space 1800
	tam_matriz_c: .int 0

lixo:    .space 8 #lixo retirado do topo da PFU

arqEntrda:	.asciz	"mab.txt"


outvid:    .ascii "\nMsg teste impressa no video usando chamada write()\n"
fimoutvid:

pedealgo:  .ascii "\nDigite algo pelo teclado: "
fimpedealgo:

strarqout: .ascii "\n"
fimstrarqout:

pedeNomeArquivoEntrada: 	.ascii "\nEntre com o nome do arquivo de entrada\n> "
fimPedeNomeArquivoEntrada:

pedearqout: 	.ascii "\nEntre com o nome do arquivo de saida\n> "
fimpedearqout:

mostrain: 	.ascii "\nEntrada Original em Caracteres Suja = "
fimmostrain:

mostrainlimpa:  .ascii "\nEntrada Original em Caracteres Limpa = "
fimmostrainlimpa:

buffer: 	.ascii "12345678901234567890123456789012345678901234567890"
fimbuffer: 

mostratam: 	.asciz "\n\nTamanho da Entrada Valida: %d\n"
mostranomearq:  .asciz "\nNome do Arquivo: %s\n"

nomeArquivoEntrada: .ascii "";


msgfim: 	.asciz "\nAll is done!"
			.equ tamoutvid, fimoutvid-outvid
			.equ tamstrarqout, fimstrarqout-strarqout
			.equ tampedearqout, fimpedearqout-pedearqout
			.equ tampedealgo, fimpedealgo-pedealgo
			.equ tambuffer, fimbuffer-buffer
			.equ tammostrain, fimmostrain-mostrain
			.equ tammostrainlimpa, fimmostrainlimpa-mostrainlimpa
			.equ tamPedeNomeArquivoEntrada, fimPedeNomeArquivoEntrada-pedeNomeArquivoEntrada

STD_OUT: .int 1
STD_IN:  .int 2

SYS_EXIT:   	.int 1
SYS_FORK:   	.int 2
SYS_READ:   	.int 3
SYS_WRITE:  	.int 4
SYS_OPEN:   	.int 5
SYS_CLOSE:  	.int 6
SYS_CREATE: 	.int 8


O_RDONLY: 	.int 0x0000
O_WRONLY: 	.int 0x0001
O_RDWR:	  	.int 0x0002
O_CREATE: 	.int 0x0040
O_EXCL:   	.int 0x0080
O_APPEND: 	.int 0x0400
O_TRUNC:  	.int 0x0200

S_IRWXU:	.int 0x01C0
S_IRUSR:	.int 0x0100
S_IWUSR:	.int 0x0080
S_IXUSR:	.int 0x0040
S_IRWXG:	.int 0x0038
S_IRGRP:	.int 0x0020
S_IWGRP:	.int 0x0010
S_IXGRP:	.int 0x0008
S_IRWXO:	.int 0x0007
S_IROTH:	.int 0x0004
S_IWOTH:	.int 0x0002
S_IXOTH:	.int 0x0001
S_NADA:		.int 0x0000


contLinha:	  .space 20
valorAsc:         .space 10
enter: 		  .byte 10
NULL: 		  .byte 0
espaco: 	  .byte ' '
formato: 	  .asciz "%d"
pulalin: 	  .asciz "\n"
tabulacaoarquivo: .asciz "\t"
ponteiro:  	  .asciz  ""


.section .text

.globl _start

_start:
	pushl $mensagem_begin
	call printf

levalorM:
	pushl $mensagem_valor_m
	call printf
	pushl $valor_m
	pushl $formato2
	call  scanf

	movl valor_m, %ecx #validação >0
	cmpl $0, %ecx
	jle levalorM

levalorN:
	pushl $mensagem_valor_n
	call printf
	pushl $valor_n
	pushl $formato2
	call  scanf

	movl valor_n, %ecx
	cmpl $0, %ecx
	jle levalorN

levalorP:
	pushl $mensagem_valor_p
	call printf
	pushl $valor_p
	pushl $formato2
	call  scanf

	movl valor_p, %ecx
	cmpl $0, %ecx
	jle levalorP

mostra_ordem_matrizes:	
	pushl valor_n	
	pushl valor_m
	pushl $mensagem_matriz_a
	call printf
		
	pushl valor_p
	pushl valor_n
	pushl $mensagem_matriz_b
	call printf

calcula_constante_salto:
	movl valor_n, %eax #calcula constante para saltar de uma linha para outra
	movl $8, %ebx
	mull %ebx
	movl $constante_salto, %ebx
	addl %eax, (%ebx)

calcula_salto_matriz_b:
	movl valor_p, %eax #calcula salto do elemento [i1][j1] para o elemento [i2][j1] (2º elemento está abaixo do primeiro na matriz)
	movl $8, %ebx
	mull %ebx
	movl $salto_matriz_b, %edx
	movl %eax, (%edx)

calculaQtdeElementosA:
	addl $16, %esp #volta o ponteiro da pilha para o início
	movl $0, %ebx #limpeza dos registradores
	movl $0, %eax
	movl $0, %ecx
	movl $0, %edi

	movl valor_m, %eax
	movl valor_n, %ebx
	mull %ebx
	movl $tam_matriz_a, %edx
	movl %eax, (%edx)
	movl %eax,%ecx	
	movl $0, %eax
	addl $16,%esp
		
	movl $matriz_a, %edi
	movl $1, %ebx
	movl $1, %edx
	
calculaQtdeElementosB:
	addl $16, %esp	
	movl $0, %ebx
	movl $0, %eax
	movl $0, %ecx
	movl $0, %edi

	movl valor_n, %eax
	movl valor_p, %ebx
	mull %ebx
	movl $tam_matriz_b, %edx
	movl %eax, (%edx)
	movl %eax,%ecx	
	movl $0, %eax
	addl $16,%esp
		
	movl $matriz_b, %edi
	movl $1, %ebx
	movl $1, %edx
	
alocaNomeArquivoEntrada:
	pushl $50
	call malloc
	movl %eax, nomeArquivoEntrada
	addl $4, %esp
	
leituraNomeArquivoEntrada:
	movl SYS_WRITE, %eax
	movl STD_OUT, %ebx
	movl $pedeNomeArquivoEntrada, %ecx
	movl $tamPedeNomeArquivoEntrada, %edx
	int $0x80

	movl SYS_READ, %eax
	movl STD_IN, %ebx
	movl $NomeArquivoEntrada, %ecx
	movl $50, %edx # le inclusive o enter
	int $0x80

	movl $NomeArquivoEntrada, %edi
	call tratamentoNomeArquivoEntrada
	jmp leArquivo
	
tratamentoNomeArquivoEntrada:
	pushl %edi #empilha a posicao inicial da string do nome
	movl $-1, %ebx

retornoTratamentoEntrada:
	addl $1, %ebx
	movb (%edi), %al
	cmpb enter, %al
	jz finalizaNomeArquivoSaida
	cmpb espaco, %al
	jz finalizaNomeArquivoSaida
	addl $1, %edi
	jmp retornoTratamentoEntrada

finalizaNomeArquivoEntrada:
	pushl %edi #empilha a posicao do caracter enter/espaco
	pushl %ebx
	pushl $mostratam
	call printf
	addl $8, %esp

	popl %edi
	movb NULL, %al
	movb %al, (%edi)

	pushl $mostranomearq
	call printf
	addl $8, %esp

	pushl $pulalin
	call printf
	addl $4, %esp

	ret

leArquivo:
	movl SYS_OPEN, %eax
	movl $NomeArquivoEntrada, %ebx
	movl O_RDONLY, %ecx
	int  $0x80

  	movl tam_matriz_a,%ecx
 	movl	$matriz_a, %edi

leNum:
	push %ecx                 
	movl $valorAsc,%esi

leitura:
  	push %eax                 
  	push %esi                 
	movl %eax, %ebx
	movl $3, %eax
	movl $contLinha, %ecx
	movl $1, %edx

	int  $0x80
	pop %esi

	movb contLinha, %al
	movb %al,(%esi)
	incl %esi
	pop %eax
	cmpb $0x0A, contLinha
	je continuacao_leitura1

continuacao_leitura:
  	cmpb $0x20, contLinha
	jne leitura

continuacao_leitura1:
	push %eax                 
	movb $0x00,(%esi)
  	push $valorAsc            
  	call atof
  	addl $4,%esp

	fstpl (%edi)
	addl $8, %edi

	pop %eax
	pop %ecx

  	loop leNum

  	pushl %eax
  	movl %eax, %ebx
  	movl $3, %eax
  	movl $contLinha, %ecx
  	movl $1, %edx

  	int $0x80

  	pop %eax

  	movl tam_matriz_b, %ecx
  	movl $matriz_b, %edi

leNumB:
  	push %ecx                 
  	movl $valorAsc,%esi

leituraB:
  	push %eax                 
  	push %esi                 
	movl %eax, %ebx
	movl $3, %eax
	movl $contLinha, %ecx
	movl $1, %edx

	int  $0x80
	pop %esi								  

  	movb contLinha, %al
	movb %al,(%esi)
	incl %esi
	pop %eax
	cmpb $0x0A, contLinha
	je continuacao_leitura1B

continuacao_leituraB:
	cmpb $0x20, contLinha
	jne leituraB

continuacao_leitura1B:
	push %eax                 
	movb $0x00,(%esi)
  	push $valorAsc            
  	call atof
  	addl $4,%esp

  	fstpl (%edi)
  	addl	$8, %edi

  	pop %eax
  	pop %ecx

  	loop leNumB

fimLeitura:
	movl SYS_CLOSE, %eax
	int  $0x80

mostravetA:
	popl %edi
	popl %ecx
	pushl $mensagem_matriz_preenchida_a
	call printf
	addl $4, %esp
	movl tam_matriz_a, %ecx
	movl $matriz_a, %edi

	movl $0, %edx
	jmp mostranumA

quebraLinhaA:
	pushl %ecx
	pushl $quebra_linha
	call printf
	addl $4, %esp
	movl $0, %edx
	popl %ecx

mostranumA:
	cmpl valor_n, %edx
	je quebraLinhaA

	pushl %edx
	pushl %edi
	pushl %ecx

	fldl (%edi) 	
	subl $8, %esp		
	fstpl (%esp)
	pushl $mostra_elemento
	call printf
	addl $12, %esp
	 	
	popl %ecx
	popl %edi
	addl $8, %edi	
	popl %edx
	incl %edx
	loop mostranumA

mostravetB:
	popl %edi
	popl %ecx
	pushl $mensagem_matriz_preenchida_b
	call printf
	addl $4, %esp
	movl tam_matriz_b, %ecx
	movl $matriz_b, %edi

	movl $0, %edx
	jmp mostranumB

quebraLinhaB:
	pushl %ecx
	pushl $quebra_linha
	call printf
	addl $4, %esp
	movl $0, %edx
	popl %ecx

mostranumB:
	cmpl valor_p, %edx
	je quebraLinhaB
	
	pushl %edx
	pushl %edi
	pushl %ecx
	
	fldl (%edi) 	
	subl $8, %esp		
	fstpl (%esp)
	pushl $mostra_elemento
	call printf
	addl $12, %esp

	popl %ecx
	popl %edi
	addl $8, %edi
	
	popl %edx
	incl %edx
	loop mostranumB

atribui_matrizes:
	movl $matriz_a, %edi
	movl $matriz_b, %esi
	movl $matriz_c, %ebp
	
	movl valor_m, %ecx #loop elemento linha
	fldz

loop_linha:
	pushl %ecx
	movl $0, %eax
	pushl %eax #salva registrador para o contador de colunas (&)

	movl valor_p, %ecx #loop coluna da matriz B

loop_coluna:
	pushl %ecx
	movl valor_n, %ecx #loop elementos

multiplicacao:
	pushl %ecx
	fldl (%edi) 
	fldl (%esi)		
	fmul %st(0), %st(1)
	fstpl lixo
	fadd %st(0), %st(1)
	fstpl lixo

	addl $8, %edi
	addl salto_matriz_b, %esi	
	popl %ecx
	loop multiplicacao

escritaC:
	fstpl (%ebp)
	addl $8, %ebp
	fldz	

retorno_loop_coluna:
	subl constante_salto, %edi #retorna registrador para o inicio da linha corrente na matriz A
	movl $matriz_b, %esi #retorna registrador para inicio da matriz B
	
	popl %ecx
	
	popl %eax #recupera valor para ir para a próxima coluna	(&)
	addl $8, %eax
	addl %eax, %esi
	pushl %eax	
	loop loop_coluna

retorno_loop_linha:
	movl $matriz_b, %esi

	popl %eax
	
	popl %ecx 	
	addl constante_salto, %edi
	loop loop_linha

calculaQtdeElementosC:
	movl $0, %ebx #limpeza dos registradores
	movl $0, %eax
	movl $0, %ecx

	movl valor_m, %eax
	movl valor_p, %ebx
	mull %ebx
	movl $tam_matriz_c, %edx
	movl %eax, (%edx)
	movl %eax,%ecx		
	movl $0, %eax	
	movl $matriz_c, %ebp
	movl $0, %ebx
	movl $0, %edx

mostravetC:
	popl %ecx
	pushl $mensagem_matriz_preenchida_c
	call printf
	addl $4, %esp
	movl tam_matriz_c, %ecx
	movl $matriz_c, %ebp
	movl $0, %edx

	jmp mostranumC
	
quebraLinhaC:
	pushl %ecx
	pushl $quebra_linha
	call printf
	addl $4, %esp
	movl $0, %edx
	popl %ecx

mostranumC:
	cmpl valor_p, %edx
	je quebraLinhaC

	pushl %edx
	pushl %ebp
	pushl %ecx

	fldl (%ebp) 	
	subl $8, %esp		
	fstpl (%esp)
	pushl $mostra_elemento
	call printf
	addl $12, %esp
	
	popl %ecx
	popl %ebp
	addl $8, %ebp
	popl %edx
	
	incl %edx

	loop mostranumC

	pushl $sucesso_multiplicacao
	call  printf
	addl $4, %esp


leituraNomeArquivoSaida:
	movl SYS_WRITE, %eax
	movl STD_OUT, %ebx
	movl $pedearqout, %ecx
	movl $tampedearqout, %edx
	int $0x80

	movl SYS_READ, %eax
	movl STD_IN, %ebx
	movl $nomearqout, %ecx
	movl $50, %edx # le inclusive o enter
	int $0x80

	movl $nomearqout, %edi
	call tratamentoNomeArquivoSaida
	jmp escritaNomeArquivoSaida
	
tratamentoNomeArquivoSaida:
	pushl %edi #empilha a posicao inicial da string do nome
	movl $-1, %ebx

retornoTratamento:
	addl $1, %ebx
	movb (%edi), %al
	cmpb enter, %al
	jz finalizaNomeArquivoSaida
	cmpb espaco, %al
	jz finalizaNomeArquivoSaida
	addl $1, %edi
	jmp retornoTratamento

finalizaNomeArquivoSaida:
	pushl %edi #empilha a posicao do caracter enter/espaco
	pushl %ebx
	pushl $mostratam
	call printf
	addl $8, %esp

	popl %edi
	movb NULL, %al
	movb %al, (%edi)

	pushl $mostranomearq
	call printf
	addl $8, %esp

	pushl $pulalin
	call printf
	addl $4, %esp

	ret
	
escritaNomeArquivoSaida:
	movl SYS_OPEN, %eax
	movl $nomearqout, %ebx
	movl O_WRONLY, %ecx
	orl O_CREATE, %ecx
	movl S_IRUSR, %edx
	orl S_IWUSR, %edx
	int $0x80
	
	pushl %eax #guarda o descritor
	
	movl %eax, %ebx
	movl $0, %edx
	movl tam_matriz_c, %ecx
	movl $matriz_c, %ebp
	call escrevematrizsaida
	
	movl SYS_CLOSE, %eax
	popl %ebx
	int $0x80
	
	jmp fim
	
quebraLinhamatrizSaida:
	pushl %ecx
	movl SYS_WRITE, %eax
	movl $strarqout, %ecx
	movl $tamstrarqout, %edx
	int $0x80
	popl %ecx
	movl $0, %edx
	
escrevematrizsaida:
	cmpl valor_p, %edx
	je quebraLinhamatrizSaida
	
	pushl %eax
	pushl %ebx
	pushl %edx
	pushl %ebp
	pushl %ecx
		
	finit
	fldl (%ebp)
	subl  $8, %esp
	fstpl (%esp)
	pushl $mostra_elemento
	pushl $ponteiro
	call  sprintf
	addl  $16, %esp
		
	movl SYS_WRITE, %eax
	movl $ponteiro, %ecx
	movl $8, %edx
	int $0x80

	movl SYS_WRITE, %eax
	movl $tabulacaoarquivo, %ecx
	movl $tamstrarqout, %edx
	int $0x80
		
	popl %ecx
	popl %ebp
	addl $8, %ebp
	popl %edx
	popl %ebx
	popl %eax
	
	incl %edx
	
	loop escrevematrizsaida
	
	ret
	
fim:
	pushl $quebra_linha
	call printf
	addl $32, %esp
	pushl $0
	call exit