{:title "¡Por fin entiendo lazy-seq!"
 :layout :post
 :tags ["es" "Clojure" "lazy" "evaluación perezosa" "lazy-seq" "seq" "Python" "generadores" "generators"]
 :author "Jesús Gómez"}

`lazy-seq` es una de esas funciones que no he tenido que utilizar
mucho.

La explicación que le doy a ese fenómeno es que la biblioteca estándar
nos ofrece una colección de funciones superiores que, usando
`lazy-seq` en el fondo, me ha permitido resolver todos los problemas
en los cuales dicha función es pertinente para la solución.

Esta colección de funciones que menciono contiene por ejemplo a `map`
y `reduce`.

Nunca había entendido bien cómo utilizarlo. Y tal vez por la falta de
necesidad práctica, no me había propuesto a quitarme esa duda.

Hasta hoy (o bueno, hasta hace un par de días).

En la literatura, cuando nos presentan `lazy-seq`, el ejemplo clásico
es este:

```clojure
(defn números-desde [n]
	(lazy-seq (cons n (números-desde (inc n)))))

(take 3 (números-desde 1)) ;; (1 2 3)
```

Todos los ejemplos que he visto implican una llamada recursiva.

Algo que entiendo ahora es que si bien, para efectos prácticos,
`lazy-seq` viene casi siempre acompañada de una definición recursiva,
esto en realidad no es necesario.

Otro bloque mental que yo tenía es que me esperaba algo parecido a los
generadores de Python.

Un generador en Python, es una expresión similar a la definición de
una función, que determina cómo generar un valor y entregarlo bajo
demanda y tal vez generar y entregar más valores de la misma manera.

Pero al ver el ejemplo canónico del uso de `lazy-seq`, es difícil
encontrar una regla clara y general de cómo y donde expresar ese
«nuevo valor». En el ejemplo, el valor nuevo lo genera es la misma
`n`, y el siguiente se genera con `(inc n)`.

La razón de tal confusión es que `lazy-seq` no es lo mismo que un
generador en Python.

# (def lazy-seq ...)

`lazy-seq` es simplemente un «macro» que recibe una (1)
expresión. Dicha expresión debe ser una secuencia, una colección o
`nil`[1]. Luego retorna un objeto que tiene esa expresión
«latente». Ese objeto es un `LazySeq`.

El objeto `LazySeq` reacciona cuando se invoca la función `seq` con él
como argumento, y sólo entonces es que Clojure evalúa la expresión,
para así obtener la secuencia deseada.

Así de claro estaba en la mismísima documentación de `lazy-seq`.

> Traducción al español de la documentación en inglés de `lazy-seq`:
>
> «Recibe un cuerpo de expresiones que devuelven un ISeq o nil, y
> entrega un objeto "Secuenciable" que invocará el cuerpo sólo la
> primera vez que seq sea llamada, y recordará en "caché" el resultado
> y lo devolverá en todas las llamadas subsecuentes a seq. Ver
> también - realized?»

[1] Técnicamente una `ISeq` o `nil`

# Realización

La clave para mi fue entender que los que recibe `lazy-seq` es una
expresión para definir una secuencia completa. No es un «paso a paso»
de cómo generar uno a uno los elementos.

Es decir, esta expresión es válida:

```clojure
(lazy-seq [1 2 3 4 5 6])
```

Como es un macro, la expresión queda pendiente, hasta el momento que
algo quiera evaluarlo.

Es decir, ese vector no existe hasta que sea necesario.

Fíjense que no hay una expresión recursiva, no es necesario.


# Nemotécnico

Para recordar todo esto, lo que hago ahora es leer `lazy-seq` como
algo indicando que transforme la secuencia dada en una secuencia
«lazy».

De ahora en adelante, no voy a olvidar cómo usar `lazy-seq`, aunque
tal vez no lo vuelva a utilizar mucho.
