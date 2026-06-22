<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%

Connection con =
DBConnection.getConnection();

String district =
(String)session.getAttribute("district");

/* DELETE LOCATION */

String deleteId =
request.getParameter("deleteId");

if(deleteId!=null){

PreparedStatement dps =
con.prepareStatement(
"DELETE FROM location WHERE location_id=?");

dps.setInt(1,
Integer.parseInt(deleteId));

dps.executeUpdate();

response.sendRedirect(
"addlocation.jsp");

return;
}

/* ADD LOCATION */

String location =
request.getParameter("location");

if(location!=null &&
!location.trim().equals("")){

PreparedStatement ps =
con.prepareStatement(

"INSERT INTO location(location_name,district) VALUES(?,?)"

);

ps.setString(1,location);

ps.setString(2,district);

ps.executeUpdate();

response.sendRedirect(
"addlocation.jsp");

return;
}

%>

<!DOCTYPE html>
<html>
<head>

<title>Manage Locations</title>

<meta charset="UTF-8">

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

background:#f4f6f9;

padding:30px;
}

.card-box{

background:white;

padding:30px;

border-radius:20px;

box-shadow:0px 0px 15px rgba(0,0,0,0.2);
}

.title{

text-align:center;

font-size:35px;

font-weight:bold;

margin-bottom:25px;
}

</style>

</head>

<body>

<div class="container">

<div class="card-box">

<div class="title">

📍 Manage Locations

</div>

<h5>

District :
<b>

<%=district%>

</b>

</h5>

<hr>

<form method="post">

<div class="row">

<div class="col-md-9">

<input type="text"
name="location"
class="form-control"
placeholder="Enter Location Name"
required>

</div>

<div class="col-md-3">

<button
class="btn btn-success w-100">

➕ Add Location

</button>

</div>

</div>

</form>

<hr>

<h4>

📋 Location List

</h4>

<table class="table table-bordered table-hover">

<tr class="table-dark">

<th>ID</th>

<th>Location Name</th>

<th>District</th>

<th>Action</th>

</tr>

<%

PreparedStatement ps =
con.prepareStatement(

"SELECT * FROM location WHERE district=? ORDER BY location_id DESC"

);

ps.setString(1,district);

ResultSet rs =
ps.executeQuery();

while(rs.next()){

%>

<tr>

<td>

<%=rs.getInt("location_id")%>

</td>

<td>

<%=rs.getString("location_name")%>

</td>

<td>

<%=rs.getString("district")%>

</td>

<td>

<a href=
"addlocation.jsp?deleteId=<%=rs.getInt("location_id")%>"
onclick=
"return confirm('Delete this location?')">

<button
class="btn btn-danger">

🗑 Delete

</button>

</a>

</td>

</tr>

<%
}
%>

</table>

<br>

<a href="admindashboard.jsp">

<button
class="btn btn-primary">

⬅ Back Dashboard

</button>

</a>

</div>

</div>

</body>
</html>