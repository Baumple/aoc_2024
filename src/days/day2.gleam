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

pub fn task1(use_test_file: Bool) -> Nil {
  io.println("Task 1: ")

  let input_lines = case use_test_file {
    True -> utils.read_test_to_lines(2)
    False -> utils.read_input_to_lines(2)
  }

  let records =
    list.map(input_lines, fn(line) {
      string.split(line, " ")
      |> list.map(fn(x) { int.parse(x) |> result.lazy_unwrap(fn() { panic }) })
    })

  list.map(records, is_safe)
  |> list.count(fn(x) { x })
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

fn do_remove_at(l: List(#(Int, Int)), idx: Int) -> List(Int) {
  case l {
    [] -> []
    [#(i, _), ..rest] if i == idx -> list.map(rest, fn(x) { x.1 })
    [x, ..xs] -> [x.1, ..do_remove_at(xs, idx)]
  }
}

fn remove_at(l: List(Int), idx: Int) -> List(Int) {
  do_remove_at(list.index_map(l, fn(value, idx) { #(idx, value) }), idx)
}

@internal
pub fn make_permutations(l: List(Int), len count: Int) -> List(List(Int)) {
  case count {
    x if x <= 0 -> []
    _ -> {
      let permutation = remove_at(l, count - 1)
      [permutation, ..make_permutations(l, count - 1)]
    }
  }
}

/// This works on the premise that a safe report is still safe even when the
/// start or the end is removed.
///
/// is_safe_recover will create a list of lists from the `original report`
/// where each list represents the report with an index removed
/// and checks if any of these are safe.
///
/// ## For Example
/// ```gleam
/// [1, 2, 3, 4] -> [
///   [1, 2, 3],
///   [1, 2, 4],
///   [1, 3, 4],
///   [2, 3, 4]
/// ]
/// ```
fn is_safe_recover(levels: List(Int)) -> Bool {
  let permutations = make_permutations(levels, list.length(levels))

  list.any(permutations, is_safe)
}

pub fn task2(use_test_file: Bool) {
  io.println("Task 2: ")

  let input_lines = case use_test_file {
    True -> utils.read_test_to_lines(2)
    False -> utils.read_input_to_lines(2)
  }

  let records =
    list.map(input_lines, fn(line) {
      string.split(line, " ")
      |> list.map(fn(num) {
        int.parse(num) |> result.lazy_unwrap(fn() { panic })
      })
    })

  list.map(records, is_safe_recover)
  |> list.count(function.identity)
  |> io.debug

  Nil
}
