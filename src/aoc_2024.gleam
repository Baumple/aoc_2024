import gleam/io
import argv
import days/day5/day5

pub fn main() {
  let use_test_file = case argv.load().arguments {
    ["test"] | ["t"] -> True
    _ -> False
  }
  day5.task1(use_test_file)
}
