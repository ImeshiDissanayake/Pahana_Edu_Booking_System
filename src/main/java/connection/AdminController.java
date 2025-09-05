package connection;

import org.bson.Document;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/AdminController")
public class AdminController extends HttpServlet {
    private static final String SECURITY_CODE = "admin123";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AdminDAO dao = new AdminDAO();
        List<Document> admins = dao.getAllAdmins();
        request.setAttribute("admin", admins);
        request.getRequestDispatcher("adminManagement.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        AdminDAO dao = new AdminDAO();
        String action = request.getParameter("action");
        String securityCode = request.getParameter("security_code");

        // Security code validation
        if (!SECURITY_CODE.equals(securityCode)) {
            request.setAttribute("error", "Invalid security code. Operation denied.");
            request.setAttribute("admin", dao.getAllAdmins());
            request.getRequestDispatcher("adminManagement.jsp").forward(request, response);
            return;
        }

        try {
            if ("add".equals(action)) {
                dao.addAdmin(
                        request.getParameter("username"),
                        request.getParameter("password"),
                        request.getParameter("full_name"),
                        request.getParameter("email"),
                        request.getParameter("phone"),
                        request.getParameter("role")
                );
                request.setAttribute("message", "Admin added successfully!");
            } else if ("update".equals(action)) {
                int adminId = Integer.parseInt(request.getParameter("admin_id"));
                dao.updateAdmin(
                        adminId,
                        request.getParameter("username"),
                        request.getParameter("password"),
                        request.getParameter("full_name"),
                        request.getParameter("email"),
                        request.getParameter("phone"),
                        request.getParameter("role")
                );
                request.setAttribute("message", "Admin updated successfully!");
            } else if ("delete".equals(action)) {
                int adminId = Integer.parseInt(request.getParameter("admin_id"));
                dao.deleteAdmin(adminId);
                request.setAttribute("message", "Admin deleted successfully!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        request.setAttribute("admin", dao.getAllAdmins());
        request.getRequestDispatcher("adminManagement.jsp").forward(request, response);
    }
}
