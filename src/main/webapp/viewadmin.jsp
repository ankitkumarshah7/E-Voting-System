<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%

String deleteId=request.getParameter("deleteId");

if(deleteId!=null){

Connection con=DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(
"DELETE FROM admin WHERE admin_id=?");

ps.setInt(1,Integer.parseInt(deleteId));

ps.executeUpdate();

con.close();

response.sendRedirect("viewadmin.jsp");

return;
}

%>

<!DOCTYPE html>
<html>
<head>

<title>District Admin List</title>

<meta charset="UTF-8">

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

background:#f4f6f9;

padding:30px;
}

.title{

font-size:40px;

font-weight:bold;

margin-bottom:25px;

text-align:center;
}

.card-box{

background:white;

padding:25px;

border-radius:20px;

box-shadow:0px 0px 15px rgba(0,0,0,0.2);
}

table{

text-align:center;
}

.footer{

margin-top:30px;

text-align:center;

font-weight:bold;
}

</style>

</head>

<body>

<div class="container">

<div class="title">

👨‍💼 District Admin Management

</div>

<div class="card-box">

<table class="table table-bordered table-hover">

<tr class="table-dark">

<th>ID</th>

<th>Username</th>

<th>Country</th>

<th>State</th>

<th>District</th>

<th>Created At</th>

<th>Action</th>

</tr>

<%

Connection con=
DBConnection.getConnection();

PreparedStatement ps=
con.prepareStatement(
"SELECT * FROM admin ORDER BY admin_id");

ResultSet rs=
ps.executeQuery();

while(rs.next()){

%>

<tr>

<td>

<%=rs.getInt("admin_id")%>

</td>

<td>

<%=rs.getString("username")%>

</td>

<td>

<%=rs.getString("country")%>

</td>

<td>

<%=rs.getString("state")%>

</td>

<td>

<%=rs.getString("district")%>

</td>

<td>

<%=rs.getTimestamp("created_at")%>

</td>

<td>

<a href=
"viewadmin.jsp?deleteId=<%=rs.getInt("admin_id")%>"
onclick=
"return confirm('Delete this admin?')">

<button class="btn btn-danger">

Delete

</button>

</a>

</td>

</tr>

<%

}

con.close();

%>

</table>

<a href="superadmindashboard.jsp">

<button class="btn btn-primary">

⬅ Back Dashboard

</button>

</a>

</div>

<div class="footer">

Developed By 🚀 ANKIT KUMAR SHAH

</div>

</div>

</body>
</html>