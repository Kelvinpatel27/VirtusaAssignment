import java.util.Scanner;

// password strength checker
public class PasswordValidator {

    // checks if password meets all the rules
    public static boolean validatePassword(String pwd) {
        boolean upper = false;
        boolean digit = false;
        boolean ok = true;
        int len = pwd.length();
        
        if (len < 8) {
            System.out.println("Too short (minimum 8 characters required)");
            ok = false;
        }

        // go thru each char and check
        for (int i = 0; i < len; i++) {
            char c = pwd.charAt(i);
            if (Character.isUpperCase(c)) {
                upper = true;
            }
            if (Character.isDigit(c)) {
                digit = true;
            }
        }

        //System.out.println("upper=" + upper + " digit=" + digit);

        if (upper == false) {
            System.out.println("Missing an uppercase letter");
            ok = false;
        }

        if (!digit) {
            System.out.println("Missing a digit");
            ok = false;
        }


        boolean result = ok;
        return result;
    }


    // main - keep asking till password is accepted
    public static void main(String[] args) {
        Scanner sc = new Scanner(System.in);
        String pwd;
        int attempts = 0;

        System.out.println("Welcome to SafeLog Password Validator");

        // loop until valid
        while (true) {
            System.out.print("\nEnter your password: ");
            pwd = sc.nextLine();
            attempts++;

            boolean valid = validatePassword(pwd);
            if (valid) {
                System.out.println("Password is strong and accepted!");
                //System.out.println("took " + attempts + " tries");
                break;
            } else {
                System.out.println("Please try again.");
            }
        }

        sc.close();
    }
}
