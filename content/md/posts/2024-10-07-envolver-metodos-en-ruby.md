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
class A # clase que define el método que queremos envolver
  def m
    :m
  end
end

module EspacioDeNombres
  module EnvolturaAlrededorDeM
    def m
      "envoltura_pre_1{ #{super} }1_rep_arutlovne"
    end

    freeze
  end
end


class A # clase que define el método que queremos envolver
  def m
    :m
  end
end

module EspacioDeNombres1
  module EnvolturaAlrededorDeM
    alias_method :espacio_de_nombres_1__original_m, :m
    def m
      "envoltura_pre_1{ #{espacio_de_nombres_1__original_m} }1_rep_arutlovne"
    end
  end
end

module EspacioDeNombres2
  module EnvolturaAlrededorDeM
    alias_method :espacio_de_nombres_2__original_m, :m
    def m
      "envoltura_pre_2{ #{espacio_de_nombres_2__original_m} }2_rep_arutlovne"
    end
  end
end

A.new.m # => "m"

A.prepend(EspacioDeNombres::EnvolturaAlrededorDeM)
A.new.m # => "envoltura_pre_1{ m }1_erp_arutlovne"
```

El método `Module#prepend` inserta <span class="under">el módulo que
le pasas como argumento</span> de primero en <span class="under">la
cadena de resolución de símbolos</span> de <span class="under">el
módulo al que se le aplica el método</span>.  Así, en este ejemplo,
cuando invocames el método `m` en el nuevo objeto de la clase `A`, la
implementación de `m` que se ejecuta es la que está definido en el
módulo `EnvolturaAlrededorDeM` porque está de primero en la cadena de
resolución de símbolos.

El uso de `freeze` en la definición del método envolvente, que
previene que ese módulo pueda ser abierto y/o modificado luego, es
para evitar un problema que explicaré más adelante.

# Técnica: «Anotar aparte» el método original con un alias

Hay otra técnica muy popular en el ecosistema Ruby que se vale de
utilizar el método `Module#alias_method`, con el que «anotas aparte»
el método original antes de modificarlo.

El ejemplo anterior lo podríamos haber implementado con esta técnica
de la siguiente manera:

```ruby
class A # Esta vez, define la clase
  def m
    :m
  end
end

class A # Pero esta vez, abre la clase que ya fue definida antes
  private alias_method :espacio_de_nombres__original_m, :m

  def m
    "envoltura_alias_1{ #{espacio_de_nombres__original_m} }1_saila_arutlovne"
  end
end

A.new.m # => envoltura_alias_1{ m }1_saila_arutlovne
```

# El problema con los nombres utilizados

¿Por qué el uso los «espacios de nombres» en los ejemplos?

Es posible que durante la ejecución de un programa que haga uso de
estas técnicas, diferentes partes del programa la repitan utilizando
los mismos nombres para los aliases o para los módulos envolventes.

Es muy fácil imaginar esa posibilidad con la técnica de los aliases,
porque se ha vuelto muy común en el ecosistema Ruby utilizar el
prefijo `original_` en el nombre de dicho alias.  Así que no es
decabellado que en diferentes momentos, el programa ejecute:

```ruby

# Primera vez que el programa abre la clase A
class A 
  private alias_method :original_m, :m
  
  def m
    "envoltura_alias_1{ #{original_m} }1_saila_arutlovne"
  end
end
```

Y luego, el mismo programa, también ejecute:

```ruby
# Segunda vez que el programa abre la clase A
class A
  private alias_method :original_m, :m
  
  def m
    "envoltura_alias_2{ #{original_m} }2_saila_arutlovne"
  end
end
```

