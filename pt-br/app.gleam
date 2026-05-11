import gleam/float
import gleam/int
import gleam/list
import gleam/string
import sgleam/check

pub type Status {
  Pendente
  EmAndamento
  Concluida
}

// Vamos dividir a Agenda da seguinte forma:
// Id: Será um Int
// Nome: Será uma string, com o nome do paciente
// Descricao: Será uma string, com o motivo da consulta
// Data: String, com a data da consulta e deve ter tamanho 10 (dd/mm/aaaa)
// Status: Status, podendo ser pendente, em andamento ou concluida
pub type Agenda {
  Agenda(id: Int, nome: String, descricao: String, data: String, status: Status)
}

// Exemplos de Agenda

// Agenda(id: 123, nome: "Pedro", descricao: "Torção do tornozelo", data: "12/02/2023", status: Concluida)
// Agenda(id: 10, nome: "Carlos", descricao: "Braço fraturado", data: "22/10/2025", status: Pendente)
// Agenda(id: 345, nome: "Gabriel", descricao: "Braço trincado", data: "03/10/2025", status: EmAndamento)
// [Agenda(id: 123, nome: "Pedro", descricao: "Torção do tornozelo", data: "12/02/2023", status: Concluida),Agenda(id: 10, nome: "Carlos", descricao: "Braço fraturado", data: "22/10/2025", status: Pendente),Agenda(id: 345, nome: "Gabriel", descricao: "Braço Trincado", data: "03/10/2025", status: EmAndamento)]

// ------------------------------------------------------------------------------------------------------------------

// A função criar_consulta analisa aspectos de uma consulta para poder cria-la
// Ela recebe parametros como se fossem atributos da estrutura e retorna Ok(Estrutura) caso seja possível
// a criação, caso contrário, indica um erro de criação.
pub fn criar_consulta(
  id: Int,
  nome: String,
  descricao: String,
  data: String,
  status: Status,
) -> Result(Agenda, String) {
  case validar_consulta(id, nome, descricao, data, status) {
    True -> Ok(Agenda(id, nome, descricao, data, status))
    False -> Error("Não foi possivel criar a consulta")
  }
}

// Exemplos de criar_consulta

pub fn criar_consulta_examples() {
  check.eq(
    criar_consulta(1, "Pedro", "Torção do tornozelo", "12/02/2023", Pendente),
    Ok(Agenda(1, "Pedro", "Torção do tornozelo", "12/02/2023", Pendente)),
  )

  check.eq(
    criar_consulta(0, "", "Consulta inválida", "12-02-2023", Pendente),
    Error("Não foi possivel criar a consulta"),
  )
}

// ------------------------------------------------------------------------------------------------------------------

// A função validar consulta valida se uma consulta pode ser criada dependendo do resultado das validações 
// dos aspectos referentes a ela. Retorna True caso seja possível e False caso não seja possível.
pub fn validar_consulta(
  id: Int,
  nome: String,
  descricao: String,
  data: String,
  status: Status,
) -> Bool {
  case
    validar_id(id),
    validar_texto(nome),
    validar_texto(descricao),
    validar_data(data),
    validar_status(status)
  {
    Ok(_id), Ok(_nome), Ok(_descricao), Ok(_data), Ok(_status) -> True
    _, _, _, _, _ -> False
  }
}

// Exemplos de validar_consulta

pub fn validar_consulta_examples() {
  check.eq(
    validar_consulta(1, "Pedro", "Torção do tornozelo", "12/02/2023", Pendente),
    True,
  )

  check.eq(
    validar_consulta(0, "Pedro", "Torção do tornozelo", "12/02/2023", Pendente),
    False,
  )

  check.eq(
    validar_consulta(1, "", "Torção do tornozelo", "12/02/2023", Pendente),
    False,
  )

  check.eq(
    validar_consulta(1, "Pedro", "Torção do tornozelo", "12-02-2023", Pendente),
    False,
  )
}

// ------------------------------------------------------------------------------------------------------------------

// A função validar id analisa se o *id* é positivo, caso seja: Ok(id), caso contrário Error(Nil)
fn validar_id(id: Int) -> Result(Int, Nil) {
  case id > 0 {
    True -> Ok(id)
    False -> Error(Nil)
  }
}

// Exemplos de validar_id

pub fn validar_id_examples() {
  check.eq(validar_id(10), Ok(10))
  check.eq(validar_id(0), Error(Nil))
  check.eq(validar_id(-5), Error(Nil))
}

// ------------------------------------------------------------------------------------------------------------------

// A função validar_texto analisa se um *texto* não é branco. 
//Caso não seja branco Ok(texto)
// Contrário Error(Nil)
fn validar_texto(texto: String) -> Result(String, Nil) {
  case string.length(texto) > 0 {
    True -> Ok(texto)
    False -> Error(Nil)
  }
}

// Exemplos de validar_texto

pub fn validar_texto_examples() {
  check.eq(validar_texto("Pedro"), Ok("Pedro"))
  check.eq(validar_texto(""), Error(Nil))
}

