import gleam/bool
import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/string
import utils

fn parse_num(input: String, acc: String) -> #(Int, String) {
  case string.pop_grapheme(input) {
    Error(_) -> #(
      int.parse(acc)
        |> result.lazy_unwrap(fn() {
          io.debug(acc)
          panic as "Converting"
        }),
      input,
    )
    Ok(#(popped, rest)) ->
      case is_num(popped) {
        True -> parse_num(rest, acc <> popped)
        False -> #(
          int.parse(acc)
            |> result.lazy_unwrap(fn() {
              io.debug(acc)
              panic
            }),
          input,
        )
      }
  }
}

fn is_num(s: String) -> Bool {
  string.to_utf_codepoints(s)
  |> list.map(string.utf_codepoint_to_int)
  |> list.all(fn(x) { 48 <= x && x <= 57 })
}

fn assert_next(s: String, next_char: String) -> Result(String, Nil) {
  case string.pop_grapheme(s) {
    Ok(#(c, rest)) if c == next_char -> Ok(rest)
    _ -> Error(Nil)
  }
}

fn parse_mul(input: String) -> Result(#(Int, String), Nil) {
  case string.pop_grapheme(input) {
    Error(_) -> Error(Nil)
    Ok(#(popped, rest)) -> {
      use <- bool.guard(when: !is_num(popped), return: Error(Nil))
      let #(a, rest) = parse_num(rest, popped)
      use rest <- result.try(assert_next(rest, ","))
      case string.pop_grapheme(rest) {
        Error(_) -> Error(Nil)
        Ok(#(popped, rest)) -> {
          use <- bool.guard(when: !is_num(popped), return: Error(Nil))
          let #(b, rest) = parse_num(rest, popped)
          use rest <- result.try(assert_next(rest, ")"))
          Ok(#(a * b, rest))
        }
      }
    }
  }
}

fn parse2(input: String, enable: Bool) -> Int {
  case input {
    "mul(" <> rest if enable ->
      case parse_mul(rest) {
        Error(_) -> parse2(rest, enable)
        Ok(#(v, rest)) -> v + parse2(rest, enable)
      }
    "don't()" <> rest -> parse2(rest, False)
    "do()" <> rest -> parse2(rest, True)
    _ ->
      case string.pop_grapheme(input) {
        Error(_) -> 0
        Ok(#(_, rest)) -> parse2(rest, enable)
      }
  }
}

fn parse(input: String) {
  case input {
    "mul(" <> rest ->
      case parse_mul(rest) {
        Error(_) -> parse(rest)
        Ok(#(v, rest)) -> v + parse(rest)
      }
    _ ->
      case string.pop_grapheme(input) {
        Error(_) -> 0
        Ok(#(_, rest)) -> parse(rest)
      }
  }
}

pub fn task1() {
  io.println("Task 1:")

  utils.read_input_file(3)
  |> parse
  |> io.debug
}

pub fn task2() {
  io.println("Task 1:")

  utils.read_input_file(3)
  |> parse2(True)
  |> io.debug
}
