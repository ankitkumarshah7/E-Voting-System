<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%

Connection con = DBConnection.getConnection();

String district = request.getParameter("district");
String state = request.getParameter("state");

if(district != null &&
   state != null &&
   !district.trim().isEmpty()){

    PreparedStatement ps =
    con.prepareStatement(
    "INSERT INTO district(state_id,district_name) VALUES(?,?)");

    ps.setInt(1,
    Integer.parseInt(state));

    ps.setString(2,
    district);

    ps.executeUpdate();

    response.sendRedirect(
    "adddistrict.jsp?success=1");

    return;
}

%>

<!DOCTYPE html>
<html>

<head>

<title>Add District</title>

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

    width:550px;

    background:rgba(255,255,255,0.95);

    padding:35px;

    border-radius:25px;

    box-shadow:0px 0px 25px rgba(0,0,0,0.4);
}

.title{

    text-align:center;

    font-size:35px;

    font-weight:bold;

    color:#fd7e14;

    margin-bottom:25px;
}

.form-select,
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

    font-size:18px;

    font-weight:bold;

    border-radius:10px;
}

</style>

</head>

<body>

<div class="form-box">

<div class="title">

🏙 Add District

</div>

<%

if(request.getParameter("success") != null){

%>

<div class="alert alert-success text-center">

District Added Successfully

</div>

<%

}

%>

<form method="post">

<select
name="state"
class="form-select"
required>

<option value="">

Select State

</option>

<%

Statement st =
con.createStatement();

ResultSet rs =
st.executeQuery(
"SELECT * FROM state");

while(rs.next()){

%>

<option value="<%= rs.getInt("state_id") %>">

<%= rs.getString("state_name") %>

</option>

<%

}

rs.close();
st.close();

%>

</select>

<br>

<input
type="text"
name="district"
class="form-control"
placeholder="Enter District Name"
required>

<br>

<button
type="submit"
class="btn btn-warning btn-save">

💾 Save District

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

<%

con.close();

%>