{:title "Clojure CLI"
 :layout :post
 :author "Jesús Gómez"
 :tags ["es" "Clojure" "Java" "Clojure CLI" "CLI"]}

En el artículo [Clojure el Jar](https://jgomo3.info/posts-output/2021-10-09-clojure-el-jar/)
exploré cómo utilizar `clojure.main` de forma «primitiva».

Para programas más complejos, dividido en módulos, que dependan de
bibliotecas de terceros, que requieran «recursos», etc., puede ser muy
complicado preparar el entorno de ejecución para que el programa pueda
acceder a dichas elementos.

[clojure.org](https://clojure.org/) pone a nuestra disposición unas
herramientas que nos permite programar en Clojure de una forma más
simple desde la línea de órdenes.

Estas herramientas se conocen como «Interfaz de Línea de órdenes de
Clojure» a la cual me referiré como *Clojure CLI*.

# Instalación

Hay varios métodos de instalación. Cada distribución de Sistema
Operativo muy posiblemente las tendrá a disposición con el nombre de
`clojure`.

Exploraremos aquí la manera de instalar *Clojure CLI*
independientemente de la distribución de Sistema Operativo.

*Clojure CLI* necesita:

 - bash
 - java
 - rlwrap (opcional)

En [clojure.org](https://clojure.org) hay un *«script»* de
instalación.

Para el día de hoy, la versión estable de Clojure es la versión
`1.10.3.986`. Así que descargaremos el instalador de dicha versión y
lo ejecutamos.

Si no indicamos nada, el *«script»* intentará instalar *Clojure CLI* a
nivel del sistema (`/usr/bin`, etc.). En ese caso, habría que tener
permisos para hacerlo (`sudo` por ejemplo).

Pero con la opción `--prefix` podemos indicar un destino
alternativo. Hagamos eso, instalemos *Clojure CLI* en `~/clojure`.

```bash
$ wget https://download.clojure.org/install/linux-install-1.10.3.986.sh
$ chmod +x linux-install-1.10.3.986.sh
$ ./linux-install-1.10.3.986.sh --prefix ~/clojure
...
Installing libs into /home/.../clojure/lib/clojure
Installing clojure and clj into /home/.../clojure/bin
Installing man pages into /home/.../clojure/share/man/man1
```

Una vez instalado, *Clojure CLI* queda en la subcarpeta `bin`:
`clojure` y `clj`.

`clojure` es la interfaz principal. Es una herramienta de línea de
órdenes para iniciar programas escritos en Clojure (el lenguaje).

`clj` es un simple envoltorio alrededor de `clojure` para hacer más
amena la interacción con el *«REPL»* ([Read Eval Print Loop](https://clojure.org/guides/learn/syntax#_repl)).

En la subcarpeta `share/man` se encuentra el manual en línea de estas
herramientas.

Recomiendo [enseñarle al sistema cómo conseguir los ejecutables y el manual de Clojure CLI](#enseñarle-al-sistema-cómo-conseguir-los-ejecutables-y-el-manual-de-clojure-cli).

# Uso

Cuando utilizamos Clojure desde la consola, normalmente utilizamos
`clj` por ergonomía, y `clojure` en los *«scripts»*.

En cualquier caso, escribir simplemente la orden inicia un REPL
interactivo de Clojure:

```shell
$ clj
[ . . . ]
Clojure 1.10.3
user=> (+ 1 1)
2
```

# Clojure CLI y clojure.jar

Dejé marcado con puntos suspensivos `[ . . . ]` un contenido que puede
que haya salido o no dependiendo de si es la primera vez que se
ejecuta la orden o no.

La primera vez que invocamos `clj` o `clojure`, Clojure CLI procede a
descargar al mismísimo Clojure y otros paquetes básicos.

Esta es la imagen completa de lo que sucedería:

```shell
$ clj
Downloading: org/clojure/clojure/1.10.3/clojure-1.10.3.pom from central
Downloading: org/clojure/spec.alpha/0.2.194/spec.alpha-0.2.194.pom from central
Downloading: org/clojure/core.specs.alpha/0.2.56/core.specs.alpha-0.2.56.pom from central
Downloading: org/clojure/pom.contrib/0.3.0/pom.contrib-0.3.0.pom from central
Downloading: org/clojure/spec.alpha/0.2.194/spec.alpha-0.2.194.jar from central
Downloading: org/clojure/core.specs.alpha/0.2.56/core.specs.alpha-0.2.56.jar from central
Downloading: org/clojure/clojure/1.10.3/clojure-1.10.3.jar from central
Clojure 1.10.3
user=>
```

En este caso, lo mínimo necesario para utilizar Clojure son los
paquetes `clojure`, `spec.alpha` y `core.specs.alpha`.

En el artículo anterior [Clojure el Jar](https://jgomo3.info/posts-output/2021-10-09-clojure-el-jar)
, habíamos creado a mano un único `jar` llamado `clojure.jar`.
En ese caso, ese `jar` tenía incluido a los demás.

Como *Clojure CLI* es, entre otras cosas, un envoltorio alrededor de
`clojure.main`, todas las opciones del `clojure.main` están a nuestra
disposición.

Con `-M` tenemos acceso directo a `clojure.main`:

```Shell
$ clj -M -e '(+ 1 1)'
```

*«Clojure CLI»* está dirigido por un archivo llamado `deps.edn`.

Además `-M`, hay opciones para controlar las direcciones establecidas
por el `deps.edn`.

Para ver qué opciones soporta *Clojure CLI*, utiliza la opción `-h`.

Algo interesante es comparar el texto de ayuda de *Clojure CLI* con el
texto de ayuda de `clojure.main`. Al hacerlo, te darás cuenta que un
texto está incluido en el otro. Inténtalo:

```Shell
$ clj -h
$ clj -M -h
```

Dejo el artículo hasta aquí porque mi intención no es escribir un
manual de *Clojure CLI*, sino más bien señalar y exponer la relación
que existe entre ella y el `clojure.jar`.

Para saber cómo utilizar bien *Clojure CLI*, lee al menos la guía
[Deps and CLI Guide](https://clojure.org/guides/deps_and_cli).

En un próximo artículo exploraré cómo crear un archivo `jar` a partir
de un programa escrito en Clojure.

# Apéndice

## Enseñarle al sistema cómo conseguir los ejecutables y el manual de Clojure CLI

Para que el sistema consiga fácilmente Los *«scripts» `clojure` y
`cli` añade a la variable de entorno `PATH` la subcarpeta `bin`.

Para que el manual en línea `man` encuentre los manuales de `clojure`
y `cli`, hay que añadir información acerca de la subcarpeta
`share/man` en diferentes lugares, dependiendo del sistema que uses.

Si usas una distribución de Linux basada en Debian, añade
`MANDATORY_MANPATH` al archivo `.manpath` del «$HOME».

En caso contrario, añade una entrada al `MANPATH\_MAP` que relacione la
subcarpeta `bin` con la subcarpeta `share/man`.

En este caso de ejemplo, y suponiendo un sistema *Ubuntu*:
 
 ```bash
$ echo 'export PATH="$HOME/clojure/bin/:$PATH"' >> ~/.bashrc
$ echo 'MANDATORY_PATH home/ubuntu/clojure/share/man' >> ~/.manpath
```
