import days/day2
import gleam/io
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// gleeunit test functions end in `_test`
pub fn hello_world_test() {
  1
  |> should.equal(1)
}

pub fn make_permutations_test() -> Nil {
  let l = [1, 2, 3, 4] |> io.debug
  let permutations = day2.make_permutations(l, list.length(l))
  should.equal(permutations, [
    [1, 2, 3, 4],
    [1, 2, 3],
    [1, 2, 4],
    [1, 3, 4],
    [2, 3, 4],
  ])
}
