{:title "Los mapas son funciones"
 :layout :post
 :tags ["es"]}
 
# Estructuras asociativas como funciones por extensión

Una función es una relación entre 2 conjuntos que cumple con ciertas
limitaciones, que pudiéramos resumirlas en la siguiente regla:

Si a un conjunto lo denominamos «dominio» y al otro «rango», entonces
a cada uno de los elementos del conjunto «dominio», le corresponde uno
y sólo unu elemento del conjunto «rango».

¿Propiodades? por montón.

Solemos visualizar las funciones con el diagrama de mapa, donde
agrupamos todos los elementos del dominio dentro de una figura,
agrupamos todos los elementos del rango en otra figura separada, y
trazamos una flecha desde cada elemento del dominio hasta su elemento
correspondiente en el rango.

<photo>

Este diagrama tiene sentido cuando los conjuntos son finitos y
manejables. Cuando podemos expresar todos los elementos de cada
conjunto. Hacer esto es lo que conocemos como «definición por
extensión».

Cuando no lo son, describimos propiedades de los elementos
del dominio y alguna regla para inferir el elemento que le corresponde
en el rango (fórmulas, computos, incluso texto).

Ejemplo:

 - f(x) = x + 1
 - { (x, x + 1) | x ∈ ℝ }
 - yo, ______ portador de la cédula _____, de ahora en adelante, el arrendatario ...
 
(En el último caso, el dominio es toda persona con cédula, y el rango
es el conjunto de roles que puede asumir cada una de esas personas en
un contrato; en este caso, sólo se revela el rol «arrendatario»).

A esto se lo conocemos como «definición por comprensión».

## Estructuras asociativas

En programación, una familia de estructuras de datos muy importante
son las estructuras asociativas. Dependiendo de sus antecedentes,
puede conocerlo como «diccionarios», «mapas», «mapas hash», «arreglos
asociativos», «objetos», etc.

Debido a que en este mismo contexto, el término «función» está bien
determinado y cumple un rol protagónico en nuestra disciplina; y por
otro lado, es «una cosa» diferente a las estructuras asociativas, no
solemos entender a las últimas como funciones.

Pero, una estructura asociativa es en efecto una función.

Las estructuras asociativas son colecciones de elementos a los cuales
les asignas un identificador, muchas veces denominado «llave» o
«clave». Exponen una **Interfaz de programación de aplicaciones** (o
**API** de sus siglas en inglés), con la que el programa puede
registrar elementos en la estructura asignándole una «clave», o
retirar elementos de la misma. Pero más importante y pertinente para
lo que he estado planteando, conocer el elemento asociado a una
«clave» determinada.

Ejemplos en diferentes lenguajes:

Conversación con el computador
```
Sea la Estructura_asociativa mi_colección
registra en mi colección el elemento 'e' con clave '△'
registra en mi_colección el elemento 'a' con clave '◯'
registra en mi colección el elemento 'i' con clave '□'
registra en mi colección el elemento 'e' con clave '☆'
¿Cuál es el valor del elemento identificado con la clave '△' en mi_colección?

Computador: e
```

Python and Ruby
```
# Registro
mi_colección = {}
mi_colección['△'] = 'e'
mi_colección['◯'] = 'a'
mi_colección['□'] = 'i'
mi_colección['☆'] = 'e'

# Consulta
mi_colección['e']

Computador: e
```

Clojure
```
(def mi_colección {})
(-> mi_colección
    (assoc '△' 'e')
    (assoc '◯' 'a')
    (assoc '□' 'i')
    (assoc '☆' 'e')
	(get '△'))

Computador: e
```

Cada vez que registramos un elemento con una clave, estamos en efecto
relacionandolos a ambos, tal cuál dibujáramos la flecha del diagrama
de una clave a un elemento. En particular, la colección «mi_colección»
del ejemplo **ES** la misma función que representamos en el primer
diagrama.

Es decir, que las estructuras asociativas son funciones definidas por
extensión.

Antes de continuar debo mencionar que los lenguajes de programación
por lo general cuentan con alguna expresión con la que podemos
describir por extensión las estructuras asociativas. He aquí la misma
estructura definida con estas expresiones:

Python
```
mi_colección = {
  '△' : 'e',
  '◯' : 'a',
  '□' : 'i',
  '☆' : 'e'
}
```

Clojure
```
(def mi_colección {'△' 'e'
                   '◯' 'a'
                   '□' 'i'
                   '☆' 'e'})
```
# Uso práctico
## Ruby

```
version_1_to_version_2 = {
  'banana' => 'cambur',
  'maracuyá' => 'parchita',
  'sandía' => 'patilla'
}

palabras.map(&version_1_to_version_2)
```

## Python
## Clojure
```
(mi_colección '△')
```

# Asides
## Las secuencias como funciones
(Por ser también estructuras asociativas)
