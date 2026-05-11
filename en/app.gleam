import gleam/float
import gleam/int
import gleam/list
import gleam/string
import sgleam/check

pub type Status {
  Pending
  InProgress
  Completed
}

pub type Appointment {
  Appointment(
    id: Int,
    name: String,
    description: String,
    date: String,
    status: Status,
  )
}

// -----------------------------------------------------------------------------
// CREATE APPOINTMENT

pub fn create_appointment(
  id: Int,
  name: String,
  description: String,
  date: String,
  status: Status,
) -> Result(Appointment, String) {
  case validate_appointment(id, name, description, date, status) {
    True -> Ok(Appointment(id, name, description, date, status))
    False -> Error("Could not create appointment")
  }
}

// -----------------------------------------------------------------------------
// VALIDATE APPOINTMENT

pub fn validate_appointment(
  id: Int,
  name: String,
  description: String,
  date: String,
  status: Status,
) -> Bool {
  case
    validate_id(id),
    validate_text(name),
    validate_text(description),
    validate_date(date),
    validate_status(status)
  {
    Ok(_id), Ok(_name), Ok(_description), Ok(_date), Ok(_status) -> True
    _, _, _, _, _ -> False
  }
}

// -----------------------------------------------------------------------------
// VALIDATE ID

fn validate_id(id: Int) -> Result(Int, Nil) {
  case id > 0 {
    True -> Ok(id)
    False -> Error(Nil)
  }
}

// -----------------------------------------------------------------------------
// VALIDATE TEXT

fn validate_text(text: String) -> Result(String, Nil) {
  case string.length(text) > 0 {
    True -> Ok(text)
    False -> Error(Nil)
  }
}

// -----------------------------------------------------------------------------
// VALIDATE DATE

pub fn validate_date(date: String) -> Result(String, Nil) {
  case
    string.length(date) == 10
    && string.slice(date, 2, 1) == "/"
    && string.slice(date, 5, 1) == "/"
  {
    True ->
      case
        int.parse(string.slice(date, 0, 2)),
        int.parse(string.slice(date, 3, 2)),
        int.parse(string.slice(date, 6, 4))
      {
        Ok(d), Ok(m), Ok(y) ->
          case d < 32 && d > 0 && m < 13 && m > 0 && y > 0 && y < 2300 {
            True -> Ok(date)
            False -> Error(Nil)
          }

        _, _, _ -> Error(Nil)
      }

    False -> Error(Nil)
  }
}

// -----------------------------------------------------------------------------
// VALIDATE STATUS

pub fn validate_status(status: Status) -> Result(Status, Nil) {
  case status {
    Pending -> Ok(Pending)
    InProgress -> Ok(InProgress)
    Completed -> Ok(Completed)
  }
}

// -----------------------------------------------------------------------------
// ADD APPOINTMENT

pub fn add_appointment(
  appointments: List(Appointment),
  appointment: Appointment,
) -> List(Appointment) {
  case
    validate_appointment(
      appointment.id,
      appointment.name,
      appointment.description,
      appointment.date,
      appointment.status,
    )
  {
    False -> []

    True ->
      case find_by_id(appointments, appointment.id) {
        Ok(_found) -> []

        _ ->
          case appointments {
            [] -> [appointment]

            [first, ..rest] -> [
              first,
              ..add_appointment(rest, appointment)
            ]
          }
      }
  }
}

// -----------------------------------------------------------------------------
// UPDATE STATUS

pub fn update_status(
  appointments: List(Appointment),
  id: Int,
  new_status: Status,
) -> Result(List(Appointment), String) {
  case appointments {
    [] -> Error("Id not found")

    [first, ..rest] if first.id == id -> {
      let updated_appointment =
        Appointment(..first, status: new_status)

      Ok([updated_appointment, ..rest])
    }

    [first, ..rest] ->
      case update_status(rest, id, new_status) {
        Ok(updated_list) -> Ok([first, ..updated_list])
        Error(_) -> Error("Id not found")
      }
  }
}

// -----------------------------------------------------------------------------
// FIND BY ID

pub fn find_by_id(
  appointments: List(Appointment),
  id: Int,
) -> Result(Appointment, String) {
  case appointments {
    [] -> Error("Id not found")

    [first, ..] if first.id == id ->
      Ok(first)

    [_, ..rest] ->
      find_by_id(rest, id)
  }
}

// -----------------------------------------------------------------------------
// FILTER BY STATUS

pub fn filter_by_status(
  appointments: List(Appointment),
  status: Status,
) -> List(Appointment) {
  case appointments {
    [] -> []

    [first, ..rest] if first.status != status ->
      filter_by_status(rest, status)

    [first, ..rest] ->
      [first, ..filter_by_status(rest, status)]
  }
}

// -----------------------------------------------------------------------------
// REMOVE COMPLETED

pub fn remove_completed(
  appointments: List(Appointment),
) -> List(Appointment) {
  case appointments {
    [] -> []

    [first, ..rest] if first.status == Completed ->
      remove_completed(rest)

    [first, ..rest] ->
      [first, ..remove_completed(rest)]
  }
}

// -----------------------------------------------------------------------------
// COUNT BY STATUS

pub fn count_by_status(
  appointments: List(Appointment),
  status: Status,
) -> Int {
  list.length(filter_by_status(appointments, status))
}

// -----------------------------------------------------------------------------
// COMPLETION PERCENTAGE

pub fn completion_percentage(
  appointments: List(Appointment),
) -> String {
  let total =
    int.to_float(list.length(appointments))

  let completed =
    int.to_float(
      list.length(
        filter_by_status(appointments, Completed),
      ),
    )

  let percentage =
    float.to_string(
      { completed /. total } *. 100.0,
    )

  "Completed appointments percentage: "
  <> string.slice(percentage, 0, 4)
  <> "%"
}

// -----------------------------------------------------------------------------
// EXAMPLES

pub fn examples() {
  let a1 =
    Appointment(
      1,
      "Pedro",
      "Ankle sprain",
      "12/02/2023",
      Pending,
    )

  let a2 =
    Appointment(
      2,
      "Carlos",
      "Broken arm",
      "22/10/2025",
      Completed,
    )

  check.eq(validate_id(10), Ok(10))

  check.eq(
    count_by_status([a1, a2], Completed),
    1,
  )
}
