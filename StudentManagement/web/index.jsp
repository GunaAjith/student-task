<%-- 
    Document   : index
    Created on : 19-Jan-2024, 6:13:08 pm
    Author     : Gunasekar R
--%>

<%
    if(request.getParameter("submit") != null){
        String roleNumber = request.getParameter("role_number");
        String name = request.getParameter("name");
        int english = Integer.parseInt(request.getParameter("english"));
        int tamil = Integer.parseInt(request.getParameter("tamil"));
        int maths = Integer.parseInt(request.getParameter("maths"));
        int science = Integer.parseInt(request.getParameter("science"));
        int social = Integer.parseInt(request.getParameter("social"));
        

        int total = english + tamil + maths + social + science;
       
        String result = "";
        if(english >= 35 && tamil >= 35 && maths >= 35 && social >= 35 && science >= 35){
         result = "Pass";}
        
         else{
         result = "Fail";}
         
         
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection("jdbc:sqlserver://127.0.0.1:1433;databaseName=db_student;TrustServerCertificate=True;user=student_task;password=student_task");
            String sql = "insert into tbl_student (role_number, name, english, tamil, maths, social, science, total, result) "
                    + "values (?, ?, ?, ?, ?, ?, ?, ?, ?)";
                    
             PreparedStatement statement = con.prepareStatement(sql);
                statement.setString(1, roleNumber);
                statement.setString(2, name);
                statement.setInt(3, english);
                statement.setInt(4, tamil);
                statement.setInt(5, maths);
                statement.setInt(6, science);
                statement.setInt(7, social);
                statement.setInt(8, total);
                statement.setString(9, result);
                statement.executeUpdate();  
                con.close();
                response.sendRedirect("index.jsp");
            }
          
%>

<%@page import="java.sql.*"%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Student Marks</title>
        <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
         <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            padding: 0;
            background-color: #f4f4f4;
        }
        h1, h2 {
            color: #333;
        }
        form {
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 5px;
            text-align: left;
        }

        th {
            background-color: #4CAF50;
            color: white;
        }
        input, button {
            padding: 4px;
            margin: 5px;
        }
        button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        

    </style>
    </head>
    <body>
     <h1>Student Marks</h1>
    <form  method="post">
        <label for="role_number">Role Number:</label>
        <input type="text" name="role_number"><br>
        <label for="name">Name:</label>
        <input type="text" name="name"><br>
        <label for="english">English:</label>
        <input type="number" name="english"><br>
        <label for="tamil">Tamil:</label>
        <input type="number" name="tamil"><br>
        <label for="maths">Maths:</label>
        <input type="number" name="maths"><br>
        <label for="science">Science:</label>
        <input type="number" name="science" required><br>
        <label for="social">Social:</label>
        <input type="number" name="social" required><br>
        <button type="submit" name="submit">Submit</button>
    </form>
<h2>Search Students</h2>
<form action="index.jsp" method="get">
    <label for="search">Search:</label>
    <input type="text" name="search" placeholder="Enter role number or name">
    <button type="submit">Search</button>
</form>



    <h2>Student List</h2>
   
    <table border="2">
        <tr>
            <th>Role Number</th>
            <th>Name</th>
            <th>English</th>
            <th>Tamil</th>
            <th>Maths</th>
            <th>Social</th>
            <th>Science</th>
            <th>Total</th>
            <th>Result</th>
        </tr>
   <%
            String searchKeyword = request.getParameter("search");

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            Connection con = DriverManager.getConnection("jdbc:sqlserver://127.0.0.1:1433;databaseName=db_student;TrustServerCertificate=True;user=student_task;password=student_task");

            String sql;
            PreparedStatement statement;

            if (searchKeyword != null) {
               
                sql = "select * from tbl_student where role_number like ? or name like ?";
                statement = con.prepareStatement(sql);
                statement.setString(1, "%" + searchKeyword + "%");
                statement.setString(2, "%" + searchKeyword + "%");
            } else {
              
                sql = "select * from tbl_student order by role_number";
                statement = con.prepareStatement(sql);
            }

            ResultSet resultSet = statement.executeQuery();
                while (resultSet.next()) {
        %>
                    <tr>
                        <td><%= resultSet.getString("role_number") %></td>
                        <td><%= resultSet.getString("name") %></td>
                        <td><%= resultSet.getInt("english") %></td>
                        <td><%= resultSet.getInt("tamil") %></td>
                        <td><%= resultSet.getInt("maths") %></td>
                        <td><%= resultSet.getInt("science") %></td>
                        <td><%= resultSet.getInt("social") %></td>
                        <td><%= resultSet.getInt("total") %></td>
                        <td><%= resultSet.getString("result") %></td>
                    </tr>
        <%
                }
            
            con.close();
        %>
    </table>
    </body>
</html>
