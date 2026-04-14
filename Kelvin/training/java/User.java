public class User {
    int id;
    String name;

    public User(int id, String name) {
        this.id = id;
        this.name = name;
    }

    // not using this rn but might need later
    public String toString() {
        return id + " - " + name;
    }
}
