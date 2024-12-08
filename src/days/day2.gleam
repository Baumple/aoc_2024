import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

type Trend {
  Ascending
  Descending
}

fn is_safe(levels: List(Int)) {
  case levels {
    [] | [_] -> True
    [x, y, ..] if x < y -> is_safe_with_trend(levels, Ascending)
    [_, _, ..] -> is_safe_with_trend(levels, Descending)
  }
}

fn is_safe_with_trend(levels: List(Int), trend) -> Bool {
  case levels, trend {
    [], _ | [_], _ -> True
    [x, y, ..xs], Ascending ->
      x < y && y - x <= 3 && is_safe_with_trend([y, ..xs], trend)
    [x, y, ..xs], Descending ->
      x > y && x - y <= 3 && is_safe_with_trend([y, ..xs], trend)
  }
}

pub fn task1() {
  utils.read_input_file(2)
  |> string.split("\n")
  |> utils.filter_empty
  |> list.map(fn(line) {
    string.split(line, " ")
    |> list.map(fn(x) { int.parse(x) |> result.unwrap(0) })
  })
  |> list.map(is_safe)
  |> list.count(fn(x) { x == True })
  |> io.debug

  Nil
}
