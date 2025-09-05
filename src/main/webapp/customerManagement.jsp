<%@page import="connection.CustomerDAO"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Customer Management - Pahana Edu</title>
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
        <li class="nav-item"><a class="nav-link active" aria-current="page" href="#">Customers</a></li>
        <li class="nav-item"><a class="nav-link" href="adminManagement.jsp">Admins</a></li>
        <li class="nav-item"><a class="nav-link" href="itemManagement.jsp">Items</a></li>
        <li class="nav-item"><a class="nav-link" href="billingManagement.jsp">Billing</a></li>
        <li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Page Header -->
<div class="container mt-4">
    <h2 class="text-center mb-4">Customer Management</h2>

    <!-- Show Messages -->
    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");
        if (message != null) {
    %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if (error != null) { %>
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <%= error %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <!-- Customer Form -->
    <form id="customerForm" action="CustomerServlet" method="post" class="shadow p-4 rounded bg-light">

        <div class="row mb-3">
        <div class="col-md-6">
            <label for="account_number" class="form-label">Account Number *</label>
            <input type="number" class="form-control" id="account_number" name="account_number" required min="1" />
            <small class="form-text text-muted">Must be a unique number.</small>
        </div>
        </div>
        
        <div class="row mb-3">
            <div class="col-md-6">
                <label for="name" class="form-label">Name *</label>
                <input type="text" class="form-control" id="name" name="name" required />
            </div>
            <div class="col-md-6">
                <label for="address" class="form-label">Address *</label>
                <input type="text" class="form-control" id="address" name="address" required />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="telephone" class="form-label">Telephone *</label>
                <input type="text" class="form-control" id="telephone" name="telephone" required />
            </div>
            <div class="col-md-6">
                <label for="units_consumed" class="form-label">Units Consumed *</label>
                <input type="number" class="form-control" id="units_consumed" name="units_consumed" required min="0" />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="username" class="form-label">Username *</label>
                <input type="text" class="form-control" id="username" name="username" required />
            </div>
            <div class="col-md-6">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Leave blank if you don't want to change password on update" />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-6">
                <label for="registration_date" class="form-label">Registration Date *</label>
                <input type="date" class="form-control" id="registration_date" name="registration_date" required />
            </div>
            <div class="col-md-6">
                <label for="status" class="form-label">Status *</label>
                <select class="form-select" id="status" name="status" required>
                    <option value="Active">Active</option>
                    <option value="Inactive">Inactive</option>
                </select>
            </div>
        </div>

        <!-- Security Code -->
        <div class="mb-3">
            <label for="security_code" class="form-label">Security Code *</label>
            <input type="password" class="form-control" id="security_code" name="security_code" required />
        </div>

        <div class="d-flex gap-3">
            <button type="submit" name="action" value="add" class="btn btn-success">Add Customer</button>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Customer</button>
            <button type="submit" name="action" value="delete" class="btn btn-danger"
                    onclick="return confirm('Are you sure you want to delete this customer?');">Delete Customer</button>
            <button type="reset" class="btn btn-secondary" onclick="clearForm()">Clear Form</button>
        </div>
    </form>

    <!-- Customer List Table -->
    <div class="mt-5">
        <h4>Existing Customers</h4>
        <%
                    CustomerDAO cusDAO = new CustomerDAO();
                    List<Document> customers = cusDAO.getAllCustomers();
                %>
        <table class="table table-striped table-hover shadow-sm">
            <thead class="table-primary">
                <tr>
                    <th>Account Number</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Telephone</th>
                    <th>Units Consumed</th>
                    <th>Username</th>
                    <th>Registration Date</th>
                    <th>Status</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    <%
        if (customers != null && !customers.isEmpty()) {
            for (Document customer : customers) {
    %>
                <tr>
                    <td><%= customer.getInteger("account_number") %></td>
                    <td><%= customer.getString("name") %></td>
                    <td><%= customer.getString("address") %></td>
                    <td><%= customer.getString("telephone") %></td>
                    <td><%= customer.getInteger("units_consumed") %></td>
                    <td><%= customer.getString("username") %></td>
                    <td><%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(customer.getDate("registration_date")) %></td>
                    <td><%= customer.getString("status") %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning"
                            onclick="populateForm(
                                '<%= customer.getInteger("account_number") %>',
                                '<%= customer.getString("name").replace("'", "\\'") %>',
                                '<%= customer.getString("address").replace("'", "\\'") %>',
                                '<%= customer.getString("telephone").replace("'", "\\'") %>',
                                '<%= customer.getInteger("units_consumed") %>',
                                '<%= customer.getString("username").replace("'", "\\'") %>',
                                '',
                                '<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(customer.getDate("registration_date")) %>',
                                '<%= customer.getString("status") %>'
                            )">
                            Edit
                        </button>
                    </td>
                </tr>
    <%
            }
        } else {
    %>
            <tr>
                <td colspan="9" class="text-center">No customers found.</td>
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
    function populateForm(accountNumber, name, address, telephone, unitsConsumed, username, password, regDate, status) {
        document.getElementById('account_number').value = accountNumber;
        document.getElementById('name').value = name;
        document.getElementById('address').value = address;
        document.getElementById('telephone').value = telephone;
        document.getElementById('units_consumed').value = unitsConsumed;
        document.getElementById('username').value = username;
        document.getElementById('password').value = ''; // always clear password for security
        document.getElementById('registration_date').value = regDate;
        document.getElementById('status').value = status;
        document.getElementById('security_code').value = '';
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function clearForm() {
        document.getElementById('account_number').value = '';
        document.getElementById('name').value = '';
        document.getElementById('address').value = '';
        document.getElementById('telephone').value = '';
        document.getElementById('units_consumed').value = '';
        document.getElementById('username').value = '';
        document.getElementById('password').value = '';
        document.getElementById('registration_date').value = '';
        document.getElementById('status').value = 'Active';
        document.getElementById('security_code').value = '';
    }
</script>

</body>
</html>
