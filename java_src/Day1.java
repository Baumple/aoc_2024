import java.nio.file.Files;
import java.nio.file.Path;
import java.io.IOException;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;

record ParsedInput(int[] left, int[] right) {}

public class Day1 {
    public static ParsedInput parse(List<String> input) {
        var left = new int[input.size()];
        var right = new int[input.size()];
        for (int i = 0; i < input.size(); i++) {
            var line = input.get(i);
            var split = line.split("   ");
            left[i] = Integer.parseInt(split[0]);
            right[i] = Integer.parseInt(split[1]);
        }
        Arrays.sort(left); 
        Arrays.sort(right);
        return new ParsedInput(left, right);
    }

    private static void task1(ParsedInput input) {
        int sum = 0;
        for (int i = 0; i < input.left().length; i++) {
            sum += Math.abs(input.left()[i] - input.right()[i]);
        }
        System.out.printf("The sum of all differences is %d\n", sum);
    }

    private static int count(int[] arr, int v) {
        int count = 0;
        for (int x : arr) if (x == v) count++;
        return count;
    }

    private static void task2(ParsedInput input) {
        int sum = 0;
        for (int i = 0; i < input.left().length; i++) {
            sum += input.left()[i] * count(input.right(), input.left()[i]);
        }
        System.out.printf("The similarity score is %d\n", sum);
    }

    public static void main(String[] args) throws IOException {
        var path = Path.of("input_day1.txt");
        var lines = Files.readAllLines(path);
        var parsed = parse(lines);

        task1(parsed);
        task2(parsed);
    }
}
