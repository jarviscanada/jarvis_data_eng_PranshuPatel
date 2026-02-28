package ca.jrvs.apps.practice;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.function.Consumer;
import java.util.stream.Collectors;
import java.util.stream.DoubleStream;
import java.util.stream.IntStream;
import java.util.stream.Stream;

public class LambdaStreamImp implements LambdaStreamExc {

    @Override
    public Stream<String> createStrStream(String... strings) {
        if (strings == null) {
            return Stream.empty();
        }
        return Arrays.stream(strings);
    }

    @Override
    public Stream<String> toUpperCase(String... strings) {
        return createStrStream(strings)
                .filter(Objects::nonNull)
                .map(String::toUpperCase);
    }

    @Override
    public Stream<String> filter(Stream<String> stringStream, String pattern) {
        if (stringStream == null) {
            return Stream.empty();
        }
        if (pattern == null) {
            return stringStream;
        }
        // return another stream where NO element contains pattern
        return stringStream.filter(s -> s == null || !s.contains(pattern));
    }

    @Override
    public IntStream createIntStream(int[] arr) {
        if (arr == null) {
            return IntStream.empty();
        }
        return Arrays.stream(arr);
    }

    @Override
    public <E> List<E> toList(Stream<E> stream) {
        if (stream == null) {
            return Collections.emptyList();
        }
        return stream.collect(Collectors.toList());
    }

    @Override
    public List<Integer> toList(IntStream intStream) {
        if (intStream == null) {
            return Collections.emptyList();
        }
        return intStream.boxed().collect(Collectors.toList());
    }

    @Override
    public IntStream createIntStream(int start, int end) {
        return IntStream.rangeClosed(start, end);
    }

    @Override
    public DoubleStream squareRootIntStream(IntStream intStream) {
        if (intStream == null) {
            return DoubleStream.empty();
        }
        return intStream.mapToDouble(Math::sqrt);
    }

    @Override
    public IntStream getOdd(IntStream intStream) {
        if (intStream == null) {
            return IntStream.empty();
        }
        return intStream.filter(x -> x % 2 != 0);
    }

    @Override
    public Consumer<String> getLambdaPrinter(String prefix, String suffix) {
        final String safePrefix = prefix == null ? "" : prefix;
        final String safeSuffix = suffix == null ? "" : suffix;
        return msg -> System.out.println(safePrefix + msg + safeSuffix);
    }

    @Override
    public void printMessages(String[] messages, Consumer<String> printer) {
        if (messages == null || printer == null) {
            return;
        }
        Arrays.stream(messages).forEach(printer);
    }

    @Override
    public void printOdd(IntStream intStream, Consumer<String> printer) {
        if (intStream == null || printer == null) {
            return;
        }
        getOdd(intStream)
                .mapToObj(String::valueOf)
                .forEach(printer);
    }

    @Override
    public Stream<Integer> flatNestedInt(Stream<List<Integer>> ints) {
        if (ints == null) {
            return Stream.empty();
        }
        return ints
                .filter(Objects::nonNull)
                .flatMap(List::stream);
    }

    // quick manual test
    public static void main(String[] args) {
        LambdaStreamExc lse = new LambdaStreamImp();

        // 1) toUpperCase
        System.out.println(lse.toList(lse.toUpperCase("a", "b", "Hello")));

        // 2) filter (remove strings containing "a")
        Stream<String> s = lse.createStrStream("a", "ab", "bc", "xyz");
        System.out.println(lse.toList(lse.filter(s, "a")));

        // 3) int stream range + odd printing
        Consumer<String> printer = lse.getLambdaPrinter("odd number:", "!");
        lse.printOdd(lse.createIntStream(0, 5), printer);

        // 4) flatten (Java 8 compatible)
        Stream<List<Integer>> nested = Stream.of(
                Arrays.asList(1, 2),
                Arrays.asList(3),
                Arrays.asList(4, 5)
        );
        System.out.println(lse.toList(lse.flatNestedInt(nested)));
    }
}