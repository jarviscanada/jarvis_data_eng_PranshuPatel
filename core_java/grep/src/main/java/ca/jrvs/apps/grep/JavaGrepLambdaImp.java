package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.UncheckedIOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class JavaGrepLambdaImp extends JavaGrepImp {

    private static final Logger logger = LoggerFactory.getLogger(JavaGrepLambdaImp.class);

    public static void main(String[] args) {
        if (args.length != 3) {
            logger.error("USAGE: JavaGrepLambdaImp regex rootPath outFile");
            System.exit(1);
        }

        JavaGrepLambdaImp app = new JavaGrepLambdaImp();
        app.setRegex(args[0]);
        app.setRootPath(args[1]);
        app.setOutFile(args[2]);

        try {
            app.process();
        } catch (Exception e) {
            logger.error("Error: unable to process", e);
            System.exit(1);
        }
    }

    /**
     * list files recursively using NIO + Stream
     */
    @Override
    public List<File> listFiles(String rootDir) {
        if (rootDir == null) {
            return java.util.Collections.emptyList();
        }

        Path rootPath = Paths.get(rootDir);
        if (!Files.exists(rootPath)) {
            logger.warn("Root path does not exist: {}", rootDir);
            return java.util.Collections.emptyList();
        }

        try (Stream<Path> paths = Files.walk(rootPath)) {
            return paths
                    .filter(Files::isRegularFile)
                    .map(Path::toFile)
                    .collect(Collectors.toList());
        } catch (IOException e) {
            throw new UncheckedIOException("Failed to traverse directory: " + rootDir, e);
        }
    }

    /**
     * read all lines using Stream API
     */
    @Override
    public List<String> readLines(File inputFile) {
        if (inputFile == null || !inputFile.isFile()) {
            throw new IllegalArgumentException("inputFile must be a valid file");
        }

        // Option A (recommended): Files.lines (auto handles encoding default)
        try (Stream<String> lines = Files.lines(inputFile.toPath())) {
            return lines.collect(Collectors.toList());
        } catch (IOException e) {
            throw new UncheckedIOException("Failed to read file: " + inputFile.getAbsolutePath(), e);
        }

        // Option B (if you want classic IO):
        // try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
        //   return br.lines().collect(Collectors.toList());
        // } catch (IOException e) {
        //   throw new UncheckedIOException("Failed to read file: " + inputFile.getAbsolutePath(), e);
        // }
    }
}