// ------------------------------------------------------------------------------------------------------------------

// A função validar_data analisa se uma data está no formato adequado (dd/mm/aaaa)
// Caso esteja retorna Ok(data)
// Caso contrário retorna Error(Nil)
pub fn validar_data(data: String) -> Result(String, Nil) {
  case
    string.length(data) == 10
    && string.slice(data, 2, 1) == "/"
    && string.slice(data, 5, 1) == "/"
  {
    True ->
      case
        int.parse(string.slice(data, 0, 2)),
        int.parse(string.slice(data, 3, 2)),
        int.parse(string.slice(data, 6, 4))
      {
        Ok(d), Ok(m), Ok(a) ->
          case d < 32 && d > 0 && m < 13 && m > 0 && a > 0 && a < 2300 {
            True -> Ok(data)
            False -> Error(Nil)
          }
        _, _, _ -> Error(Nil)
      }
    False -> Error(Nil)
  }
}

// Exemplos de validar_data

pub fn validar_data_examples() {
  check.eq(validar_data("12/02/2023"), Ok("12/02/2023"))
  check.eq(validar_data("2023/02/12"), Error(Nil))
  check.eq(validar_data("12-02-2023"), Error(Nil))
  check.eq(validar_data("12/02/23"), Error(Nil))
}

// ------------------------------------------------------------------------------------------------------------------

//Valida se um *status* pertence ao tipo enumerado Status
pub fn validar_status(status: Status) -> Result(Status, Nil) {
  case status {
    Pendente -> Ok(Pendente)
    EmAndamento -> Ok(EmAndamento)
    Concluida -> Ok(Concluida)
  }
}

// Exemplos de validar_status

pub fn validar_status_examples() {
  check.eq(validar_status(Pendente), Ok(Pendente))
  check.eq(validar_status(EmAndamento), Ok(EmAndamento))
  check.eq(validar_status(Concluida), Ok(Concluida))
}

// ------------------------------------------------------------------------------------------------------------------

// A função validar_consulta analisa se pode adiciona uma consulta em uma lista de consultas, caso possa
// Ela adiciona e retorna a nova lista com a consulta nova nela
// Caso contrários, retorna apenas uma lista vazia. Isso ocorre caso a nova consulta não seja válida ou já
// possuia um id na lista podendo ser a mesma consulta ou uma distinta
// Assim retorna uma lista vazia
pub fn adicionar_consulta(
  consultas: List(Agenda),
  consulta: Agenda,
) -> List(Agenda) {
  case
    validar_consulta(
      consulta.id,
      consulta.nome,
      consulta.descricao,
      consulta.data,
      consulta.status,
    )
  {
    False -> []
    True ->
      case busca_por_id(consultas, consulta.id) {
        Ok(_encontrado) -> []
        _ ->
          case consultas {
            [] -> [consulta]
            [primeiro, ..resto] -> [
              primeiro,
              ..adicionar_consulta(resto, consulta)
            ]
          }
      }
  }
}

// Exemplos de adicionar_consulta

pub fn adicionar_consulta_examples() {
  let nova = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  check.eq(adicionar_consulta([], nova), [nova])

  let c1 = Agenda(2, "Carlos", "Braço trincado", "02/01/2023", EmAndamento)
  check.eq(adicionar_consulta([c1], nova), [c1, nova])

  let c2 = Agenda(3, "João", "Torção no pé", "03/01/2023", Concluida)
  check.eq(adicionar_consulta([c1, c2], nova), [c1, c2, nova])

  let c3 =
    Agenda(
      id: 3,
      nome: "Gabriel",
      descricao: "Braço trincado",
      data: "03/10/2025",
      status: EmAndamento,
    )
  check.eq(adicionar_consulta([c1, c2], c3), [])
}

// ------------------------------------------------------------------------------------------------------------------

// A função atualizar_status atualiza status de uma determinda consulta dentro de uma lista passada nos parametros
// por um id e muda o seu status para um novo status
// caso encontre o id específico é retornada a mesma lista mas com a consulta nova já com seu status atualizado
// caso contrário retorna erro de Id não encontrado
pub fn atualizar_status(
  consultas: List(Agenda),
  id: Int,
  novo_status: Status,
) -> Result(List(Agenda), String) {
  case consultas {
    [] -> Error("Id não encontrado")
    [primeira, ..resto] if primeira.id == id -> {
      let consulta_procurada = Agenda(..primeira, status: novo_status)
      Ok([consulta_procurada, ..resto])
    }
    [primeira, ..resto] ->
      case atualizar_status(resto, id, novo_status) {
        Ok(lista_atualizada) -> Ok([primeira, ..lista_atualizada])
        Error(_) -> Error("Id não encontrado")
      }
  }
}

// Exemplos de atualizar_status