Luego de la segunda redefinición de `m`, invocarla causará que el
programa quede atrapado en un bucle sin fin.  La razón es que para
cuando la segunda apertura de la clase `A` se realize, el método `m`
no es en realidad el método original, si no la primera envoltura.  Es
decir, desde ese momento `original_m` ya no será el método original,
si no la primera envoltura (la que envuelve con
`"envoltura_alias_1..."`).  Entonces ¿qué crees que sucederá cuando la
primera envoltura llame a `original_m`?.  Pues en ese momento, ese
método se estará llamando a si mismo.

```ruby
A.new.m # => ... Bucle infinito ...
```

Un problema similar, pero relativamente menos grave, sucede con la
técnica de prefijar el módulo envolvente.  Es concevible que varias
partes de un mismo programa traten de envolver el mismo método, con la
misma técnica, utilizando el mismo nombre de módulo.

Tal vez no sea un problema tan frecuente como con la técnica del
alias, debido a que no es tan popular y tampoco está tan arraigado el
uso de la misma palabra para definir los elementos auxiliares (en el
caso del alias, estoy hablando de la palabra «original»).  Sin embargo
es posible.

Nuevamente, no es decabellado pensar que el programa ejecute primero:

```ruby
module EnvolturaAlrededorDeM
  def m
    "envoltura_pre_1{ #{super} }1_rep_arutlovne"
  end
end

A.prepend(EnvolturaAlrededorDeM)
```

Y luego, el mismo programa, ejecute:
```ruby
module EnvolturaAlrededorDeM
  def m
    "envoltura_pre_2{ #{super} }2_rep_arutlovne"
  end
end

A.prepend(EnvolturaAlrededorDeM)
```

Sin embargo, en este caso, y a diferencia de la técnica con aliases,
invocar el método `m` no atrapará al programa en un bucle infinito, si
no más bien, ofuscará la primera envoltura con la segunda.

Es decir, este sería el resultado:

```ruby
A.new.m => "envoltura_pre_2{ m }2_rep_arutlovne"
```

Cuando probablemente, uno hubiera deseado este resultado:

```ruby
A.new.m => "envoltura_pre_2{ envoltura_pre_1{ m }1_rep_arutlovne }2_rep_arutlovne"
```

Nota que al menos, el programa no queda atrapado en un bucle infinito.

# Solución

Todos estos problemas pueden mitigarse con un uso responsable de
espacios de nombres.

En Ruby, los espacios de nombres normalmente se trabajan con módulos y
constantes.

Los módulos sirven como una colección de constantes, y las constantes
pueden tener asociadas módulos, haciendo posible una estructura de
árbol que se navega con el operador `::`.

En la técnica de prefijar un módulo a otro, utilicé espacios de
nombres de esta manera. I.e:


```
module EspacioDeNombres
  module EnvolturaAlrededorDeM
    def m
      "envoltura_pre_1{ #{super} }1_rep_arutlovne"
    end

    freeze
  end
end

A.prepend(EspacioDeNombres::EnvolturaAlrededorDeM)
```

Pero en el caso de la técnica del uso de `alias_method`, utilicé un
convenio muy personal que tengo para crear espacios de nombres
«improvisados».  La idea es que al nombrar variables, utilizo 2
«subrayados» como análogo al operador `::`.  I.e, en el ejemplo, en la
variable `espacio_de_nombres__original_m`, `espacio_de_nombres` es,
como lo sugiere su nombre, un espacio de nombres, y `original`
conrrespondería entenderlo (al programador) como el nombre de la
variable en dicho espacio.  Ruby no te protegería de que otro bloque
de código haga uso del mismo nombre de variable, sin embargo, sería
muy raro que sucediera y si sucede, es posiblemente a propósito.

# Conclusión

Mi recomendación es utilizar la técnica de prefijar módulos bien
catalogados en un espacio de nombres del que tengas control absoluto.

Así, varios módulos envolventes se encadenarían de forma que todos son
considerados a la hora de llamar al método envuelto:

