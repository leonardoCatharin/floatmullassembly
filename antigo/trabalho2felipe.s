.section .data

#25-02-2016

mensagem_begin: .asciz "\nPrograma Iniciado: Multiplicação de duas matrizes\n"

mensagem_valor_m: .asciz "\nDigite o valor de M: "
mensagem_valor_n: .asciz "\nDigite o valor de N: "
mensagem_valor_p: .asciz "\nDigite o valor de P: "
mensagem_matriz_a: .asciz "\nMatriz A: (%d x %d)\n"
mensagem_matriz_b: .asciz "Matriz B: (%d x %d)\n"

mensagem_matriz_preenchida_a: .asciz "\nMatriz preenchida (A)\n"
mensagem_matriz_preenchida_b: .asciz "\nMatriz preenchida (B)\n"
mensagem_matriz_preenchida_c: .asciz "\nMatriz preenchida (C)\n"

mostra_elemento: .asciz "%.2lf\t"
mostra_elemento2: .asciz "%d\t"

mensagem_elemento_a: .asciz "\nElemento [%d][%d] (A): " 
mensagem_elemento_b: .asciz "\nElemento [%d][%d] (B): "

quebra_linha: .asciz "\n"
tabulacaoarquivo: .asciz "\t"

matriz_a: .space 1800
	tam_matriz_a: .int 0
	constante_salto: .int 0
matriz_b: .space 1800
	tam_matriz_b: .int 0
	salto_matriz_b: .int 0
matriz_c: .space 1800
	tam_matriz_c: .int 0
	acumulador: .double 0
	
SYS_EXIT: .int 1
SYS_FORK: .int 2
SYS_READ: .int 3
SYS_WRITE: .int 4
SYS_OPEN: .int 5
SYS_CLOSE: .int 6
SYS_CREATE: .int 8

STD_OUT: .int 1
STD_IN: .int 2

SAIDA_NORMAL: .int 0 #codigo de saida bem sucedida

O_RDOONLY: .int 0x0000 # somente leitura
O_WRONLY:  .int 0x0001 # somente escrita
O_RDWR:    .int 0x0002 # leitura e escrita
O_CREAT:   .int 0x0040 # cria o arquivo na abertura, caso ele não exista
O_EXCL:    .int 0x0080 # força a criação
O_APPEND:  .int 0x0400 # adiciona n final do arquivo
O_TRUNC:   .int 0x0200 # reseta o arquivo (tamanho fica com zero)

S_IRWXU:   .int 0x01C0 # user has read, write and execute permission
S_IRUSR:   .int 0x0100 # user has read permission
S_IWUSR:   .int 0x0080 # user has write permission

valor_m: .int 0
valor_n: .int 0
valor_p: .int 0

num_aux: .space 8 #usado para repassar o valor no preenchimento das matrizes
lixo:    .space 8 #usado para repassar o valor no preenchimento das matrizes

formato1: .asciz "%lf"
formato2: .asciz "%d"
formato3: .asciz "%s"

#comeco variaveis de arquivo 
pedearqmatrizA: .ascii "\nEntre com o nome do arquivo da Matriz A\n"
fimpedearqmatrizA:
pedearqmatrizB: .ascii "\nEntre com o nome do arquivo da Matriz B\n"
fimpedearqmatrizB:

pedearqout: .ascii "\nEntre com o nome do arquivo de saida\n>"
fimpedearqout:
strarqout: .ascii "\n"
fimstrarqout:

	.equ tampedearqout, fimpedearqout-pedearqout
	.equ tamstrarqout, fimstrarqout-strarqout
	.equ tampedearqmatrizA, fimpedearqmatrizA-pedearqmatrizA
	.equ tampedearqmatrizB, fimpedearqmatrizB-pedearqmatrizB
	
mostratam: .asciz "\n\nConverter a entrada valida: %d\n"
mostranomearq: .asciz "\nNome do arquivo: %s\n"	
valorarqout: .int 0
nomearqout: .int 0
controle:   .int 0
controleLaco: .int 0
enter:      .byte 10
return:     .byte 13
NULL:       .byte 0
espaco:     .byte ''
pulalin:    .asciz "\n"
ponteiro:  .asciz  ""
valor:     .double 0
nomearqmatrizA: .space 50
nomearqmatrizB: .space 50
tamstrarqmatrizA: .int 1
tamstrarqmatrizB: .int 1
#fim variaveis de arquivo

.section .bss
 .lcomm strarqmatrizA, 1
 .lcomm strarqmatrizB, 1
 
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
	

lenomearqmatrizA:
	movl SYS_WRITE, %eax
	movl STD_OUT, %ebx
	movl $pedearqmatrizA, %ecx
	movl $tampedearqmatrizA, %edx
	int $0x80

	movl SYS_READ, %eax
	movl STD_IN, %ebx
	movl $nomearqmatrizA, %ecx
	movl $50, %edx # le inclusive o enter
	int $0x80

	movl $nomearqmatrizA, %edi
	
