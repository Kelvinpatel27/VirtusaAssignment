import java.sql.*;
import java.time.LocalDate;

public class Library {

    // add book to the database
    public void addBook(int id, String title, String author) {
        try (Connection con = DBConnection.getConnection()) {
            String q = "INSERT INTO books (id, title, author, is_issued) VALUES (?, ?, ?, 0)";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, id);
            ps.setString(2, title);
            ps.setString(3, author);
            int rows = ps.executeUpdate();
            if(rows > 0){
                System.out.println("Book added!");
            }
        } catch (Exception e) {
            System.out.println("error adding book");
            e.printStackTrace();
        }
    }

    // register user
    public void addUser(int id, String name) {
        try (Connection con = DBConnection.getConnection()) {
            String q = "INSERT INTO users (id, name) VALUES (?, ?)";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, id);
            ps.setString(2, name);
            ps.executeUpdate();
            System.out.println("User registered!");
        } catch (Exception e) {
            // something went wrong
            System.out.println(e);
        }
    }

    // search book by title or author
    public void searchBook(String kw) {
        try (Connection con = DBConnection.getConnection()) {
            String q = "SELECT * FROM books WHERE title LIKE ? OR author LIKE ?";
            PreparedStatement ps = con.prepareStatement(q);
            String searchTerm = "%" + kw + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);

            ResultSet rs = ps.executeQuery();
            boolean found = false;

            while (rs.next()) {
                found = true;
                // just print each one
                int bookid = rs.getInt("id");
                String t = rs.getString("title");
                String a = rs.getString("author");
                boolean issued = rs.getBoolean("is_issued");
                System.out.println(bookid + " | " + t + " | " + a + " | Issued: " + issued);
            }
            if(found == false){
                System.out.println("No books found!");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // issue a book - marks it as issued and creates transaction
    public void issueBook(int bid, int uid) {
        try (Connection con = DBConnection.getConnection()) {

            // first check if its available
            String chk = "SELECT is_issued FROM books WHERE id=?";
            PreparedStatement p1 = con.prepareStatement(chk);
            p1.setInt(1, bid);
            ResultSet rs = p1.executeQuery();

            if (rs.next() && rs.getInt("is_issued") == 0) {

                //System.out.println("issuing book " + bid + " to " + uid);

                // mark as issued
                String upd = "UPDATE books SET is_issued=1 WHERE id=?";
                PreparedStatement p2 = con.prepareStatement(upd);
                p2.setInt(1, bid);
                p2.executeUpdate();

                // add transaction record
                String ins = "INSERT INTO transactions (book_id, user_id, issue_date, due_date) VALUES (?, ?, ?, ?)";
                PreparedStatement p3 = con.prepareStatement(ins);

                LocalDate today = LocalDate.now();
                LocalDate duedt = today.plusDays(7);

                p3.setInt(1, bid);
                p3.setInt(2, uid);
                p3.setDate(3, Date.valueOf(today));
                p3.setDate(4, Date.valueOf(duedt));
                p3.executeUpdate();

                System.out.println("Book issued!");

            } else {
                System.out.println("Book not available!");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // return book + check if theres a fine
    public void returnBook(int bid) {
        try (Connection con = DBConnection.getConnection()) {

            String q = "SELECT due_date FROM transactions WHERE book_id=?";
            PreparedStatement ps = con.prepareStatement(q);
            ps.setInt(1, bid);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                LocalDate due = rs.getDate("due_date").toLocalDate();
                LocalDate now = LocalDate.now();

                long diff = java.time.temporal.ChronoUnit.DAYS.between(due, now);

                // TODO: make fine per day configurable maybe
                if (diff > 0) {
                    long fine = diff * 10;
                    System.out.println("Fine: Rs." + fine);
                } else {
                    System.out.println("Returned on time!");
                }

                // set book back to available
                String upd = "UPDATE books SET is_issued=0 WHERE id=?";
                PreparedStatement p2 = con.prepareStatement(upd);
                p2.setInt(1, bid);
                p2.executeUpdate();

                // remove the transaction
                String del = "DELETE FROM transactions WHERE book_id=?";
                PreparedStatement p3 = con.prepareStatement(del);
                p3.setInt(1, bid);
                p3.executeUpdate();

            } else {
                System.out.println("No record found!");
            }

        } catch (Exception e) {
            System.out.println("something went wrong");
            e.printStackTrace();
        }
    }
}
