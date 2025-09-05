package connection;

import com.mongodb.client.*;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;
import org.bson.conversions.Bson;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class CustomerDAO {
    private final MongoCollection<Document> collection;

    public CustomerDAO() {
        collection = MongoDBConnection.getDatabase().getCollection("customer");
    }

    public List<Document> getAllCustomers() {
        List<Document> customers = new ArrayList<>();
        FindIterable<Document> docs = collection.find();
        for (Document doc : docs) {
            customers.add(doc);
        }
        return customers;
    }

    public boolean addCustomer(Document customer) {
        // Check if account_number already exists
        if (collection.find(Filters.eq("account_number", customer.getInteger("account_number"))).first() != null) {
            return false; // already exists
        }
        collection.insertOne(customer);
        return true;
    }

    public boolean updateCustomer(Document customer) {
        Integer accountNumber = customer.getInteger("account_number");
        Document existing = collection.find(Filters.eq("account_number", accountNumber)).first();
        if (existing == null) {
            return false; // not found
        }

        // Build update document
        List<Bson> updates = new ArrayList<>();
        updates.add(Updates.set("name", customer.getString("name")));
        updates.add(Updates.set("address", customer.getString("address")));
        updates.add(Updates.set("telephone", customer.getString("telephone")));
        updates.add(Updates.set("units_consumed", customer.getInteger("units_consumed")));
        updates.add(Updates.set("username", customer.getString("username")));
        updates.add(Updates.set("registration_date", customer.getDate("registration_date")));
        updates.add(Updates.set("status", customer.getString("status")));

        String newPassword = customer.getString("password");
        if (newPassword != null && !newPassword.isEmpty()) {
            updates.add(Updates.set("password", newPassword));
        } else {
            // keep old password, do nothing
        }

        collection.updateOne(Filters.eq("account_number", accountNumber), Updates.combine(updates));
        return true;
    }

    public boolean deleteCustomer(int accountNumber) {
        if (collection.find(Filters.eq("account_number", accountNumber)).first() == null) {
            return false; // not found
        }
        collection.deleteOne(Filters.eq("account_number", accountNumber));
        return true;
    }
}
