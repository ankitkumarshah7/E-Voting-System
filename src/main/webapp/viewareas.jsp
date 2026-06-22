<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%

Connection con =
DBConnection.getConnection();

/* DELETE DISTRICT */

String deleteId =
request.getParameter("deleteId");

if(deleteId != null){

    try{

        PreparedStatement ps =
        con.prepareStatement(
        "DELETE FROM district WHERE district_id=?");

        ps.setInt(1,
        Integer.parseInt(deleteId));

        ps.executeUpdate();

%>

<script>

alert("District Deleted Successfully");

window.location="viewareas.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);

    }

}

/* VIEW ALL AREAS */

Statement st =
con.createStatement();

ResultSet rs =
st.executeQuery(

"SELECT d.district_id," +
"c.country_name," +
"s.state_name," +
"d.district_name " +

"FROM country c " +

"JOIN state s " +
"ON c.country_id=s.country_id " +

"JOIN district d " +
"ON s.state_id=d.state_id " +

"ORDER BY c.country_name,s.state_name,d.district_name"

);

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>View Areas</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    background:#f4f6f9;

    padding:30px;
}

.title{

    text-align:center;

    font-size:40px;

    font-weight:bold;

    margin-bottom:25px;

    color:#0d6efd;
}

.table-box{

    background:white;

    padding:20px;

    border-radius:15px;

    box-shadow:0px 0px 15px rgba(0,0,0,0.2);
}

.footer{

    margin-top:30px;

    text-align:center;

    font-size:18px;

    font-weight:bold;
}

.footer span{

    color:#0d6efd;
}

</style>

</head>

<body>

<div class="container">

<div class="title">

🌍 All Election Areas

</div>

<div class="table-box">

<table class="table table-bordered table-hover">

<tr class="table-dark">

<th>Country</th>

<th>State</th>

<th>District</th>

<th>Action</th>

</tr>

<%

while(rs.next()){

%>

<tr>

<td>

<%=rs.getString("country_name")%>

</td>

<td>

<%=rs.getString("state_name")%>

</td>

<td>

<%=rs.getString("district_name")%>

</td>

<td>

<a href=
"viewareas.jsp?deleteId=<%=rs.getInt("district_id")%>"
onclick=
"return confirm('Are you sure you want to delete this district?')">

<button class="btn btn-danger btn-sm">

🗑 Delete

</button>

</a>

</td>

</tr>

<%

}

%>

</table>

</div>

<div class="text-center mt-3">

<a href="superadmindashboard.jsp">

<button class="btn btn-primary">

⬅ Back Dashboard

</button>

</a>

</div>

<div class="footer">

Developed By 🚀

<span>

ANKIT KUMAR SHAH

</span>

</div>

</div>

</body>

</html>