tratanomearqmatrizA:

	pushl %edi #empilha a posicao inicial da string do nome
#	movl $-1, %ebx

voltaarqmatrizA:
	addl $1, %ebx
	movb (%edi), %al
	cmpb enter, %al
	jz concluinomearqmatrizA
	cmpb espaco, %al
	jz concluinomearqmatrizA
	addl $1, %edi
	jmp voltaarqmatrizA
	
concluinomearqmatrizA:
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
	
			
abrirarquivomatrizA:
	movl SYS_OPEN, %eax
	movl $nomearqmatrizA, %ebx
	movl O_RDOONLY, %ecx
	int $0x80
	
	pushl %eax
	movl %eax, %ebx
	
	movl $0, %edx
	movl $matriz_a, %edi
	movl tam_matriz_a, %ecx

	jmp realizaleituramatrizA
	
incrementa_indice_matriz_a:
	incl %edx
	movl $1, %ebx	
	
realizaleituramatrizA:
	cmpl valor_n, %edx
	jg incrementa_indice_matriz_a
	
	pushl %ecx
	pushl %edx
	
	movl SYS_READ, %eax
	movl $strarqmatrizA, %ecx
	movl tamstrarqmatrizA, %edx
	int $0x80
	
	pushl $strarqmatrizA
	call printf
	addl $4, %esp
	
	popl %edx    			
	
	cmpl espaco, %ecx             
	jne concatenavalormatrizA 
	
	cmpl enter, %ecx         
	jne concatenavalormatrizA 
	
	movl $strarqmatrizA, %esi 
	
	jmp determinarstringUtil
	
	call convertervalorMatrizA 
	
	popl %ecx
	
	jmp realizaleituramatrizA
	
	jmp calculaQtdeElementosB 
	
concatenavalormatrizA:
	movl $strarqmatrizA, %edi
	addl $1, %edi
	jmp realizaleituramatrizA
	
determinarstringUtil:
	movl $-1, %ebx
	
voltastring:
	addl $1, %ebx
	movb (%edi), %al
	cmpb enter, %al
	jz concluistring
	cmpb espaco, %al
	jz concluistring
	addl $1, %edi
	jmp voltastring
	
concluistring:
	movb NULL, %al
	movb %al, (%edi)
	
convertervalorMatrizA:
	finit
	subl $8, %esp
	pushl %esi
	call atof
	fstl valor
	fstpl (%edi)
	movl %edi, matriz_a
	addl $8, %edi
	ret
	
fechararquivomatrizA:
	#fecharaquivo
	
#incrementa_indice_matriz_a:
#	incl %edx
#	movl $1, %ebx

#escritaA:
#	cmpl valor_n, %ebx
#	jg incrementa_indice_matriz_a
#
# 	pushl %edi
#	pushl %ecx 		
#	pushl %ebx
#	pushl %edx 	
#	pushl $mensagem_elemento_a
#	call printf
#	pushl $num_aux
#	pushl $formato1
#	call scanf		
#	addl $12,%esp
#
#	fldl num_aux			
#
#	popl %edx
#	popl %ebx
#	incl %ebx
#
#	popl %ecx
#	popl %edi	
#	
#	fstpl (%edi)
#
#	addl $8, %edi
#	loop escritaA

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
	
	jmp escritaB

incrementa_indice_matriz_b:
	incl %edx
	movl $1, %ebx

escritaB:	
	cmpl valor_p, %ebx
	jg incrementa_indice_matriz_b

 	pushl %edi
	pushl %ecx 		
	pushl %ebx
	pushl %edx
		
	pushl $mensagem_elemento_b
	call printf
	pushl $num_aux
	pushl $formato1
	call scanf	
	addl $12,%esp

	fldl num_aux

	popl %edx
	popl %ebx
	incl %ebx

	popl %ecx
	popl %edi	
	
	fstpl (%edi)

	addl $8, %edi
	loop escritaB

mostravetA:
	popl %edi #função auxiliar para mostrar matriz A - não essencial
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
	popl %edi #função auxiliar para mostrar matriz B - não essencial
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

lenomearqout:
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
	call tratanomearq
	jmp escrevearqout
	
tratanomearq:
	pushl %edi #empilha a posicao inicial da string do nome
	movl $-1, %ebx

volta3:
	addl $1, %ebx
	movb (%edi), %al
	cmpb enter, %al
	jz concluinomearq
	cmpb espaco, %al
	jz concluinomearq
	addl $1, %edi
	jmp volta3

concluinomearq:
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
	
escrevearqout:
	movl SYS_OPEN, %eax
	movl $nomearqout, %ebx
	movl O_WRONLY, %ecx
	orl O_CREAT, %ecx
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
	movl $4, %edx
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
