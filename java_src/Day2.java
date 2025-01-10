import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class Day2 {
    private static List<int[]> parseInput() throws IOException {
        // read input
        List<String> inputLines = Files.readAllLines(Path.of("input_day2.txt"));

        // initialize list for results
        ArrayList<int[]> records = new ArrayList<>();

        // for each line, split by whitespace and convert each substring to an
        // int
        for (String line : inputLines) {
            String[] numberStrings = line.split(" ");

            ArrayList<Integer> level = new ArrayList<>();
            for (String numberString : numberStrings) {
                level.add(Integer.parseInt(numberString));
            }

            // copy Integer values into int[] for later usage
            int[] intLevel = new int[level.size()];
            for (int i = 0; i < intLevel.length; i++) {
                intLevel[i] = level.get(i);
            }

            records.add(intLevel);
        }

        return records;
    }

    private static boolean isSafe(int[] _record) {
        if (_record.length < 2) return true;

        boolean isAscending = _record[0] < _record[1];

        for (int i = 0; i < _record.length - 1; i++) {
            int x = _record[i];
            int y = _record[i + 1];

            if (isAscending && x < y && y - x <= 3) {
                continue;

            } else if (!isAscending && y < x && x - y <= 3) {
                continue;

            } else {
                return false;
            }
        }
        return true;
    }

    // Returns a `new` array with the value at the index removed.
    // The original array is not mutated!
    private static int[] removeFromArray(int[] arr, int idx) {
        if (arr.length == 0) return new int[] {};

        int[] newArr = new int[arr.length - 1];
        int newArrPos = 0;

        for (int i = 0; i < arr.length; i++) {
            if (i != idx) {
              newArr[newArrPos++] = arr[i];
            }
        }
        return newArr;
    }

    private static List<int[]> makePermutations(int[] l) {
        ArrayList<int[]> permutations = new ArrayList<>();

        for (int i = l.length; i > 0; i--) {
            int[] permutation = removeFromArray(l, i - 1);
            permutations.add(permutation);
        }

        return permutations;
    }

    private static boolean isSafeRecover(int[] _record) {
        if (_record.length < 2) return true;

        List<int[]> permutations = makePermutations(_record);

        for (int[] permutation : permutations) {
            if (isSafe(permutation)) { 
                return true;
            }
        }

        return false;
    }

    private static void task1() throws IOException  {
        List<int[]> records = parseInput();

        int safeCount = 0;
        for (int[] record : records) {
            boolean isSafe = isSafe(record);

            if (isSafe) {
                safeCount++;
            }
        }

        System.out.printf("Number of safe records: %d\n", safeCount);
    }

    private static void task2() throws IOException {
        List<int[]> records = parseInput();

        int safeCount = 0;
        for (int[] record : records) {
            var isSafe = isSafeRecover(record);
            if (isSafe) safeCount++;
        }

        System.out.printf("Number of safe records (recover): %d\n", safeCount);
    }

    public static void main(String[] args) throws IOException {
        task1();
        task2();
    }
}
