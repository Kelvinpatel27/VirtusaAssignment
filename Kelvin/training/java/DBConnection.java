import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    // change these if ur running on a diff machine
    static final String URL = "jdbc:oracle:thin:@localhost:1521/XEPDB1";
    static final String USER = "system";
    static final String PASSWORD = "system";

    public static Connection getConnection() throws Exception {
        Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
        return conn;
    }
}
