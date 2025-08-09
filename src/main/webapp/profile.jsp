<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.pahanaedu3.Models.User" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile - Pahana EduBill</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        /* ========== Body Styles ========== */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f7f7f7;
            margin: 0;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            background: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 8px #0001;
            padding: 32px 32px 24px 32px;
        }

        /* ========== Heading Styles ========== */
        h2 {
            color: #2c3e50;
            margin-bottom: 24px;
        }

        /* ========== Back Arrow ========== */
        .back-arrow {
            position: absolute;
            top: 30px;
            left: 30px;
            font-size: 2rem;
            color: #2563eb;
            text-decoration: none;
            font-weight: bold;
            background: #fff;
            border-radius: 50%;
            width: 40px;
            height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 2px 8px rgba(38,99,235,0.08);
            transition: background 0.2s, color 0.2s;
            z-index: 10;
        }

        .back-arrow:hover {
            background: #babae3;
            color: #fff;
        }

        /* ========== Profile Section Styles ========== */
        .profile-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 24px;
            margin-bottom: 24px;
            border: 1px solid #e1e5e9;
        }

        .section-title {
            font-size: 1.2rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* ========== User Avatar ========== */
        .user-avatar {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 2rem;
            margin-bottom: 20px;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }

        /* ========== Info Row Styles ========== */
        .info-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #e1e5e9;
            font-size: 14px;
        }

        .info-row:last-child {
            border-bottom: none;
        }

        .info-label {
            font-weight: 600;
            color: #2c3e50;
        }

        .info-value {
            color: #6c757d;
            font-weight: 500;
        }

        /* ========== Form Group Styles ========== */
        .form-group {
            margin-bottom: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 6px;
            font-weight: 600;
            color: #2c3e50;
        }

        .form-control {
            width: 100%;
            padding: 10px 12px;
            border: 2px solid #e1e5e9;
            border-radius: 4px;
            font-size: 14px;
            transition: border-color 0.2s;
            background: white;
        }

        .form-control:focus {
            outline: none;
            border-color: #27ae60;
        }

        /* ========== Button Styles ========== */
        .btn {
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            cursor: pointer;
            font-weight: 500;
            transition: background 0.2s;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 14px;
        }

        .btn-primary {
            background: #27ae60;
            color: #fff;
        }

        .btn-primary:hover {
            background: #1e8449;
        }

        .btn-secondary {
            background: #6c757d;
            color: #fff;
        }

        .btn-secondary:hover {
            background: #545b62;
        }

        /* ========== Alert Styles ========== */
        .alert {
            padding: 12px 16px;
            border-radius: 6px;
            margin-bottom: 16px;
            font-weight: 500;
        }

        .alert.success {
            background: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .alert.error {
            background: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        /* ========== Responsive Design ========== */
        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
                padding: 20px;
            }
            
            .info-row {
                flex-direction: column;
                gap: 4px;
            }
        }
    </style>
</head>
<body>
<%
    String role = (String) session.getAttribute("role");
    String dashboardUrl = "admin-dashboard.jsp";
    if ("staff".equalsIgnoreCase(role)) {
        dashboardUrl = "staff-dashboard.jsp";
    }
%>
<a href="<%= dashboardUrl %>" class="back-arrow" title="Back to Dashboard">
    &#8592;
</a>
    
    <div class="container">
        <h2><i class="fas fa-user"></i> User Profile</h2>

        <!-- Alert Messages -->
        <% if (request.getAttribute("success") != null) { %>
            <div class="alert success">
                <i class="fas fa-check-circle"></i> <%= request.getAttribute("success") %>
            </div>
        <% } %>
        
        <% if (request.getAttribute("error") != null) { %>
            <div class="alert error">
                <i class="fas fa-exclamation-circle"></i> <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <!-- Profile Information Section -->
        <div class="profile-section">
            <div class="user-avatar">
                <i class="fas fa-user"></i>
            </div>
            
            <div class="section-title">
                <i class="fas fa-info-circle"></i> Account Information
            </div>
            
            <% User user = (User) request.getAttribute("user"); %>
            <% if (user != null) { %>
                <div class="info-row">
                    <span class="info-label">Username:</span>
                    <span class="info-value"><%= user.getUsername() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Role:</span>
                    <span class="info-value"><%= user.getRole().toUpperCase() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">User ID:</span>
                    <span class="info-value"><%= user.getId() %></span>
                </div>
            <% } %>
        </div>

        <!-- Change Password Section -->
        <div class="profile-section">
            <div class="section-title">
                <i class="fas fa-key"></i> Change Password
            </div>
            
            <form method="post" action="profile">
                <div class="form-group">
                    <label for="currentPassword">Current Password</label>
                    <input type="password" id="currentPassword" name="currentPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="newPassword">New Password</label>
                    <input type="password" id="newPassword" name="newPassword" class="form-control" required>
                </div>
                <div class="form-group">
                    <label for="confirmPassword">Confirm New Password</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary">
                    <i class="fas fa-key"></i> Update Password
                </button>
            </form>
        </div>
    </div>
</body>
</html>
