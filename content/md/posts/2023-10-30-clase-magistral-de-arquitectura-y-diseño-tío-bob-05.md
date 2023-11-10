{:title "Clase magistral de arquitectura y diseño (día 5) - Principio de Substitución de Liskov"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin" "principios" "psl" "principio de substitución de liskov" "solid"]}

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert
C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor
conocido como «El tío Bob»), ha impartido y estará impartiendo una
clase magistral dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.

# Día 5: El Principio de Substitución de Liskov (LSP)

## Tipos

### ¿Qué es un tipo?

Independientemente de la codificación de los operandos, mientras las
operaciones produzcan resultados consistentes, ahí tienes un tipo.

### ¿Que es un subtipo?

Una definición particular de «Subtipo» conocida como [«El Principio de
substitución de
Liskov»](https://es.wikipedia.org/wiki/Principio_de_sustituci%C3%B3n_de_Liskov)
dice que:

Dado los tipos **S** y **T**, y el programa **P** que usa **T**.

Si modificamos el programa **P** solamente haciendo que que use **S**
en vez de **T**, y este sigue funcionando igualmente, entonces **S**
es un subtipo de **T**.

## «Es un(a)» (ISA)

La Inteligencia Artificial fue un campo muy importante entre los 70's
y principios de los 80's. Durante ese período hubo un auge de
investigación en el campo.

Un área en particular eran **las redes de inferencia**: objetos
conectados por relaciones de inferencia (como «huele a», «sabe a», «es
un(a)», «tiene un((os), a(s))», etc.). Las relaciones «es un(a)», que
en inglés sería «is a» se escribían en los artículos y diagramas como
«ISA».

Una vez la Inteligencia Artificial perdió empuje en la industria y en
la academia, muchos de los investigadores de esa área consiguieron
refugio en la gran ola del momento (mediados de los 80s y los 90s): La
programación orientada a objetos.

Ahí encontraron que el concepto de «herencia» era muy similar a la
relación «ISA» de las redes de inferencia, y desde entonces ha sido
muy normal utilizar ambos términos como lo mismo. Sin embargo, veremos
que no son exactamente iguales y por ende ha causado bastante
confusión.

![img](/img/polimorfismo.svg)

## El problema del Cuadrado y el Rectángulo

Considere el siguiente diagrama de clases, que describe las clases
«Rectángulo», «Cuadrado» y «Usuario».

![img](/img/el-problema-del-cuadrado-y-el-rectángulo.svg)

En el programa «Usuario», si substituimos un Rectángulo por un
Cuadrado, al invocar establecer_anchura(48) (por ejemplo) ¿Qué debería
pasar con la altura?.

¿Modificamos la altura automáticamente?¿O el objeto pierde su tipo
«cuadrado» y se convierte en rectángulo?.

Esta modificación puede causar problemas para el programa **Usuario**
si este no se lo esperaba. En ese caso, decimos que el «Cuadrado» no
puede substituir a un «Rectángulo».

El ejemplo fue elegido adrede porque lógicamente todo cuadrado es un
rectángulo y por ende deberíamos poder cambiar uno por otro sin
problemas.

Pero la clase Cuadrado y la clase Rectángulo son solo representantes,
no son realmente cuadrados ni rectángulos. Si en el programa cambias
todas las apariciones de la palabra «Cuadrado» por «XXXX» y todas las
apariciones de la palabra «Rectángulo» por «YYYY», el programa seguirá
funcionando igualmente. Viéndolo de ese modo, puede entenderse sin
ninguna dificultad si la substitución es posible o causa problemas.

**Nota** La regla del representante:

Los representantes de cosas no comparten las relaciones entre las
cosas que representan.

Esta violación del principio de substitución de Liskov es una
violación latente del principio Abierto/Cerrado, ya que esta
inconsistencia lógica causará una expresión condicional en el programa
Usuario.

Esta implicación sucede casi siempre, tanto que se puede decir que es
una regla general.

### Contratos

Hay un contrato entre **Usuario** (P) y el tipo **Rectángulo**, que
**Cuadrado** no respeta.

## ISA, NO es Herencia

![img](/img/complejo-real-entero.svg)

El diagrama demuestra por contradicción que la relación de herencia no
puede ser una relación «es un(a)».

La idea se basa en dos detalles:

 1. Un entero Sí «es un» Real, pero no puede «heredar» fácilmente sus
    detalles de implementación porque normalmente, son
    representaciones físicas muy diferentes.
 2. Un complejo necesita 2 reales, pero estos a su vez son
    complejos. Una relación cíclica lógicamente válida, pero imposible
    de soportar en la implementación (al momento de representar sus
    valores en un computador).

## Síntomas

Los siguientes son síntomas que pueden indicar una violación al
Principio de Substitución de Liskov:

 * Existencia de métodos en clases derivadas que violan el contrato de
   las clases base. (Esto es por definición).
 * Existencia de métodos en clases derivadas implementados como
   métodos que no hacen nada.
 * Métodos en clases derivadas que lanzan excepciones
   incondicionalmente.
 * Typecases (instanceOf, etc.).

## Lección

Siempre que definas una relación de herencia, verifica que las clases
derivadas no violen los contratos que ya existen entre las clases base
y sus programas clientes.

### Ejemplo

Dadas 2 clases ListaRápida y ListaLenta, que tienen la misma IPA
(API), derivada de Lista: ¿son ellas subtipos de Lista?

Sí. Pero, la única razón por la que no lo serían fuera que de alguna
manera violaran el contrato que tiene la clase base Lista con el resto
del programa.

Por ejemplo, si por alguna razón, la velocidad es parte de ese
contrato, y digamos que ListaLenta no cumple con ese requerimiento de
desempeño, entonces deja de ser un subtipo, desde el punto de vista de
este programa con estos requerimientos. Es decir, no puedes sustituir
una ListaRápida por una ListaLenta sin que el programa falle.

Tenga en cuenta que este hecho supera a cualquier definición de tipos
que declare el código. ListaLenta no es, *de facto*, un subtipo de
Lista, aunque, *de jure*, así lo «declare» el código.
