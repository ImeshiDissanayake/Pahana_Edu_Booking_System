package connection;

import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import com.mongodb.client.model.Filters;
import com.mongodb.client.model.Updates;
import org.bson.Document;

import java.util.ArrayList;
import java.util.List;

public class ItemDAO {
    private final MongoCollection<Document> itemCollection;

    public ItemDAO() {
        MongoDatabase db = MongoDBConnection.getDatabase();
        itemCollection = db.getCollection("item");
    }

    // Add new item
    public void addItem(int itemId, String name, double price, int stock, String description) {
        Document doc = new Document("item_id", itemId)
                .append("item_name", name)
                .append("price", price)
                .append("stock", stock)
                .append("description", description);
        itemCollection.insertOne(doc);
    }

    // Update existing item
    public void updateItem(int itemId, String name, double price, int stock, String description) {
        itemCollection.updateOne(Filters.eq("item_id", itemId),
                Updates.combine(
                        Updates.set("item_name", name),
                        Updates.set("price", price),
                        Updates.set("stock", stock),
                        Updates.set("description", description)
                ));
    }

    // Delete item
    public void deleteItem(int itemId) {
        itemCollection.deleteOne(Filters.eq("item_id", itemId));
    }

    // Get all items
    public List<Document> getAllItems() {
        List<Document> items = new ArrayList<>();
        for (Document doc : itemCollection.find()) {
            items.add(doc);
        }
        return items;
    }

    // Get item by ID
    public Document getItemById(int itemId) {
        return itemCollection.find(Filters.eq("item_id", itemId)).first();
    }
}
