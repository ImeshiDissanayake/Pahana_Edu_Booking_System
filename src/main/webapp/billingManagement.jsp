<%@ page import="java.util.List" %>
<%@ page import="org.bson.Document" %>
<%@ page import="connection.ItemDAO" %>
<%@ page import="connection.CustomerDAO" %>

<%
    ItemDAO itemDAO = new ItemDAO();
    CustomerDAO customerDAO = new CustomerDAO();

    List<Document> items = itemDAO.getAllItems();
    List<Document> customers = customerDAO.getAllCustomers();

    String success = request.getParameter("success");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Billing Management - Pahana Edu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link rel="stylesheet" href="CSS/billing.css">

    <script>
        let itemPrices = {};

        function updatePrice() {
            let itemSelect = document.getElementById("itemSelect");
            let selectedItem = itemSelect.value;
            let price = itemPrices[selectedItem] || 0;
            document.getElementById("price").value = price.toFixed(2);
            calculateTotal();
        }

        function calculateTotal() {
            let price = parseFloat(document.getElementById("price").value) || 0;
            let qty = parseInt(document.getElementById("quantity").value) || 0;
            let total = price * qty;
            document.getElementById("totalBill").value = total.toFixed(2);
        }

        function printBill() {
            // Collect form values
            const item = document.getElementById("itemSelect").value;
            const price = document.getElementById("price").value;
            const customer = document.querySelector('select[name="customerName"]').value;
            const quantity = document.getElementById("quantity").value;
            const total = document.getElementById("totalBill").value;

            // Build HTML for print
            const billHtml = `
                <html>
                <head>
                    <title>Bill - Pahana Edu</title>
                    <style>
                        body { font-family: Arial, sans-serif; margin: 40px; }
                        h2 { color: #0d6efd; text-align: center; }
                        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
                        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
                        th { background-color: #f0f0f0; }
                        footer { margin-top: 40px; font-style: italic; text-align: center; }
                    </style>
                </head>
                <body>
                    <h2>Pahana Edu Bookshop</h2>
                    <p><strong>Customer:</strong> ${customer}</p>
                    <table>
                        <thead>
                            <tr>
                                <th>Item</th>
                                <th>Price (each)</th>
                                <th>Quantity</th>
                                <th>Total</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>${item}</td>
                                <td>${price}</td>
                                <td>${quantity}</td>
                                <td>${total}</td>
                            </tr>
                        </tbody>
                    </table>
                    <footer>Thank you for your purchase!</footer>
                </body>
                </html>
            `;

            const printWindow = window.open('', '_blank', 'width=600,height=600');
            printWindow.document.open();
            printWindow.document.write(billHtml);
            printWindow.document.close();

            printWindow.onload = function() {
                printWindow.focus();
                printWindow.print();
                printWindow.close();
            };
        }

        window.addEventListener('DOMContentLoaded', () => {
            updatePrice(); // Initialize first item price
        });
    </script>
</head>

<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">Pahana Edu</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" 
        data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" 
        aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav ms-auto">
        <li class="nav-item"><a class="nav-link" href="customerManagement.jsp">Customers</a></li>
        <li class="nav-item"><a class="nav-link" href="adminManagement.jsp">Admins</a></li>
        <li class="nav-item"><a class="nav-link" href="itemManagement.jsp">Items</a></li>
        <li class="nav-item"><a class="nav-link active" aria-current="page" href="#">Billing</a></li>
        <li class="nav-item"><a class="nav-link" href="help.jsp">Help</a></li>
        <li class="nav-item"><a class="nav-link" href="logout.jsp">Logout</a></li>
      </ul>
    </div>
  </div>
</nav>

<div class="container mt-4">
    <% if ("true".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Bill submitted successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <h2 class="text-center my-4">Billing Management</h2>

    <form id="billingForm" action="billControl" method="post" class="mx-auto" style="max-width:600px;">
        <!-- Item Dropdown -->
        <label>Item Name:</label>
        <select name="itemName" id="itemSelect" class="form-select" onchange="updatePrice()" required>
            <option value="">--Select Item--</option>
            <% for (Document item : items) { %>
                <option value="<%= item.getString("item_name") %>"><%= item.getString("item_name") %></option>
                <script>
                    itemPrices["<%= item.getString("item_name") %>"] = <%= item.get("price") != null ? ((Number)item.get("price")).doubleValue() : 0 %>;
                </script>
            <% } %>
        </select>

        <!-- Price -->
        <label class="mt-3">Price:</label>
        <input type="text" id="price" class="form-control" readonly>

        <!-- Customer Dropdown -->
        <label class="mt-3">Customer Name:</label>
        <select name="customerName" class="form-select" required>
            <option value="">--Select Customer--</option>
            <% for (Document customer : customers) { %>
                <option value="<%= customer.getString("name") %>"><%= customer.getString("name") %></option>
            <% } %>
        </select>

        <!-- Quantity -->
        <label class="mt-3">Quantity:</label>
        <input type="number" id="quantity" name="quantity" class="form-control" min="1" value="1" onchange="calculateTotal()" oninput="calculateTotal()" required>

        <!-- Total Bill -->
        <label class="mt-3">Total Bill:</label>
        <input type="text" id="totalBill" name="totalBill" class="form-control" readonly>

        <div class="d-flex gap-2 mt-4">
            <button type="button" class="btn btn-outline-secondary flex-grow-1" onclick="printBill()">Print Bill</button>
            <button type="submit" class="btn btn-primary flex-grow-1">Submit Bill</button>
        </div>
    </form>
</div>

<footer class="bg-primary text-white text-center py-3 mt-5">
    &copy; 2025 Pahana Edu Bookshop - All rights reserved
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
