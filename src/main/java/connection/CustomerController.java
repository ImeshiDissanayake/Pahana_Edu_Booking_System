package connection;

import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet("/CustomerServlet")
public class CustomerController extends HttpServlet {

    private static final String ADMIN_SECURITY_CODE = "admin123";

    private CustomerDAO customerDAO;

    @Override
    public void init() {
        customerDAO = new CustomerDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        String securityCode = request.getParameter("security_code");

        if (!ADMIN_SECURITY_CODE.equals(securityCode)) {
            request.setAttribute("error", "Invalid Security Code! Action denied.");
            loadCustomersAndForward(request, response);
            return;
        }

        try {
            int accountNumber = 0;
            String accountNumStr = request.getParameter("account_number");
            if (accountNumStr != null && !accountNumStr.isEmpty()) {
                accountNumber = Integer.parseInt(accountNumStr);
            }
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            int unitsConsumed = Integer.parseInt(request.getParameter("units_consumed"));
            String username = request.getParameter("username");
            String password = request.getParameter("password"); // may be empty on update
            String registrationDateStr = request.getParameter("registration_date");
            String status = request.getParameter("status");

            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date registrationDate = sdf.parse(registrationDateStr);

            Document customerDoc = new Document()
                    .append("account_number", accountNumber)
                    .append("name", name)
                    .append("address", address)
                    .append("telephone", telephone)
                    .append("units_consumed", unitsConsumed)
                    .append("username", username)
                    .append("password", password)
                    .append("registration_date", registrationDate)
                    .append("status", status);

            String message = null;
            String error = null;

            switch (action) {
                case "add":
                    if (accountNumber == 0) {
                        error = "Account Number is required for adding customer.";
                    } else {
                        boolean added = customerDAO.addCustomer(customerDoc);
                        if (added) {
                            message = "Customer added successfully!";
                        } else {
                            error = "Customer with this Account Number already exists.";
                        }
                    }
                    break;

                case "update":
                    if (accountNumber == 0) {
                        error = "Account Number is required for updating customer.";
                    } else {
                        boolean updated = customerDAO.updateCustomer(customerDoc);
                        if (updated) {
                            message = "Customer updated successfully!";
                        } else {
                            error = "Customer not found with this Account Number.";
                        }
                    }
                    break;

                case "delete":
                    if (accountNumber == 0) {
                        error = "Account Number is required for deleting customer.";
                    } else {
                        boolean deleted = customerDAO.deleteCustomer(accountNumber);
                        if (deleted) {
                            message = "Customer deleted successfully!";
                        } else {
                            error = "Customer not found with this Account Number.";
                        }
                    }
                    break;

                default:
                    error = "Unknown action: " + action;
            }

            if (message != null) {
                request.setAttribute("message", message);
            }
            if (error != null) {
                request.setAttribute("error", error);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error processing request: " + e.getMessage());
        }

        loadCustomersAndForward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        loadCustomersAndForward(request, response);
    }

    private void loadCustomersAndForward(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    List<Document> customers = customerDAO.getAllCustomers();
    request.setAttribute("customer", customers);
    request.getRequestDispatcher("customerManagement.jsp").forward(request, response);
}

}
