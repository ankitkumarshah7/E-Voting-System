<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%

String country = request.getParameter("country");

if(country != null && !country.trim().isEmpty()){

    Connection con = DBConnection.getConnection();

    PreparedStatement ps =
    con.prepareStatement(
    "INSERT INTO country(country_name) VALUES(?)");

    ps.setString(1, country);

    ps.executeUpdate();

    con.close();

    response.sendRedirect("addcountry.jsp?success=1");
}

%>

<!DOCTYPE html>
<html>

<head>

<title>Add Country</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    margin:0;
    padding:0;

    font-family:Arial,sans-serif;

    background:
    linear-gradient(
    rgba(0,0,0,0.70),
    rgba(0,0,0,0.70)
    ),

    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1600&auto=format&fit=crop');

    background-size:cover;
    background-position:center;

    min-height:100vh;

    display:flex;

    justify-content:center;

    align-items:center;
}

.form-box{

    width:500px;

    background:rgba(255,255,255,0.95);

    padding:35px;

    border-radius:25px;

    box-shadow:0px 0px 25px rgba(0,0,0,0.4);
}

.title{

    text-align:center;

    font-size:35px;

    font-weight:bold;

    color:#0d6efd;

    margin-bottom:25px;
}

.form-control{

    height:50px;

    border-radius:10px;
}

.btn-save{

    width:100%;

    height:50px;

    font-size:18px;

    font-weight:bold;

    border-radius:10px;
}

.back-btn{

    width:100%;

    margin-top:10px;

    height:50px;

    border-radius:10px;

    font-size:18px;

    font-weight:bold;
}

</style>

</head>

<body>

<div class="form-box">

<div class="title">

🌍 Add Country

</div>

<%

if(request.getParameter("success") != null){

%>

<div class="alert alert-success text-center">

Country Added Successfully

</div>

<%

}

%>

<form method="post">

<input
type="text"
name="country"
class="form-control"
placeholder="Enter Country Name"
required>

<br>

<button
type="submit"
class="btn btn-primary btn-save">

💾 Save Country

</button>

</form>

<a href="superadmindashboard.jsp">

<button
class="btn btn-secondary back-btn">

⬅ Back To Dashboard

</button>

</a>

</div>

</body>
</html>