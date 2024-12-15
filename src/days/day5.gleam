import gleam/function
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

fn updates_from_line(line: String) -> List(Int) {
  string.split(line, ",")
  |> list.map(int.parse)
  |> list.map(result.unwrap(_, 0))
}

type Rule {
  Rule(page: Int, before: Int)
}

fn rule_from_line(line: String) -> Rule {
  case string.split_once(line, "|") {
    Error(_) -> panic
    Ok(#(left, right)) ->
      Rule(
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
  use left_idx <- result.try(find_index(page_update, rule.page))
  use right_idx <- result.try(find_index(page_update, rule.before))
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

pub fn task1() {
  let #(rules, page_updates) =
    utils.read_input_file(5)
    |> string.split("\n")
    |> list.split_while(fn(line) { line != "" })

  let rules = list.map(rules, rule_from_line)
  let page_updates =
    utils.filter_empty(page_updates)
    |> list.map(updates_from_line)

  list.filter(page_updates, is_according_to_rules(_, rules))
  |> list.fold(from: 0, with: fn(acc, updates) {
    let middle_page =
      list.index_map(updates, fn(el, idx) { #(idx, el) })
      |> list.key_find(list.length(updates) / 2)
      |> result.unwrap(or: 0)
    acc + middle_page
  })
  |> io.debug
}

pub fn task2() {
  let #(rules, page_updates) =
    utils.read_input_file(5)
    |> string.split("\n")
    |> list.split_while(fn(line) { line != "" })

  let rules = list.map(rules, rule_from_line)
  let page_updates =
    utils.filter_empty(page_updates)
    |> list.map(updates_from_line)

  list.filter(page_updates, is_according_to_rules(_, rules))
  |> list.fold(from: 0, with: fn(acc, updates) {
    let middle_page =
      list.index_map(updates, fn(el, idx) { #(idx, el) })
      |> list.key_find(list.length(updates) / 2)
      |> result.unwrap(or: 0)
    acc + middle_page
  })
  |> io.debug
}
