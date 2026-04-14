import java.time.LocalDate;

public class Transaction {
    int bookId;
    int userId;
    LocalDate issueDate;
    LocalDate dueDate;

    public Transaction(int bookId, int userId) {
        this.bookId = bookId;
        this.userId = userId;
        this.issueDate = LocalDate.now();
        this.dueDate = issueDate.plusDays(7); // 1 week
    }
}