pub fn atualizar_status_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  let c2 =
    Agenda(
      id: 123,
      nome: "Pedro",
      descricao: "Torção do tornozelo",
      data: "12/02/2023",
      status: Concluida,
    )
  check.eq(
    atualizar_status([c1, c2], 1, Concluida),
    Ok([
      Agenda(
        id: 1,
        nome: "Ana",
        descricao: "Braço fraturado",
        data: "01/01/2023",
        status: Concluida,
      ),
      Agenda(
        id: 123,
        nome: "Pedro",
        descricao: "Torção do tornozelo",
        data: "12/02/2023",
        status: Concluida,
      ),
    ]),
  )
  check.eq(atualizar_status([c1], 99, Concluida), Error("Id não encontrado"))
}

// ------------------------------------------------------------------------------------------------------------------

// a função busca por id faz uma busca em uma lista de consultas por um id específico
// caso enconre o id é retronado a consulta em específico, caso contrário
// retorna uma mensagem de erro com Id não encontrado
pub fn busca_por_id(agenda: List(Agenda), id: Int) -> Result(Agenda, String) {
  case agenda {
    [] -> Error("Id não encontrado")
    [primeiro, ..] if primeiro.id == id -> Ok(primeiro)
    [_, ..resto] -> busca_por_id(resto, id)
  }
}

// Exemplos de busca_por_id

pub fn busca_por_id_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  check.eq(busca_por_id([c1], 1), Ok(c1))
  check.eq(busca_por_id([c1], 2), Error("Id não encontrado"))
}

// ------------------------------------------------------------------------------------------------------------------

// a função filtra por status filtra uma lista de consultas por um determinado status, ela retorna a lista apenas com as consultas
// q possuem o status específico, caso não haja, retorna uma lista vazia
pub fn filtra_por_status(agenda: List(Agenda), status: Status) -> List(Agenda) {
  case agenda {
    [] -> []
    [primeira, ..resto] if primeira.status != status ->
      filtra_por_status(resto, status)
    [primeira, ..resto] -> [primeira, ..filtra_por_status(resto, status)]
  }
}

// Exemplos de filtra_por_status

pub fn filtra_por_status_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  let c2 = Agenda(2, "Carlos", "Braço trincado", "02/01/2023", Concluida)
  let c3 = Agenda(3, "Pedro", "Torção do tornozelo", "03/01/2023", Concluida)

  check.eq(filtra_por_status([c1, c2, c3], Concluida), [c2, c3])
}

// ------------------------------------------------------------------------------------------------------------------

// a função remove concluidas remove todas as consultas concluidas de uma determinada lista retronando apenas as listas não concluidas ou uma lista vazia caso 
// todas sejam concluidas
pub fn remove_concluidas(agenda: List(Agenda)) -> List(Agenda) {
  case agenda {
    [] -> []
    [primeira, ..resto] if primeira.status == Concluida ->
      remove_concluidas(resto)
    [primeira, ..resto] -> [primeira, ..remove_concluidas(resto)]
  }
}

// Exemplos de remove_concluidas

pub fn remove_concluidas_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  let c2 = Agenda(2, "Carlos", "Braço trincado", "02/01/2023", Concluida)
  let c3 = Agenda(3, "Pedro", "Torção do tornozelo", "03/01/2023", Pendente)

  check.eq(remove_concluidas([c1, c2, c3]), [c1, c3])
}

// ------------------------------------------------------------------------------------------------------------------

// a função conta_por_status realiza uma contagem de consultas determinadas pelo um status específicos conforme aquela lista e seu conteúdo.
pub fn contar_por_status(agenda: List(Agenda), status: Status) -> Int {
  list.length(filtra_por_status(agenda, status))
}

// Exemplos de contar_por_status

pub fn contar_por_status_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  let c2 = Agenda(2, "Carlos", "Braço trincado", "02/01/2023", Concluida)
  let c3 = Agenda(3, "Pedro", "Torção do tornozelo", "03/01/2023", Concluida)

  check.eq(contar_por_status([c1, c2, c3], Concluida), 2)
}

// ------------------------------------------------------------------------------------------------------------------

// a função percentual_concluidas retorna o porcentual específico de consultas já concluidas conforme a lista já passada
pub fn percentual_concluidas(agenda: List(Agenda)) -> String {
  let quantidade_total = int.to_float(list.length(agenda))
  let quantidade_concluida =
    int.to_float(list.length(filtra_por_status(agenda, Concluida)))
  let porcentual =
    float.to_string({ quantidade_concluida /. quantidade_total } *. 100.0)
  "O porcentual de consultas concluidas é de "
  <> string.slice(porcentual, 0, 4)
  <> "%"
}

// Exemplos de percentual_concluidas

pub fn percentual_concluidas_examples() {
  let c1 = Agenda(1, "Ana", "Braço fraturado", "01/01/2023", Pendente)
  let c2 = Agenda(2, "Carlos", "Braço trincado", "02/01/2023", Concluida)
  let c3 = Agenda(3, "Pedro", "Torção do tornozelo", "03/01/2023", Concluida)

  check.eq(
    percentual_concluidas([c1, c2, c3]),
    "O porcentual de consultas concluidas é de 66.6%",
  )
}
