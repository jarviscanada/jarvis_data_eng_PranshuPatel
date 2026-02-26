package ca.jrvs.apps.practice;
import java.util.regex.Pattern;
public class RegexExcImp implements RegexExc {
    // jpg or jpeg (case insensitive)
    private static final Pattern JPEG_PATTERN =
            Pattern.compile("^.+\\.(jpe?g)$", Pattern.CASE_INSENSITIVE);

    // IP: 0.0.0.0 to 999.999.999.999
    private static final Pattern IP_PATTERN =
            Pattern.compile("^\\d{1,3}(\\.\\d{1,3}){3}$");

    // Empty or whitespace line
    private static final Pattern EMPTY_LINE_PATTERN =
            Pattern.compile("^\\s*$");

    @Override
    public boolean matchJpeg(String filename) {
        if (filename == null) return false;
        return JPEG_PATTERN.matcher(filename).matches();
    }

    @Override
    public boolean matchIp(String ip) {
        if (ip == null) return false;
        return IP_PATTERN.matcher(ip).matches();
    }

    @Override
    public boolean isEmptyLine(String line) {
        if (line == null) return true;
        return EMPTY_LINE_PATTERN.matcher(line).matches();
    }

    // Simple testing main method
    public static void main(String[] args) {

        RegexExc exc = new RegexExcImp();

        System.out.println("JPEG TEST:");
        System.out.println(exc.matchJpeg("a.jpg"));   // true
        System.out.println(exc.matchJpeg("a.jpeg"));  // true
        System.out.println(exc.matchJpeg("a.JPG"));   // true
        System.out.println(exc.matchJpeg("a.png"));   // false

        System.out.println("IP TEST:");
        System.out.println(exc.matchIp("192.16.0.1"));     // true
        System.out.println(exc.matchIp("182.168.100.100"));// true
        System.out.println(exc.matchIp("192.168"));        // false

        System.out.println("EMPTY LINE TEST:");
        System.out.println(exc.isEmptyLine(""));       // true
        System.out.println(exc.isEmptyLine("   "));    // true
        System.out.println(exc.isEmptyLine("abc"));    // false
    }
}
