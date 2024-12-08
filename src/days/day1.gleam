import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

pub fn task1() {
  let #(left, right) =
    utils.read_input_file(1)
    |> string.split("\n")
    |> list.filter(fn(a) { !string.is_empty(a) })
    |> list.fold(#([], []), fn(acc, line) {
      case string.split_once(line, "   ") {
        Ok(#(left, right)) -> #([int.parse(left) |> result.unwrap(0), ..acc.0], [
          int.parse(right) |> result.unwrap(0),
          ..acc.1
        ])
        Error(..) -> panic as "Malformed input"
      }
    })

  let left = list.sort(left, int.compare)
  let right = list.sort(right, int.compare)

  list.zip(left, right)
  |> list.map(fn(l_r) {
    let #(l, r) = l_r
    int.absolute_value(l - r)
  })
  |> list.reduce(int.add)
  |> io.debug
}

pub fn task2() {
  let #(left, right) =
    utils.read_input_file(1)
    |> string.split("\n")
    |> list.filter(fn(a) { !string.is_empty(a) })
    |> list.fold(#([], []), fn(acc, line) {
      case string.split_once(line, "   ") {
        Ok(#(left, right)) -> #([int.parse(left) |> result.unwrap(0), ..acc.0], [
          int.parse(right) |> result.unwrap(0),
          ..acc.1
        ])
        Error(..) -> panic as "Malformed input"
      }
    })

  list.map(left, fn(v) { v * list.count(right, fn(x) { x == v }) }) |> list.reduce(int.add)
  |> io.debug
}
