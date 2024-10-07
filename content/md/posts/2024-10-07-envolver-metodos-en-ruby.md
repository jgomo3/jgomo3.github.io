 {:title "Dos técnicas populares para envolver métodos en Ruby"
 :layout :post
 :tags ["es" "ruby" "métodos" "método" "envolver" "wrap" "method" "modules" "module" "módulos" "módulo"]}

<style>
.under {
  text-decoration: underline;
}
</style>

Si necesitas envolver un método en Ruby, un par de maneras populares de lograrlo
serían:

 - Prefijando un módulo con la envoltura
 - «Anotando aparte» el método original con un alias
 
# Técnica: Prefijar un módulo con la envoltura

Define un módulo con el método envolvente, y luego «prefija» este
módulo en aquel otro módulo (o clase) que define el método que quieres
envolver.

Ejemplo:

```ruby
class A
  def m = :m
end

module E1
  def m = "E1{ #{super} }1E"
end

A.new.m # => :m

A.prepend(E1)
A.new.m # => "E1{ m }1E"
```

El método `Module#prepend` inserta <span class="under">el módulo que
le pasas como argumento</span> de primero en <span class="under">la
lista de búsqueda de métodos</span> de <span class="under">la clase (o
módulo)</span> al que se le aplica el método `prepend`.  Así, en este
ejemplo, cuando invocamos el método `m` en el nuevo objeto de la clase
`A`, la implementación de `m` que se ejecuta es la que está definida
en el módulo `E1` porque está de primero en la lista de búsqueda de
métodos.

Con `super` invocamos el método original, que en este ejemplo el la
siguiente implementación en la lista de búsqueda de métodos.

## Múltiples envolturas

Módulos adicionales prefijados de esta manera tomarán precedencia y
envolverán toda la composición acumulada hasta entonces.  Siempre y
cuando recuerdes invocar a `super` en algún lugar de los envoltorios,
el método original será invocado.  Si omites `super`, el método
original (y todos los envoltorios anteriores) serán omitidos.

```ruby
# ... continuación del ejemplo
module E2
  def m = "E2{ #{super} }2E"
end

module E3
  def m = :E3 # No llama a `super`
end

A.prepend(E2)
A.new.m # => "E2{ E1{ m }1E }2E"

A.prepend(E3) # oculta toda la composición acumulada hasta ahora
A.new.m # => :E3
```

### El mismo módulo no se repite en la lista de resolución de métodos

`prepend`, al igual que `include` no causa que el mismo módulo se
repita en la lista de resolución de métodos.

Así que, prefijar 2 veces un módulo envolvente sombre el mismo
módulo/clase, no envolverá 2 veces el método.

```ruby
class A
  def m = :m
end

module E
  def m = "E{ #{super} }E"
end

2.times{ A.prepend(E) }

A.new.m # => "E{ m }E"
```

Nota que la envoltura afecta una sola vez, y por ende el resultado no
es `"E{ E{ m }E }E"`.

# Técnica: «Anotar aparte» el método original con un alias

Hay otra técnica muy popular en el ecosistema Ruby que se vale de
utilizar el método `Module#alias_method`, con el que «anotas aparte»
el método original antes de modificarlo.

El ejemplo anterior lo podríamos haber implementado con esta técnica
de la siguiente manera:

```ruby
class A
  def m = :m
end

class A
  private alias_method :e1__m, :m

  def m = "e1{ #{e1__m} }1e"
end

A.new.m # => e1{ m }1e
```

Una diferencia muy importante es que en vez de utilizar `super`, el
envoltorio llama al método «anotado aparte», o `e1_m` en este
ejemplo.

## Múltiples envolturas

Al igual que con la técnica de prefijar módulos, puedes crear varios
niveles de envoltura:

```ruby
class A
  private alias_method :e2__m, :m

  def m = "e2{ #{e2__m} }2e"
end
```

Esto funciona siempre y cuando los nombres de las anotaciones son
únicos.

# El problema con los nombres utilizados

Es posible que durante la ejecución de un programa que haga uso de
estas técnicas, diferentes partes del programa la repitan utilizando
los mismos nombres para los aliases o para los módulos envolventes.

Es muy fácil imaginar esa posibilidad con la técnica de los aliases,
porque se ha vuelto muy común en el ecosistema Ruby utilizar el
prefijo `original_` en el nombre de dicho alias.  Así que no es
descabellado que en diferentes momentos, el programa ejecute:

```ruby

# Primera vez que el programa abre la clase A
class A 
  private alias_method :original_m, :m
  
  def m = "e1{ #{original_m} }1e"
end
```

Y luego, el mismo programa, también ejecute:

```ruby
# Segunda vez que el programa abre la clase A
class A
  private alias_method :original_m, :m
  
  def m = "e2{ #{original_m} }2e"
end
```

Luego de la segunda definición de `m`, el método `m` causará que el
programa quede atrapado en un bucle sin fin.

La razón es que para cuando la segunda apertura de la clase `A` se
realice, el método `m` no es en realidad el método original, si no la
primera envoltura.  Es decir, desde ese momento `original_m` ya no
será el método original, si no la primera envoltura (la que envuelve
con `"e1{...}1e"`).  Entonces ¿qué crees que sucederá cuando la
primera envoltura llame a `original_m`?.  Pues en ese momento, ese
método se estará llamando a si mismo, activando la trampa.

