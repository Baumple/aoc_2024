//// WARN: Completely wrong..

import gleam/function
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

fn is_safe(levels: List(Int)) -> Bool {
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
  io.println("Task 1: ")
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

fn is_safe_recover_with_trend(levels: List(Int), trend: Trend) -> Bool {
  case levels, trend {
    [], _ | [_], _ -> True

    [x, y, ..xs], Ascending -> {
      let cond = x < y && y - x <= 3
      case cond {
        True -> is_safe_recover_with_trend([y, ..xs], trend)
        False ->
          is_safe_with_trend([x, ..xs], trend)
          || is_safe_with_trend([y, ..xs], trend)
      }
    }

    [x, y, ..xs], Descending -> {
      let cond = x > y && x - y <= 3
      case cond {
        True -> is_safe_recover_with_trend([y, ..xs], trend)
        False ->
          is_safe_with_trend([x, ..xs], trend)
          || is_safe_with_trend([y, ..xs], trend)
      }
    }
  }
}

fn is_safe_recover(levels: List(Int)) -> Bool {
  case levels {
    [] | [_] -> True

    [x, y, ..xs] if x < y ->
      case y - x <= 3 {
        True -> is_safe_recover_with_trend(levels, Ascending)
        False -> is_safe([x, ..xs]) || is_safe([y, ..xs])
      }

    [x, y, ..xs] if x > y ->
      case x - y <= 3 {
        True -> is_safe_recover_with_trend(levels, Descending)
        False -> is_safe([x, ..xs]) || is_safe([y, ..xs])
      }

    _ -> False
  }
}

pub fn task2() {
  io.println("Task 2: ")
  // utils.read_input_to_lines(2)
  let input =
    utils.read_input_to_lines(2)
    |> list.map(fn(line) {
      string.split(line, " ")
      |> list.map(fn(num) {
        int.parse(num) |> result.lazy_unwrap(fn() { panic })
      })
    })

  list.map(input, is_safe_recover)
  |> list.count(function.identity)
  |> io.debug

  Nil
}
