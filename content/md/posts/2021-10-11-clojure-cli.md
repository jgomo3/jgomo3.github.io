{:title "Clojure y Java"
 :layout :post
 :tags ["es" "Clojure" "Java"]}

Hasta ahora hemos visto cómo utilizar Clojure de forma muy
trivial. Para claridad me refreiré a esta forma como `clojure.main`.

Para programas más complejos, dividido en módulos, que dependan de
bibliotecas de terceros, que requieran «recursos», etc., puede ser muy
complicado preparar el entorno de ejecución para que el programa pueda
acceder a dichas elementos.

**clojure.org** pone a nuestra disposición unas herramientas que nos
permite utilizar Clojure de una forma más simple desde la línea de
órdenes, y organiza los elementos mencionados en el párrafo anterior
(en particular, construyen el Class Path por nosotros)

Estas herramientas se conocen como «Las herramientas para el
Intérprete de la Línea de Órdenes», a las cuales nos referiremos como
«Clojure CLI»

Hay varios métodos de instalación. Cada distribución de Sistema
Operativo muy posiblemente las tendrá a disposición con el nombre de
`clojure`.

Exploraremos aquí la manera de instalar estas herramientas
independientemente de la distribución de Sistema Operativo.

Estas herramientas necesitan:

 - bash
 - java
 - rlwrap (opcional)

En **clojure.org** hay un guión de instalación. Para el día de hoy, la
versión estable de Clojure es la versión `1.10.3.986`, así que
descargaremos el instalador de dicha versión y lo ejecutamos.

Si no indicamos nada, el instalador intentará instalar las
herramientas a nivel del sistema (`/usr/bin`, etc.). En ese caso,
habría que tener permisos para hacerlo (`sudo` por ejemplo).

Pero con la opción `--prefix` se puede indicar un destino
alternativo. Hagamos eso, instalemos en `~/clojure`

```bash
$ wget https://download.clojure.org/install/linux-install-1.10.3.986.sh
$ chmod linux-install-1.10.3.986.sh
$ ./linux-install-1.10.3.986.sh --prefix=~/clojure
...
Installing libs into /home/.../clojure/lib/clojure
Installing clojure and clj into /home/.../clojure/bin
Installing man pages into /home/.../clojure/share/man/man1
```

En la carpeta donde se instaló, las herramientas están en la
 subcarpeta `bin`: `clojure` y `clj`.

`clojure` es la herramienta principal, es una herramienta de línea de
órdenes para iniciar programas escritos en Clojure (el lenguaje).

`clj` es un simple envoltorio alrededor de `clojure` para hacer más
amena la interacción con el "REPL".

En la subcarpeta `share/man` se encuentra el manual en línea de estas
herramientas.

Entonces recomiendo indicarle al sistema la ubicación de estas
herramientas y sus manuales:

 - Añadiendo a la variable de entorno `PATH` la subcarpeta `bin`
 - Enseñándole a `man` cómo encontrar los manuales:
   - Si usas una distribución de Linux basada en Debian, añadiendo
     `MANDATORY_MANPATH` al archivo `.manpath` del «$HOME».
   - Añadiendo una entrada al MANPATH\_MAP que relacione la subcarpeta
     `bin` con la subcarpeta `share/man`.
 
En este caso de ejemplo, y suponiendo un sistema Ubuntu:
 
 ```bash
$ echo 'export PATH="$HOME/clojure/bin/:$PATH"' >> ~/.bashrc
$ echo 'MANDATORY_PATH home/ubuntu/clojure/share/man' >> ~/.manpath
```

Cuando utilizamos Clojure desde la consola, normalmente utilizamos
`clj` por ergonomía, y `clojure` en los guiones.

Las Clojure CLI están dirigidas por un archivo llamado `deps.edn`, que
merece su artículo completo.

Como las Clojure CLI son unos envoltorios alrededor de `clojure.main`,
todas las opciones del `clojure.main` están a nuestra
disposición. `-M` indica ejecutar `clojure.main`:

```Shell
$ clj -M -e '(+ 1 1)'
```

Además de ellas, hay opciones para controlar las
direcciones establecidas por el `deps.edn`.

Creo que debo detener el artículo aquí. Mi intención era establecer un
puente entre las Clojure CLI y el `clojure.main`.
