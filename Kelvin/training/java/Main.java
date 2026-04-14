import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Library lib = new Library();
        Scanner sc = new Scanner(System.in);
        int ch;

        while (true) {
            System.out.println("\n===== Library Menu =====");
            System.out.println("1. Add Book");
            System.out.println("2. Register User");
            System.out.println("3. Search Book");
            System.out.println("4. Issue Book");
            System.out.println("5. Return Book");
            System.out.println("6. Exit");

            ch = sc.nextInt();

            if(ch == 1){
                System.out.print("ID: ");
                int id = sc.nextInt();
                sc.nextLine();
                System.out.print("Title: ");
                String t = sc.nextLine();
                System.out.print("Author: ");
                String a = sc.nextLine();
                lib.addBook(id, t, a);

            } else if(ch == 2){
                System.out.print("User ID: ");
                int uid = sc.nextInt();
                sc.nextLine();
                System.out.print("Name: ");
                String nm = sc.nextLine();
                lib.addUser(uid, nm);

            } else if(ch == 3){
                sc.nextLine();
                System.out.print("Search: ");
                String kw = sc.nextLine();
                lib.searchBook(kw);

            } else if(ch == 4){
                System.out.print("Book ID: ");
                int bid = sc.nextInt();
                System.out.print("User ID: ");
                int uid = sc.nextInt();
                lib.issueBook(bid, uid);

            } else if(ch == 5){
                System.out.print("Book ID: ");
                int rid = sc.nextInt();
                lib.returnBook(rid);

            } else if(ch == 6){
                //System.out.println("exiting...");
                System.exit(0);
            } else {
                System.out.println("wrong option try again");
            }
        }
    }
}
