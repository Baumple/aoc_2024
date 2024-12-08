import gleam/list
import gleam/string
import gleam/int
import simplifile

pub fn read_input_file(day: Int) -> String {
  let path = "src/days/input_day" <> int.to_string(day) <> ".txt"

  case simplifile.read(path) {
     Ok(contents)-> contents
     Error(..) -> panic as { "Could not open input for day '" <> int.to_string(day) <>"'" }
  }
}

pub fn read_test_file(day: Int) -> String {
  let path = "src/days/test_day" <> int.to_string(day) <> ".txt"

  case simplifile.read(path) {
     Ok(contents)-> contents
     Error(..) -> panic as { "Could not open test input for day '" <> int.to_string(day) <>"'" }
  }
}

pub fn filter_empty(l: List(String)) -> List(String) {
  list.filter(l, fn(s) { !string.is_empty(s) })
}
