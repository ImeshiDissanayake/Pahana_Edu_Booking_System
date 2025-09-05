<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%@ page import="connection.AdminDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Admin Management - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="CSS/adminManagement.css" rel="stylesheet" />
</head>
<body>

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Pahana Edu</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
        data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="customerManagement.jsp">Customers</a></li>
        <li class="nav-item"><a class="nav-link active" href="#">Admins</a></li>
        <li class="nav-item"><a class="nav-link" href="itemManagement.jsp">Items</a></li>
        <li class="nav-item"><a class="nav-link" href="billing.jsp">Billing</a></li>
        <li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Page Header -->
<div class="container mt-4">
    <h2 class="text-center mb-4">Admin Management</h2>

    <!-- Show Messages -->
    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");
        if (message != null) {
    %>
        <div class="alert alert-success"><%= message %></div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <!-- Admin Form -->
    <form id="adminForm" action="AdminController" method="post" class="shadow p-4 rounded bg-light">
        <input type="hidden" name="admin_id" id="admin_id" />

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="username" class="form-label">Username *</label>
                <input type="text" class="form-control" id="username" name="username" required />
            </div>
            <div class="col-md-6">
                <label for="password" class="form-label">Password *</label>
                <input type="password" class="form-control" id="password" name="password" />
                <small class="form-text text-muted">Leave blank if you don't want to change password on update.</small>
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="full_name" class="form-label">Full Name *</label>
                <input type="text" class="form-control" id="full_name" name="full_name" required />
            </div>
            <div class="col-md-6">
                <label for="email" class="form-label">Email *</label>
                <input type="email" class="form-control" id="email" name="email" required />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="phone" class="form-label">Phone Number</label>
                <input type="text" class="form-control" id="phone" name="phone" />
            </div>
            <div class="col-md-6">
                <label for="role" class="form-label">Role</label>
                <select class="form-select" id="role" name="role">
                    <option value="Admin">Admin</option>
                    <option value="Super Admin">Super Admin</option>
                    <option value="Moderator">Moderator</option>
                </select>
            </div>
        </div>

        <!-- Security Code -->
        <div class="mb-3">
            <label for="security_code" class="form-label">Security Code *</label>
            <input type="password" class="form-control" id="security_code" name="security_code" required />
        </div>

        <div class="d-flex gap-3">
            <button type="submit" name="action" value="add" class="btn btn-success">Add Admin</button>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Admin</button>
            <button type="submit" name="action" value="delete" class="btn btn-danger" 
                onclick="return confirm('Are you sure you want to delete this admin?');">Delete Admin</button>
            <button type="reset" class="btn btn-secondary" onclick="clearForm()">Clear Form</button>
        </div>
    </form>

    <!-- Admin List Table -->
    <div class="mt-5">
        <h4>Existing Admins</h4>
           <%
                    AdminDAO adminDAO = new AdminDAO();
                    List<Document> admins = adminDAO.getAllAdmins();
                %>
        <table class="table table-striped table-hover shadow-sm">
            <thead class="table-primary">
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    <%
        if (admins != null && !admins.isEmpty()) {
            for (Document admin : admins) {
    %>
                <tr>
                    <td><%= admin.getInteger("admin_id") %></td>
                    <td><%= admin.getString("username") %></td>
                    <td><%= admin.getString("full_name") %></td>
                    <td><%= admin.getString("email") %></td>
                    <td><%= admin.getString("phone") %></td>
                    <td><%= admin.getString("role") %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning"
                            onclick="populateForm('<%= admin.getInteger("admin_id") %>',
                                                  '<%= admin.getString("username") %>',
                                                  '<%= admin.getString("full_name") %>',
                                                  '<%= admin.getString("email") %>',
                                                  '<%= admin.getString("phone") %>',
                                                  '<%= admin.getString("role") %>')">
                            Edit
                        </button>
                    </td>
                </tr>
    <%
            }
        } else {
    %>
            <tr>
                <td colspan="7" class="text-center">No admins found.</td>
            </tr>
    <%
        }
    %>
</tbody>

        </table>
    </div>
</div>

<!-- Footer -->
<footer class="bg-primary text-white text-center py-3 mt-5">
    &copy; 2025 Pahana Edu Bookshop - All rights reserved
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    function populateForm(id, username, fullName, email, phone, role) {
        document.getElementById('admin_id').value = id;
        document.getElementById('username').value = username;
        document.getElementById('full_name').value = fullName;
        document.getElementById('email').value = email;
        document.getElementById('phone').value = phone;
        document.getElementById('role').value = role;
        document.getElementById('password').value = '';
        document.getElementById('security_code').value = '';
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function clearForm() {
        document.getElementById('admin_id').value = '';
        document.getElementById('password').value = '';
        document.getElementById('security_code').value = '';
    }
</script>

</body>
</html>