```ruby
class A # clase que define el método que queremos envolver
  def m
    :m
  end
end

module EspacioDeNombres1
  module EnvolturaAlrededorDeM
    def m
      "envoltura_pre_1{ #{super} }1_rep_arutlovne"
    end

    freeze
  end
end

A.prepend(EspacioDeNombres1::EnvolturaAlrededorDeM)

module EspacioDeNombres2
  module EnvolturaAlrededorDeM
    def m
      "envoltura_pre_2{ #{super} }2_rep_arutlovne"
    end

    freeze
  end
end

A.prepend(EspacioDeNombres2::EnvolturaAlrededorDeM)

A.new.m # => "envoltura_pre_2{ envoltura_pre_1{ m }1_erp_arutlovne }2_erp_arutlovne"
```

Por completitud, este sería el ejemplo con la técnica de los alias que
generaría el mismo resultado:

```ruby
class A
  private alias_method :espacio_de_nombres_1__original_m, :m

  def m
    "envoltura_alias_1{ #{espacio_de_nombres_1__original_m} }1_saila_arutlovne"
  end
end

class A
  private alias_method :espacio_de_nombres_2__original_m, :m

  def m
    "envoltura_alias_1{ #{espacio_de_nombres_2__original_m} }1_saila_arutlovne"
  end
end

A.new.m # => envoltura_alias_2{ envoltura_alias_1{ m }1_saila_arutlovne }2_saila_arutlovne
```

# Anotaciones finales

## ¿Por qué ese `freeze` en la definición del módulo envolvente?

En el ejemplo:

```ruby
module EspacioDeNombres1
  module EnvolturaAlrededorDeM
    def m
      "envoltura_pre_1{ #{super} }1_rep_arutlovne"
    end

    freeze
  end
end
```

`freeze` es una primera línea de defensa contra la manipulación
accidental del módulo.

Supongamos que el módulo no hubiera sido parte de un espacio de
nombres propio.  Entonces al intentar «envolver» nuevamente el mismo
método con otra «módulo» con el mismo nombre, esa definición del otro
módulo en realidad estaría modificando el ya definido.  Con `freeze`,
causamos que el módulo no pueda modificarse y por lo tanto,
obtendríamos un error.

Es decir, el siguiente ejemplo causaría un error:

```ruby
module EnvolturaAlrededorDeM
  def m
    "envoltura_pre_1{ #{super} }1_rep_arutlovne"
  end
   freeze
end

A.prepend(EnvolturaAlrededorDeM)

# ...

module EnvolturaAlrededorDeM
  def m
    "envoltura_pre_2{ #{super} }2_rep_arutlovne"
  end
end
# Error, el módulo es inmutable.
# => `<module:EnvolturaAlrededorDeM>': can't modify frozen module: EnvolturaAlrededorDeM (FrozenError)
```

Es una prevensión adicional que en el caso de usar espacios de nombres
propios, donde tienes el control absoluto del mismo, entonces sería
una protección opcional que te protegería de ti mismo.  Si vez ese
error, entonces debes tomar la decisión de si quitar el `frozen` o
reconocer que lo que estás haciendo en ese momento está mal, y buscar
una alternativa.

## Prefijar varias veces el mismo módulo no repite el envolvimiento

`prepend`, al igual que `include` no causa que el mismo módulo se
repita en la cadena de resolución de nombres.

Así que, prefijar 2 veces un módulo envolvente sombre el mismo
módulo/clase, no envolverá 2 veces el método.

```ruby
class A
  def m
    :m
  end
end

module EnvolturaAlrededorDeM
  def m
    "envoltura_pre_1{ #{super} }1_rep_arutlovne"
  end
end

2.times{ A.prepend(EnvolturaAlrededorDeM) }

A.new.m # => "envoltura_pre_1{ m }1_rep_arutlovne"
```

Nota que la envoltura afecta una sóla vez, y por ende el resultado no
es `"envoltura_pre_1{ envoltura_pre_1{ m }1_rep_arutlovne }1_rep_arutlovne"`.
