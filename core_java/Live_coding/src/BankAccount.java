import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class BankAccount {

    private String accountNumber;
    private String ownerName;
    private double balance;
    private List<String> transactions;

    public BankAccount(String accountNumber, String ownerName, double startingBalance) {
        if (startingBalance < 0) {
            throw new IllegalArgumentException("Starting balance cannot be negative");
        }

        this.accountNumber = accountNumber;
        this.ownerName = ownerName;
        this.balance = startingBalance;
        this.transactions = new ArrayList<>();
    }

    public void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be greater than 0");
            //return;
        }

        balance += amount;
        transactions.add("deposit:" + amount);
    }

    public void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be greater than 0");
           // return;
        }

        if (amount > balance) {
            throw new IllegalArgumentException("You cannot withdraw more than the current balance");
           // return;
        }

        balance -= amount;
        transactions.add("withdraw:" + amount);
    }

    public double getBalance() {
        return balance;
    }

    public String getAccountInfo() {
        return "Account: " + accountNumber +
                "\nOwner: " + ownerName +
                "\nBalance: " + String.format("%.2f", balance);
    }

    public List<String> getTransactions() {
        return transactions;
    }

    public double totalDeposited() {
        return transactions.stream()
                .filter(t -> t.startsWith("deposit:"))
                .mapToDouble(t -> Double.parseDouble(t.split(":")[1]))
                .sum();
    }

    public double totalWithdrawn() {
        return transactions.stream()
                .filter(t -> t.startsWith("withdraw:"))
                .mapToDouble(t -> Double.parseDouble(t.split(":")[1]))
                .sum();
    }

    public double largestTransaction() {
        return transactions.stream()
                .mapToDouble(t -> Double.parseDouble(t.split(":")[1]))
                .max()
                .orElse(0);
    }

    public List<Double> getAllDeposits() {
        return transactions.stream()
                .filter(t -> t.startsWith("deposit:"))
                .map(t -> Double.parseDouble(t.split(":")[1]))
                .collect(Collectors.toList());
    }
}