import gleam/bool
import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import utils

type Rule =
  #(Int, Int)

fn updates_from_line(line: String) -> List(Int) {
  string.split(line, ",")
  |> list.map(int.parse)
  |> list.map(result.unwrap(_, 0))
}

fn rule_from_line(line: String) -> Rule {
  case string.split_once(line, "|") {
    Error(_) -> panic
    Ok(#(left, right)) -> #(
      string.trim(left) |> int.parse |> result.unwrap(0),
      string.trim(right) |> int.parse |> result.unwrap(0),
    )
  }
}

fn find_index(l: List(a), el: a) -> Result(Int, Nil) {
  list.index_map(l, fn(el, idx) { #(el, idx) })
  |> list.key_find(el)
}

fn is_according_to_rule(page_update: List(Int), rule: Rule) -> Result(Bool, Nil) {
  use left_idx <- result.try(find_index(page_update, rule.0))
  use right_idx <- result.try(find_index(page_update, rule.1))
  Ok(left_idx < right_idx)
}

fn is_according_to_rules(page_update: List(Int), rule: List(Rule)) -> Bool {
  list.map(rule, is_according_to_rule(page_update, _))
  |> list.filter(result.is_ok)
  // if not okay, the rule was not applicable
  |> result.all
  |> result.unwrap(or: [])
  |> list.all(function.identity)
}

/// Task 1 of day 5
pub fn task1(use_test_file) -> Nil {
  let #(rules, page_updates) =
    case use_test_file {
      True -> utils.read_test_file(5)
      False -> utils.read_input_file(5)
    }
    |> string.split("\n")
    |> list.split_while(fn(line) { line != "" })

  let rules = list.map(rules, rule_from_line)
  let page_updates =
    utils.filter_empty(page_updates)
    |> list.map(updates_from_line)

  list.filter(page_updates, is_according_to_rules(_, rules))
  |> list.fold(from: 0, with: fn(acc, updates) {
    let middle_page = find_middle_page(updates)
    acc + middle_page
  })
  |> io.debug

  Nil
}

fn correct_update(updates: List(Int), rules: List(Rule)) -> List(Int) {
  list.sort(updates, fn(a, b) {
    // get all values that have to be right of a
    let ass = list.key_filter(rules, a)
    // get all values that have to be right of b
    let bs = list.key_filter(rules, b)

    // if b is one of the values that is right of a, a is less than b
    use <- bool.guard(when: list.any(ass, fn(a2) { a2 == b }), return: order.Lt)

    // if a is one of the values that is right of b, a is greater than b
    use <- bool.guard(when: list.any(bs, fn(b2) { b2 == a }), return: order.Gt)

    // otherwise treat them as equal
    order.Eq
  })
}

fn find_middle_page(l: List(Int)) -> Int {
  let assert Ok(el) =
    list.index_map(l, fn(el, idx) { #(idx, el) })
    |> list.key_find(list.length(l) / 2)
  el
}

/// Task 2 of day 5
pub fn task2(use_test_file) -> Nil {
  let #(rules, page_updates) =
    case use_test_file {
      False -> utils.read_input_file(5)
      True -> utils.read_test_file(5)
    }
    |> string.split("\n")
    |> list.split_while(fn(line) { line != "" })

  let rules = list.map(rules, rule_from_line)
  let page_updates =
    utils.filter_empty(page_updates)
    |> list.map(updates_from_line)

  let incorrect_updates =
    list.filter(page_updates, fn(page_updates) {
      !is_according_to_rules(page_updates, rules)
    })

  incorrect_updates
  |> list.map(correct_update(_, rules))
  |> list.fold(0, fn(a, b) { a + find_middle_page(b) })
  |> io.debug

  Nil
}
