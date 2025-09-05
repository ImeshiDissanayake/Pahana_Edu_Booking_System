package connection;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import com.mongodb.client.FindIterable;
import com.mongodb.client.model.Sorts;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
    private final MongoCollection<Document> adminCollection;

    public AdminDAO() {
        MongoDatabase db = MongoDBConnection.getDatabase();
        adminCollection = db.getCollection("admin");
    }

    // Get all admins
    public List<Document> getAllAdmins() {
        List<Document> admins = new ArrayList<>();
        FindIterable<Document> docs = adminCollection.find().sort(Sorts.ascending("admin_id"));
        for (Document doc : docs) {
            admins.add(doc);
        }
        return admins;
    }

    // Get next admin_id
    private int getNextAdminId() {
        Document lastAdmin = adminCollection.find()
                .sort(Sorts.descending("admin_id"))
                .first();
        return (lastAdmin != null) ? lastAdmin.getInteger("admin_id") + 1 : 1;
    }

    // Add admin
    public void addAdmin(String username, String password, String fullName, String email, String phone, String role) {
        Document doc = new Document("admin_id", getNextAdminId())
                .append("username", username)
                .append("password", password)
                .append("full_name", fullName)
                .append("email", email)
                .append("phone", phone)
                .append("role", role);
        adminCollection.insertOne(doc);
    }

    // Update admin
    public void updateAdmin(int adminId, String username, String password, String fullName, String email, String phone, String role) {
        if (password != null && !password.isEmpty()) {
            adminCollection.updateOne(Filters.eq("admin_id", adminId),
                    Updates.combine(
                            Updates.set("username", username),
                            Updates.set("password", password),
                            Updates.set("full_name", fullName),
                            Updates.set("email", email),
                            Updates.set("phone", phone),
                            Updates.set("role", role)
                    ));
        } else {
            adminCollection.updateOne(Filters.eq("admin_id", adminId),
                    Updates.combine(
                            Updates.set("username", username),
                            Updates.set("full_name", fullName),
                            Updates.set("email", email),
                            Updates.set("phone", phone),
                            Updates.set("role", role)
                    ));
        }
    }

    // Delete admin
    public void deleteAdmin(int adminId) {
        adminCollection.deleteOne(Filters.eq("admin_id", adminId));
    }
}
