import java.util.Arrays;
import java.util.List;

public class Main {

    public static void main(String[] args) {

        // Detect Fraud
        List<Integer> transactions = Arrays.asList(20, 40, 1200, 30);
        int threshold = 1000;

        System.out.println("Fraud Transactions (Loop): " +
                DetectFraud.detectFraud(transactions, threshold));

        System.out.println("Fraud Transactions (Stream): " +
                DetectFraud.detectFraudStream(transactions, threshold));

        // Bank Account
        BankAccount account = new BankAccount("12345", "Alice", 100);

        account.deposit(50);
        account.withdraw(30);

        System.out.println("\n=== Account Info ===");
        System.out.println(account.getAccountInfo());
        System.out.println("Final Balance: " + account.getBalance());

        // Extra transactions for Stream API
        account.deposit(70);
        account.withdraw(20);
        account.deposit(200);

        System.out.println("\n=== All Transactions ===");
        System.out.println(account.getTransactions());

        System.out.println("\n=== Stream API Results ===");
        System.out.println("Total Deposited: " + account.totalDeposited());
        System.out.println("Total Withdrawn: " + account.totalWithdrawn());
        System.out.println("Largest Transaction: " + account.largestTransaction());
        System.out.println("All Deposits: " + account.getAllDeposits());
    }
}