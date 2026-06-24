package ca.jrvs.apps.grep;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Pattern;

public class JavaGrepImp implements JavaGrep {

    private static final Logger logger = LoggerFactory.getLogger(JavaGrepImp.class);

    private String regex;
    private String rootPath;
    private String outFile;

    // compiled regex pattern
    private Pattern pattern;

    public static void main(String[] args) {
        if (args.length != 3) {
            logger.error("USAGE: JavaGrep regex rootPath outFile");
            System.exit(1);
        }

        JavaGrepImp app = new JavaGrepImp();
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
     * Top level search workflow
     */
    @Override
    public void process() throws IOException {
        List<String> matchedLines = new ArrayList<>();

        List<File> files = listFiles(rootPath);
        logger.info("Found {} files under rootPath={}", files.size(), rootPath);

        for (File file : files) {
            List<String> lines = readLines(file);
            for (String line : lines) {
                if (containsPattern(line)) {
                    matchedLines.add(line);
                }
            }
        }

        writeToFile(matchedLines);
        logger.info("Wrote {} matched lines to outFile={}", matchedLines.size(), outFile);
    }

    /**
     * Traverse a given directory recursively and return all files
     */
    @Override
    public List<File> listFiles(String rootDir) {
        List<File> files = new ArrayList<>();
        File root = new File(rootDir);

        if (!root.exists()) {
            logger.warn("Root path does not exist: {}", rootDir);
            return files;
        }

        File[] children = root.listFiles();
        if (children == null) {
            return files;
        }

        for (File child : children) {
            if (child.isDirectory()) {
                files.addAll(listFiles(child.getAbsolutePath()));
            } else if (child.isFile()) {
                files.add(child);
            }
        }
        return files;
    }

    /**
     * Read a file and return all the lines
     */
    @Override
    public List<String> readLines(File inputFile) {
        if (inputFile == null || !inputFile.isFile()) {
            throw new IllegalArgumentException("Input must be a file");
        }

        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(inputFile))) {
            String line;
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed reading file: " + inputFile.getAbsolutePath(), e);
        }

        return lines;
    }

    /**
     * check if a line contains the regex pattern
     */
    @Override
    public boolean containsPattern(String line) {
        if (line == null) return false;
        return pattern.matcher(line).find();
    }

    /**
     * Write lines to a file
     */
    @Override
    public void writeToFile(List<String> lines) throws IOException {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(outFile))) {
            for (String line : lines) {
                bw.write(line);
                bw.newLine();
            }
        }
    }

    @Override
    public String getRootPath() {
        return rootPath;
    }

    @Override
    public void setRootPath(String rootPath) {
        this.rootPath = rootPath;
    }

    @Override
    public String getRegex() {
        return regex;
    }

    @Override
    public void setRegex(String regex) {
        this.regex = regex;
        this.pattern = Pattern.compile(regex);
    }

    @Override
    public String getOutFile() {
        return outFile;
    }

    @Override
    public void setOutFile(String outFile) {
        this.outFile = outFile;
    }
}