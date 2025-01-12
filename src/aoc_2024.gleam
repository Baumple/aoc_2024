import days/day1
import argv

pub fn main() {
  let use_test_file = case argv.load().arguments {
    ["-t", "--test"] -> True
    _ -> False
  }

  day1.task1(use_test_file)
  day1.task2(use_test_file)
}
