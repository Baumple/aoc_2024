import argv
import days/day2

pub fn main() {
  let use_test_file = case argv.load().arguments {
    ["-t", "--test"] -> True
    _ -> False
  }

  day2.task1(use_test_file)
  day2.task2(use_test_file)
}
