import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class DetectFraud {

    // Loop implementation
    public static List<Integer> detectFraud(List<Integer> transactions, int threshold) {

        // Edge case: threshold must be greater than 0
        if (threshold <= 0) {
            throw new IllegalArgumentException("Threshold must be greater than 0");
        }

        List<Integer> suspicious = new ArrayList<>();

        for (Integer transaction : transactions) {
            if (transaction > threshold) {
                suspicious.add(transaction);
            }
        }

        return suspicious;
    }

    // Stream API implementation
    public static List<Integer> detectFraudStream(List<Integer> transactions, int threshold) {

        // Edge case: threshold must be greater than 0
        if (threshold <= 0) {
            throw new IllegalArgumentException("Threshold must be greater than 0");
        }

        return transactions.stream()
                .filter(t -> t > threshold)
                .collect(Collectors.toList());
    }
}