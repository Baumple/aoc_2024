import gleam/int
import gleam/io
import gleam/list
import gleam/pair
import gleam/result
import gleam/string
import utils

pub fn task1(use_test_file: Bool) {
  let #(left, right) =
    parse(case use_test_file {
      True -> utils.read_test_to_lines(1)
      False -> utils.read_input_to_lines(1)
    })
    |> pair.map_first(list.sort(_, int.compare))
    |> pair.map_second(list.sort(_, int.compare))

  let diff_sum =
    list.map2(left, right, fn(left, right) { int.absolute_value(left - right) })
    |> list.reduce(int.add)
    |> result.unwrap(or: 0)

  io.println("The sum of differences is " <> int.to_string(diff_sum))

  Nil
}

fn parse(input: List(String)) -> #(List(Int), List(Int)) {
  input
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
}

pub fn task2(use_test_file: Bool) {
  io.println("Task 1:")
  let #(left, right) =
    parse(case use_test_file {
      True -> utils.read_test_to_lines(1)
      False -> utils.read_input_to_lines(1)
    })

  let similarity_score =
    list.map(left, fn(v) { v * list.count(right, fn(x) { x == v }) })
    |> list.reduce(int.add)
    |> result.unwrap(or: 0)

  io.println("The similarity score is " <> int.to_string(similarity_score))

  Nil
}
