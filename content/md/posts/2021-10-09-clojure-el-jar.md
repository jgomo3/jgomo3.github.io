{:title "Clojure el Jar"
 :layout :post
 :tags ["es" "Clojure" "Java" "jar"]
 :author "Jesús Gómez"}

Los clojuristas estamos acostumbrados a interactuar con Clojure con el
las órdenes `clojure` o `clj`.

Lo que para muchos puede ser algo desconocido es el hecho de que esos
comandos son en realidad unos *«scripts»* escritos en Bash, conocidos
como *«Clojure CLI»*, y que en realidad, Clojure es un programa
distribuido como un `.jar`.

Esta información es particularmente útil para entender por qué podemos
determinar la versión específica de Clojure como una dependencia de
nuestros proyectos de la misma manera que determinamos cualquier otro
paquete de terceros.

Esta es una de las flexibilidades de Clojure que pasa
desapercibido.

Si bien en otros lenguajes hay maneras para definir explícitamente en
nuestros proyectos qué versión de dichos lenguajes utilizar,
típicamente se hace de manera diferente a la que definimos las
versiones de los paquetes de terceros.

En este artículo quiero demostrar cómo trabajar con Clojure sin la
ayuda de «Clojure CLI».

# ¿Cómo obtener el jar?

Antes de empezar, debo explicar cómo obtener el paquete `.jar`.

Recuerda que utilizar el `.jar` directamente no es la forma cotidiana
de utilizar Clojure, y por ende, no existe una manera trivial de
obtenerlo.

Una manera de hacerlo es seguir las instrucciones de la guía de
iniciación («Getting Started») en la sección [«Otras maneras de correr
Clojure» («Other ways to run
Clojure»)](https://clojure.org/guides/getting_started#_other_ways_to_run_clojure).

La idea es clonar el repositorio de Clojure, y ejecutar la tarea de empaquetado.

En otras palabras:

```
git clone https://github.com/clojure/clojure.git
cd clojure
mvn -Plocal -Dmaven.test.skip=true package
```

El paquete `clojure.jar` generado tendrá todas las dependencias
necesarias para soportar todo el lenguaje.

# Ejecutar Clojure

Al ejecutar el `.jar` sin ningún argumento, una sesión interactiva con
el "REPL" inicia:

```shell
$ java -jar clojure.jar
```
```Clojure
Clojure 1.11.0-master-SNAPSHOT
user=> (+ 1 1)
2
```

Otra forma de interesante de invocar Clojure es incluyendo el paquete
`clojure.jar` explícitamente en el "Class Path" y ejecutar su "clase
principal".

```shell
$ java -cp clojure.jar clojure.main
Clojure 1.11.0-master-SNAPSHOT
user=> 
```

[¿Cómo supe que la clase principal era clojure.main?](#determinar-el-punto-de-entrada-de-clojurejar)

Al pasar un *«script»* como argumento, Clojure lo interpreta expresión
por expresión (evita la sesión interactiva con el "REPL").

Supongamos que tenemos un archivo llamado `hola.clj` con el siguiente
contenido:

```Clojure
(println "Hola Infinito")
```

Entonces la siguiente orden mostrará el Mensaje "Hola Infinito":

```Shell
$ java -jar clojure.jar hola.clj
Hola Infinito
$ 
```

Si en vez del nombre del *«script»*, colocas `-`, entonces Clojure
interpreta la entrada estándar como si fuera dicho *«script»*.

```Shell
$ echo '(println "Hola Infinito")' | java -jar clojure.jar -
Hola Infinito
```

La opción `-e` hace que Clojure evalúe la expresión determinada.

```Shell
$ java -jar clojure.jar -e '"Hola Infinito"'
Hola Infinito
```

> En este caso, no hizo falta utilizar la función `println`, porque `-e`
> no sólo evalúa la expresión dada, sino que su resultado lo coloca en
> la salida estándar.
> 
> Las comillas simples son para indicarle al «shell» que no trate de
> interpretar nada del contenido que encierran. De esta manera, podemos
> escribir las comillas dobles (`"`) con la seguridad de que serán
> recibidas por Clojure, en cuyo momento, representan el inicio y el
> final de una cadena de caracteres.

Puedes pedirle a Clojure que evalúe varias expresiones a la
vez. Producirá una línea por valor en la salida estándar:

```Shell
$ java -jar clojure.jar -e 1 -e 2 -e 3
1
2
3
```

Con la opción `-m`, Clojure llama la función `-main` del espacio de
nombre que especifiquemos.

Supongamos un archivo llamado `hola.clj` en la carpeta actual, con
este contenido:

```Clojure
(ns hola)

(defn -main [& args]
  (println "Hola Infinito"))
```

Entonces, esa función `-main` la podemos ejecutar de la siguiente manera:

```Shell
$ java -cp ".:clojure.jar" clojure.main -m hola
```

Nota que utilizamos la forma con el `-cp` en vez del `-jar`. Esto es
debido a que debemos colocar en el *"Class Path"* el directorio actual
(`.`) para que Clojure pueda conseguir nuestro archivo `hola.clj`.

# ¿Por qué hicimos esto?

Lo principal es entender que Clojure es simplemente un paquete como
cualquier otro y que las órdenes `clojure` y `clj` son herramientas
para trabajar con dicho paquete.

Entender esta diferencia nos puede ahorrar muchas confusiones.

En particular, a la hora de conversar, es importante distinguir de qué
estamos hablando: Clojure o *Clojure CLI*.

También nos permite utilizar cualquier conocimiento general del manejo
de archivos `.jar` para manipular `clojure.jar`, y estar claro en cuál
es su posición en el ecosistema Java.

Finalmente quise explorar qué podemos hacer con el paquete
`clojure.jar` independientemente de las herramientas. Porque me parece
que entender las funciones básicas de cualquier programa es vital para
aprovecharlo al máximo.

En un siguiente artículo exploraré *Clojure CLI* enfocándome en los
detalles donde su relación con Java se hace necesariamente explícita.

# Apéndice
## Determinar el punto de entrada de clojure.jar

La clase principal de un paquete ".jar" está definida en su
manifiesto (META-INF/MANIFEST.MF).

```shell
$ jar xf clojure.jar META-INF/MANIFEST.MF
$ grep Main-Class META-INF/MANIFEST.MF 
Main-Class: clojure.main
```
