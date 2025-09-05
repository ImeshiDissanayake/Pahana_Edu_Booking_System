package connection;

import connection.BillingDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/billControl")
public class BillingControl extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String customerName = request.getParameter("customerName");
            String itemName = request.getParameter("itemName");
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            double totalBill = Double.parseDouble(request.getParameter("totalBill"));

            BillingDAO billingDAO = new BillingDAO();
            billingDAO.addBill(customerName, itemName, quantity, totalBill);

            // Redirect back with success message
            response.sendRedirect("billingManagement.jsp?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("billingManagement.jsp?error=1");
        }
    }
}
