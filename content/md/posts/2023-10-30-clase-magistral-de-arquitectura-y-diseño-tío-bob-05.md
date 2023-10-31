{:title "Clase magistral de arquitectura y diseño (día 5) - Principio de Substitución de Liskov"
 :layout :post
 :tags ["es" "arquitectura" "software" "programación" "desarrollo" "diseño" "limpio" "limpia" "organizado" "organizada" "tío bob" "robert c. martin" "principios" "ocp" "open close principle" "principio abierto/cerrado" "solid"]}

Desde el pasado 6 de septiembre hasta el 13 de diciembre, todos los
miércoles (excepto por 2) [Robert
C. Martin](https://es.wikipedia.org/wiki/Robert_C._Martin) (mejor
conocido como «El tío Bob»), ha impartido y estará impartiendo una
clase magistral dedicada a la Arquitectura de Software.

Cada clase dura aproximadamente 2 horas y es impartida por Zoom.

Por mi parte, dedicaré una entrada al blog por cada clase a la que
asista, con la intención de registrar parte de mis notas y las
reflexiones que me surjan cada vez.

# Día 5: El Principio de Sibstitución de Liskov (LSP)

## Tipos

### ¿Qué es un tipo?

Independientemente de la codificación, mientras las operaciones sobre
los operandos produzcan resultados consistentes, ahí tienes un tipo.

### ¿Que es un subtipo?

Dado los tipos **S** y **T**, y el programa **P** que usa **T**.

Si modificamos el programa **P** sólamente haciendo que que use **S**
en vez de **T**, y este sigue funcionando igualmente, entonces **S**
es un subtipo de **T**.

## Es un(a) (ISA)

La Inteligencia Artificial fue un campo muy importante en los 70's a
principios de los 80's, generando bastante investigación.

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
muy normal utiliar ambos términos como lo mismo. Sin embargo, veremos
que no son exactamente lo mismo y por ende ha causado bastante
confusión.

## El problema del Cuadrado y el Rectángulo

**Diagrama**

Después de substituir Rectángulo por Cuadrado, al invocar
establecer_anchura(48) (por ejemplo), estaremos modificando también la
altura de la figura. Esta modificación puede causar problemas para el
programa **Usuario** si este no se lo esperaba. En ese caso, decimos
que el «Cuadrado» no puede substituir a un «Rectángulo».

El ejemplo fue elegido a drede porque lógicamente todo cuadrado es un
rectángulo y por ende deberíamos poder cambiar uno por otro sin
problemas.

Pero la clase Cuadrado y la clase Rectángulo son solo representantes,
no son realmente cuadrados ni rectángulos. Si en el programa cambias
todas las apariciones de la palabra «Cuadrado» por «XXXX» y todas las
apariciones de la palabra «Rectángulo» por «YYYY», el programa seguirá
funcionando igualmente.

**Nota** La regla del representante:

Los representantes de cosas no comparten las relaciones entre las
cosas que representan.

Esta violación del principio de substitución de Liskov es una
violación latente del principio Abierto/Cerrado, ya que esta
incnosistencia lógica causará una expresión condicional en el programa
Usuario.

### Contratos

Hay un contrato entre **Usuario** (P) y el tipo **Rectángulo**, que
**Cuadrado** no respeta.

## ISA, NO es Herencia

**Diagrama**.

El diagrama demuestra por contradicción que la relación de herencia no
puede ser una relación «es un(a)».

La idea son dos detalles:

 1. Un entero Sí «es un» Real, pero no puede «heredar» fácilmente sus
    detalles de implementación porque normalmente, son
    representaciones físicas muy diferentes.
 2. Un complejo necesita 2 reales, pero estos a su vez son
    complejos. Una relación cíclica lógicamente válida, pero imposible
    de soportar en la implementación (al momento de representar sus
    valores en un computador).

## Síntomas

 * Métodos en clases derivadas que violan el contrato de las clases
   base. (Esto es por definición).
 * Métodos en clases derivadas implementados como métodos que no hacen
   nada.
 * Métodos en clases derivadas que lanzan excepciones
   incondicionalmente.
 * Typecases (instanceOf, etc.).

## Jerarquías paralelas (un caso justificado de Typecase)

**Diagrama**

No es una violación al principio de substitución de Liskov porque
AddTimecard ya conocía de la existencia de HourlyEmployee, y por ende,
tienen un «contrato» entre ellos.

## Lección

Siempre que definas una relación de herencia, verifica que las clases
derivadas no violen los contratos que ya existen entre las clases base
y sus programas clientes.

### Ejemplo

Dadas 2 clases ListaRápida y ListaLenta, que tienen la misma IPA
(API), derivada de Lista: ¿son ellas subtipos de Lista?

Sí. Pero, la única razón por la que no lo serían fuera que de alguna
manera violan el contrato que tiene la clase base Lista con el resto
del programa. Y si por alguna razón, la velocidad es parte de ese
contrato, y digamos que ListaLenta no cumple con ese requerimiento de
desempeño, entonces deja de ser un subtipo, desde el punto de vista de
este programa con estos requerimientos. Es decir, no puedes sustituir
una ListaRápida por una ListaLenta sin que el programa falle.

## Un proceso de desarrollo de ejemplo donde sucede una violación del principio de substitución de Liskov

**Diagrama**

Misión: Extender FTP para que utilice DedicatedModem, sin modificar FTP (siguiendo así el principio de Abierto/Cerrado).

Solución: Hacer que DedicatedModem herede de Modem.

Modificamos DedicatedModem añadiendo los métoos «dial» y «hu», como
métodos que no hacen nada, sólo para «satisfacer» el contrato de FTP,
quien va a llamar a «dial» y «hu».

Este pequeño cambio causa que DedUser deba actualizarse, pero el
efecto es simplemente una recompilación.

Luego un problema surge en la integración. De vez en cuando, el
programa FTP recibe archivos con caractéres de más cuando utiliza el
Modem dedeicado.

La explicacíon es que FTP tiene el concepto de «concectado» y
«deconectado», que es irrelevante para el modem dedicado, pero en la
línea pueden existir caracteres que FTP esperaba descartar al invocar
«hu» y «dial». Pero como no se descartan, FTP los recibe junto con el
resto de los datos válidos.

## Historia

 * Friedrich Ludwig Gottlob Fregs
   * 1879 -> Lenguaje formal para un modelo puro de cómo pensar la
     aritmética (y poder deducir que 1+1 = 2).
 * 23 años luego, Bertrand Russell encontró un «hueco», con una
   paradoja: «¿El conjunto que contiene todos los conjuntos que no se
   contienen a si mismos, se contiene a si mismo?»
 * Freges propone a esta paradoja una solución:
   * Limitar el tipo de cosas sobre las cuales las funciones pueden
     operar.
   * Los tipos forman una jerarquía sin ciclos.
 * Kurt Gödel:
   * Teoría de tipos simples (**revisar el video, uncle bob elabora un
     poco la idea**).
 