```ruby
A.new.m # => ... Bucle infinito ...
```

Un problema similar, pero relativamente menos grave, sucede con la
técnica de prefijar el módulo envolvente.  Es concebible que varias
partes de un mismo programa traten de envolver el mismo método, con la
misma técnica, utilizando el mismo nombre de módulo.

Tal vez no sea un problema tan frecuente como con la técnica del
alias, debido a que no es tan popular y tampoco está tan arraigado el
uso de la misma palabra para definir los elementos auxiliares (en el
caso del alias, estoy hablando de la palabra «original»).  Sin embargo
es posible.

Nuevamente, no es descabellado pensar que el programa ejecute primero:

```ruby
module E1
  def m = "E1{ #{super} }1E"
end

A.prepend(E1)
```

Y luego, el mismo programa, ejecute:
```ruby
module E1
  def m = "E1'{ #{super} }'1E"
end

A.prepend(E1)
```

Sin embargo, en este caso, y a diferencia de la técnica con aliases,
invocar el método `m` no atrapará al programa en un bucle infinito, si
no más bien, ofuscará la primera envoltura con la segunda.

Es decir, éste sería el resultado:

```ruby
A.new.m => "E1'{ m }'1E"
```

Cuando probablemente, uno hubiera deseado este resultado:

```ruby
A.new.m => "E1'{ E1{ m }1E }'1E"
```

Nota que al menos, el programa no queda atrapado en un bucle infinito.

# Solución

Todos estos problemas se pueden mitigar con un uso responsable de
espacios de nombres.

En Ruby, los espacios de nombres normalmente se trabajan con módulos y
constantes.

Los módulos sirven como una colección de constantes, y las constantes
pueden tener asociadas módulos, haciendo posible una estructura de
árbol que se navega con el operador `::`.

Como ejemplo, supongamos 2 proyectos independientes que definen
envoltorios del método `m`, y un tercero que los requiere a los 2:

```ruby
# framework.rb
class A
  def m = :m
end
```

```ruby
# org_1/proyecto_1.rb
require 'framework'

module Org1
module Org1::Proy1
module Org1::Proy1::E1
  def m = "O1_P1_E1{ #{super} }1E_1P_1O"
end

A.prepend(Org1::Proy1::E1)
```

```ruby
# org_2/proyecto_1.rb

module Org2
module Org2::Proy1
module Org2::Proy1::E1
  def m = "O2_P1_E1{ #{super} }1E_1P_2O"
end

A.prepend(Org2::Proy1::E1)
```

```
# program.rb

require 'org1/proyecto_1'
require 'org2/proyecto_2'

puts A.m
```

El resultado de este programa sería: `O2_P1_E1{ O1_P1_E1{ #{super} }1E_1P_1O }1E_1P_2O`.

Si no fueran por los espacios de nombre, ambos proyectos se tendrían
que coordinar y ponerse de acuerdo para no utilizar los mismos
nombres, o el resultado hubiera sido: `O2_P1_E1{ #{super} }1E_1P_2O`.

Pero en el caso de la técnica del uso de `alias_method`, utilicé un
convenio muy personal que tengo para crear espacios de nombres
«improvisados».  La idea es que al nombrar variables, utilizo 2
«subrayados» como análogo al operador `::`.  I.e, en el ejemplo, en la
variable `e1__m`, `e1` es un espacio de nombres improvisado, y `m`
correspondería entenderlo (al programador) como el nombre de la
variable en dicho espacio.  Ruby no te protegería de que otro bloque
de código haga uso del mismo nombre de variable, sin embargo, sería
muy raro que sucediera y si sucede, es posiblemente a propósito.

# Conclusión

Mi recomendación es utilizar la técnica de prefijar módulos, y
definirlos dentro de un espacio de nombres del que tengas control
absoluto.

# Anotaciones finales

## «Congela» los módulos con `freeze`

Otra forma de proteger los módulos de ofuscación accidental, es
«congelarlos» con `freeze`.
En el ejemplo:

```ruby
module E
  def m
    "E1{ #{super} }1E"
  end
  
  freeze
end
```

En este ejemplo, el módulo `E` no puede volver a abrirse (fácilmente)
para modificar.  Y si un bloque de código fuera de tu control (o tuyo
por error, o exploración) intenta abrir el módulo `E`, recibirá un
error:

```ruby
`<module:E>': can't modify frozen module: E (FrozenError)
```

Es una prevención adicional que puedes combinar incluso con el uso de
espacios de nombres propios (donde tienes el control absoluto del
mismo), en cuyo caso te protegería de ti mismo.  Si ves ese error,
entonces debes tomar la decisión de si quitar el `frozen` o reconocer
que lo que estás haciendo en ese momento está mal, y buscar una
alternativa.

# Otras técnicas

Existen otras técnicas que valen la pena explorar:

 - Refinamientos
 - Meta programación con `define_method`, `instance_method` y
   variables de instancia de los objetos «módulo» o «clase»
 - Concernientes
 - Explotar el método `method_missing`
 - La gema `around_the_world`.

Son técnicas que tal vez explore y escriba de ellas en el futuro, o
quedan de «tarea» para el lector ;-)
