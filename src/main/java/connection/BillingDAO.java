package connection;

import com.mongodb.client.MongoCollection;
import org.bson.Document;

public class BillingDAO {
    private final MongoCollection<Document> billingCollection;

    public BillingDAO() {
        // Get the billing collection from your database
        billingCollection = MongoDBConnection.getDatabase().getCollection("billing");
    }

    public void addBill(String customerName, String itemName, int quantity, double totalBill) {
        Document bill = new Document("customer_name", customerName)
                .append("item_name", itemName)
                .append("quantity", quantity)
                .append("total_bill", totalBill);

        billingCollection.insertOne(bill);
        System.out.println("Bill added for customer: " + customerName);
    }
}
