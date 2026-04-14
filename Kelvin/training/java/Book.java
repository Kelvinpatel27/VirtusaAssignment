// book class
public class Book {
    int id;
    String title;
    String author;
    boolean isIssued;

    public Book(int id, String title, String author) {
        this.id = id;
        this.title = title;
        this.author = author;
        this.isIssued = false;
    }

    // print book info
    public void display() {
        String info = id + " | " + title + " | " + author + " | Issued: " + isIssued;
        System.out.println(info);
    }
}
