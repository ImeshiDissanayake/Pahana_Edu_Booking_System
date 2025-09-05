package connection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/ItemController")
public class ItemController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        ItemDAO itemDAO = new ItemDAO();

        try {
            int itemId = Integer.parseInt(request.getParameter("item_id"));
            String name = request.getParameter("item_name");
            double price = Double.parseDouble(request.getParameter("price"));
            int stock = Integer.parseInt(request.getParameter("stock"));
            String description = request.getParameter("description");

            if ("add".equalsIgnoreCase(action)) {
                itemDAO.addItem(itemId, name, price, stock, description);
                request.setAttribute("message", "Item added successfully!");

            } else if ("update".equalsIgnoreCase(action)) {
                itemDAO.updateItem(itemId, name, price, stock, description);
                request.setAttribute("message", "Item updated successfully!");

            } else if ("delete".equalsIgnoreCase(action)) {
                itemDAO.deleteItem(itemId);
                request.setAttribute("message", "Item deleted successfully!");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format for ID, price, or stock.");
        } catch (Exception e) {
            request.setAttribute("error", "Error: " + e.getMessage());
        }

        request.getRequestDispatcher("itemManagement.jsp").forward(request, response);
    }
}
