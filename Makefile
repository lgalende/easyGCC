all:
	cd compiler; \
	yacc -d parser.y; \
	lex scanner.l; \
	gcc -o ../easygcc y.tab.c lex.yy.c node.c operations.c comparations.c variables.c compiler.c

clean:
	rm -f easygcc; \
	cd compiler; \
	rm -f lex.yy.c; \
	rm -f y.tab.c; \
	rm -f y.tab.h;