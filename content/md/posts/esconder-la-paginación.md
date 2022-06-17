{:title "Esconder la paginación"
 :layout :post
 :tags ["es" "Ruby" "Clojure" "lazy" "evaluación perezosa" "lazy-seq" "seq" "Ruby" "Enumerator" "binary search" "búsqueda binaria" "linear search" "búsqueda lineal"]
 :author "Jesús Gómez"}
 
Alguna vez tuve que actualizar una aplicación que utilizaba un
servicio que cambió su interfaz.

Se trataba de un servicio que devolvía una lista de recursos. En
específico, era una lista de usuarios.

La versión original del servicio simplemente devolvía una lista con
todos los usuarios.

Eventualmente los dueños del servicio decidieron que debía entregar
los resultados en forma paginada.

Afortunadamente la aplicación tenía un servicio interno que ocultaba
el servicio de terceros, así que la adaptación no fue difícil.

El único asunto complicado era que la aplicación hacía recorridos
lineales en la lista completa de usuarios, y eso era algo que la
adaptación debía respetar.

Por ejemplo, uno de los métodos del servicio interno era
`user_if_from_email`, que buscaba en forma lineal el primer usuario de
la lista con el `email` argumentado.
n
En su forma trivial, el método era algo como lo siguiente:

```ruby
def user_id_from_email(email)
	users.select { _1["email"] }.first.dig('id')
end

def users
	client.user_list
end
```

Este ejemplo es un extracto reducido del servicio interno original. El
lenguaje en que está escrito es Ruby 2.7.

Lo que está sucediendo en este ejemplo es que tenemos 2 métodos
públicos: `users` y `user_id_from_email`.

`users` devuelve la lista de todos los usuarios del servicio externo.

`user_id_from_email` obtiene el `id` de algún usuario con email `email`.

La forma en que `users` logra su cometido es utilizando `client`, que
es un objeto que provee el SDK (Software Development Kit) del servicio
externo. Esa es la manera en que los proveedores del servicio externo
esperan que los clientes usen su servicio: a través de métodos del
objeto `client` del SDK.

En pocas palabras, `users` nos abstrae del SDK y el proceso para
obtener la lista de usuarios con el mismo.

`user_if_from_email` busca en forma lineal los usuarios que tengan el
email argumentado, coge el primero y retorna el `id` de dicho usuario.


**ASIDE**
Sí, por el hecho de conformarse con el primero, la implementación de
`user_if_from_email` pudo aprovechar una búsqueda perezosa:

```ruby
def user_id_from_email(email)
	users.lazy.select { _1["email"] }.first.dig('id')
end
```

De esta manera la búsqueda se detendría al momento de encontrar el
primer usuario con el `email` argumentado.
**ASIDE**


El problema es que `client.user_list` cambió su contrato con el código
cliente. La estructura de datos que devuelve ya no es una simple lista
de usuarios, sino una _«página»_ que incluye una lista de usuarios.



```ruby
def get_users_including_an_user_with(field, value)
  get_users_from_page = users_from_page_getter
  (1..).lazy
    .map{ get_users_from_page.call(_1) }
    .select{ _1.any? { |u| u[field] == value } }
    .first
rescue MeetingError
  raise MeetingError.new("User with #{field} = #{value} not found")
end

def users_from_page_getter
  page_count = nil
  -> (page) {
    if page > 0 && (page_count.nil? || page <= page_count)
      page = page_with_users_service(page)
      page_count = page["page_count"]
      return page["users"]
    end
    raise MeetingError.new("Page #{page} not in range")
  }
end

def page_with_users_service(page)
  client.user_list(page_number: page)
end
```
