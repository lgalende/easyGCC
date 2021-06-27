# ecc (easy C)

El lenguaje ecc (easy C) nace a partir de un proyecto académico realizado para la materia **Autómatas, Teoría de Lenguajes y Compiladores**. El objetivo principal del lenguaje de programación ecc (easy C) es que facilite la introducción en la programación y también que permita entender código a personas sin conocimientos del tema. 

## Dependencias necesarias para generar el compilador
- gcc, yacc, lex, make

## Compilación del compilador
Pararse en el directorio raíz y ejecutar:
```sh
user@ubuntu:$ make all
```
Esto generará el binario del compilador *easygcc*

## Compilación de programas en lenguaje ecc
Para compilar un programa en ecc debe pasarse como primer argumento el path hacia el mismo. 

Por default, el ejecutable se llamará *program.out* y no se mantendrá el archivo .c intermedio:
```sh
user@ubuntu:$ ./easygcc [program_path] [OPTION]...
```
Donde OPTION pueden ser:
- -k : preserva el archivo .c temporal
- -o < filename > : modifica el nombre del ejecutable a *filename*

Además puede imprimirse la ayuda y versión del compilador de la siguiente forma:
```sh
user@ubuntu:$ ./easygcc OPTION
```
Donde OPTION pueden ser:
- -h : imprime la ayuda y termina
- -v : imprime la versión y termina

## Documentos
El informe del proyecto se encuentra en `documents/`

## Directorio de archivos
Dentro del directorio raíz se encuentran:
* `examples/`: se encuentra programas de ejemplos escritos en ecc
* `compiler/`: se encuentra todo lo referido a la implementación del compilador

## Autores

- **Lautaro Galende** <<lgalende@itba.edu.ar>>
- **Valentín Ratti** <<vratti@itba.edu.ar>>
- **Tommy Rosenblatt** <<trosenblatt@itba.edu.ar>>
- **Sebastián Itokazu** <<sitokazu@itba.edu.ar>>

