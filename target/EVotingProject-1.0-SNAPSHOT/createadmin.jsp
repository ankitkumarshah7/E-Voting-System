<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
Connection con = DBConnection.getConnection();

String username = request.getParameter("username");

if(username != null){

    // CHECK DUPLICATE USERNAME

    PreparedStatement check =
    con.prepareStatement(
    "SELECT * FROM admin WHERE username=?");

    check.setString(1, username);

    ResultSet crs = check.executeQuery();

    if(crs.next()){
%>

<script>
alert("Username already exists!");
window.location="createadmin.jsp";
</script>

<%
        return;
    }

    // INSERT NEW ADMIN

    PreparedStatement ps =
    con.prepareStatement(
    "INSERT INTO admin(username,password,country,state,district) VALUES(?,?,?,?,?)");

    ps.setString(1, username);
    ps.setString(2, request.getParameter("password"));
    ps.setString(3, request.getParameter("country"));
    ps.setString(4, request.getParameter("state"));
    ps.setString(5, request.getParameter("district"));

    ps.executeUpdate();
%>

<script>
alert("District Admin Created Successfully");
window.location="viewadmin.jsp";
</script>

<%
    return;
}
%>

<!DOCTYPE html>
<html>
<head>

<title>Create District Admin</title>

<meta charset="UTF-8">

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{
    background:#f4f6f9;
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

<div class="container mt-5">

<div class="card-box">

<div class="title">
👨‍💼 Create District Admin
</div>

<form method="post">

<input type="text"
name="username"
class="form-control"
placeholder="Admin Username"
required>

<br>

<input type="password"
name="password"
class="form-control"
placeholder="Admin Password"
required>

<br>

<label>
<b>Select Country</b>
</label>

<select name="country"
class="form-select"
required>

<option value="">
Select Country
</option>

<%
Statement st1 = con.createStatement();

ResultSet rs1 =
st1.executeQuery(
"SELECT * FROM country");

while(rs1.next()){
%>

<option value="<%=rs1.getString("country_name")%>">

<%=rs1.getString("country_name")%>

</option>

<%
}
%>

</select>

<br>

<label>
<b>Select State</b>
</label>

<select name="state"
class="form-select"
required>

<option value="">
Select State
</option>

<%
Statement st2 = con.createStatement();

ResultSet rs2 =
st2.executeQuery(
"SELECT * FROM state");

while(rs2.next()){
%>

<option value="<%=rs2.getString("state_name")%>">

<%=rs2.getString("state_name")%>

</option>

<%
}
%>

</select>

<br>

<label>
<b>Select District</b>
</label>

<select name="district"
class="form-select"
required>

<option value="">
Select District
</option>

<%
Statement st3 = con.createStatement();

ResultSet rs3 =
st3.executeQuery(
"SELECT * FROM district");

while(rs3.next()){
%>

<option value="<%=rs3.getString("district_name")%>">

<%=rs3.getString("district_name")%>

</option>

<%
}
%>

</select>

<br>

<button type="submit"
class="btn btn-dark w-100">

Create Admin

</button>

</form>

<br>

<a href="superadmindashboard.jsp">

<button
class="btn btn-primary w-100">

⬅ Back Dashboard

</button>

</a>

</div>

</div>

</body>
</html>