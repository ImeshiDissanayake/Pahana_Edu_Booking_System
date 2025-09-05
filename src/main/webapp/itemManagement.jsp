<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%@ page import="connection.ItemDAO" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Item Management - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="CSS/itemManagement.css" rel="stylesheet" />
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
        <li class="nav-item"><a class="nav-link" href="adminManagement.jsp">Admins</a></li>
        <li class="nav-item"><a class="nav-link active" href="#">Items</a></li>
        <li class="nav-item"><a class="nav-link" href="billingManagement.jsp">Billing</a></li>
        <li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<!-- Page Header -->
<div class="container mt-4">
    <h2 class="text-center mb-4">Item Management</h2>

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

    <!-- Item Form -->
    <form id="itemForm" action="ItemController" method="post" class="shadow p-4 rounded bg-light">
        <input type="hidden" name="item_id_hidden" id="item_id_hidden" />

        <div class="row mb-3">
            <div class="col-md-4">
                <label for="item_id" class="form-label">Item ID *</label>
                <input type="number" class="form-control" id="item_id" name="item_id" required />
            </div>
            <div class="col-md-8">
                <label for="item_name" class="form-label">Item Name *</label>
                <input type="text" class="form-control" id="item_name" name="item_name" required />
            </div>
        </div>

        <div class="row mb-3">
            <div class="col-md-4">
                <label for="price" class="form-label">Price *</label>
                <input type="number" step="0.01" class="form-control" id="price" name="price" required />
            </div>
            <div class="col-md-4">
                <label for="stock" class="form-label">Stock *</label>
                <input type="number" class="form-control" id="stock" name="stock" required />
            </div>
            <div class="col-md-4">
                <label for="description" class="form-label">Description</label>
                <input type="text" class="form-control" id="description" name="description" />
            </div>
        </div>

        <div class="d-flex gap-3">
            <button type="submit" name="action" value="add" class="btn btn-success">Add Item</button>
            <button type="submit" name="action" value="update" class="btn btn-primary">Update Item</button>
            <button type="submit" name="action" value="delete" class="btn btn-danger" 
                onclick="return confirm('Are you sure you want to delete this item?');">Delete Item</button>
            <button type="reset" class="btn btn-secondary" onclick="clearForm()">Clear Form</button>
        </div>
    </form>

    <!-- Item List Table -->
    <div class="mt-5">
        <h4>Existing Items</h4>
        <%
            ItemDAO itemDAO = new ItemDAO();
            List<Document> items = itemDAO.getAllItems();
        %>
        <table class="table table-striped table-hover shadow-sm">
            <thead class="table-primary">
                <tr>
                    <th>Item ID</th>
                    <th>Name</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Description</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
    <%
        if (items != null && !items.isEmpty()) {
            for (Document item : items) {
    %>
                <tr>
                    <td><%= item.getInteger("item_id") %></td>
                    <td><%= item.getString("item_name") %></td>
                    <td><%= item.get("price") != null ? ((Number) item.get("price")).doubleValue() : 0.0 %></td>
                    <td><%= item.getInteger("stock") %></td>
                    <td><%= item.getString("description") %></td>
                    <td>
                        <button type="button" class="btn btn-sm btn-warning"
                            onclick="populateForm('<%= item.getInteger("item_id") %>',
                                                  '<%= item.getString("item_name") %>',
                                                  '<%= item.get("price") != null ? ((Number) item.get("price")).doubleValue() : 0.0 %>',
                                                  '<%= item.getInteger("stock") %>',
                                                  '<%= item.getString("description") %>')">
                            Edit
                        </button>
                    </td>
                </tr>
    <%
            }
        } else {
    %>
            <tr>
                <td colspan="6" class="text-center">No items found.</td>
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
    function populateForm(id, name, price, stock, description) {
        document.getElementById('item_id').value = id;
        document.getElementById('item_name').value = name;
        document.getElementById('price').value = price;
        document.getElementById('stock').value = stock;
        document.getElementById('description').value = description;
        window.scrollTo({top: 0, behavior: 'smooth'});
    }

    function clearForm() {
        document.getElementById('item_id').value = '';
        document.getElementById('item_name').value = '';
        document.getElementById('price').value = '';
        document.getElementById('stock').value = '';
        document.getElementById('description').value = '';
    }
</script>

</body>
</html>
