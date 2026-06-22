<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String district = (String) session.getAttribute("district");

if (district == null) {
    response.sendRedirect("index.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<title>Voter Registration</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
      rel="stylesheet">

<style>

html,body{
    height:100%;
    margin:0;
    padding:0;
}

body{
    min-height:100vh;
    display:flex;
    flex-direction:column;

    font-family:Arial,sans-serif;

    background:
    linear-gradient(rgba(0,0,0,0.65),
    rgba(0,0,0,0.65)),
    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620');

    background-size:cover;
    background-position:center;
}

.main-container{
    flex:1;
    display:flex;
    justify-content:center;
    align-items:center;
    padding:30px;
}

.register-box{

    width:600px;

    background:white;

    padding:40px;

    border-radius:20px;

    box-shadow:0px 0px 20px rgba(0,0,0,0.4);
}

.icon{

    text-align:center;

    font-size:70px;

    margin-bottom:10px;
}

h2{

    text-align:center;

    color:#0d6efd;

    margin-bottom:25px;

    font-weight:bold;
}

.form-control{

    border-radius:10px;
}

.btn-register{

    width:100%;

    height:50px;

    border:none;

    border-radius:10px;

    font-size:18px;

    font-weight:bold;

    background:#0d6efd;

    color:white;
}

.btn-register:hover{

    background:#0b5ed7;
}

.back{

    text-align:center;

    margin-top:20px;
}

.back a{

    text-decoration:none;

    font-weight:bold;

    color:#0d6efd;
}

.footer{

    width:100%;

    background:rgba(0,0,0,0.85);

    color:white;

    text-align:center;

    padding:15px;

    font-size:18px;

    font-weight:bold;
}

.footer span{

    color:#00bfff;

    font-size:20px;
}

</style>

</head>

<body>

<div class="main-container">

<div class="register-box">

<div class="icon">
🗳️
</div>

<h2>Voter Registration</h2>

<form action="VoterRegister1"
      method="post"
      enctype="multipart/form-data">

<div class="mb-3">

<label class="form-label">Full Name</label>

<input type="text"
       name="full_name"
       class="form-control"
       required>

</div>

<div class="mb-3">

<label class="form-label">Password</label>

<input type="password"
       name="password"
       class="form-control"
       required>

</div>

<div class="mb-3">

<label class="form-label">Gender</label>

<select name="gender"
        class="form-control"
        required>

<option value="">Select Gender</option>

<option value="Male">Male</option>

<option value="Female">Female</option>

<option value="Other">Other</option>

</select>

</div>

<div class="mb-3">

<label class="form-label">Age</label>

<input type="number"
       name="age"
       class="form-control"
       min="18"
       required>

</div>

<div class="mb-3">

<label class="form-label">Mobile Number</label>

<input type="text"
       name="mobile"
       class="form-control"
       required>

</div>

<div class="mb-3">

<label class="form-label">Email</label>

<input type="email"
       name="email"
       class="form-control"
       required>

</div>

<div class="mb-3">

<label class="form-label">Address</label>

<textarea name="address"
          class="form-control"
          rows="3"
          required></textarea>

</div>

<div class="mb-3">
<label class="form-label">Country</label>

<input type="text"
class="form-control"
value="<%=session.getAttribute("country")%>"
readonly>
</div>

<div class="mb-3">
<label class="form-label">State</label>

<input type="text"
class="form-control"
value="<%=session.getAttribute("state")%>"
readonly>
</div>

<div class="mb-3">
<label class="form-label">District</label>

<input type="text"
class="form-control"
value="<%=session.getAttribute("district")%>"
readonly>
</div>

<div class="mb-3">

<label class="form-label">Location</label>

<select name="location"
        class="form-control"
        required>

<option value="">
Select Location
</option>

<%

try{

    Connection con =
    DBConnection.getConnection();

    PreparedStatement ps =
    con.prepareStatement(
    "SELECT location_name FROM location WHERE district=? ORDER BY location_name"
    );

    ps.setString(1,district);

    ResultSet rs =
    ps.executeQuery();

    while(rs.next()){

%>

<option value="<%=rs.getString("location_name")%>">

<%=rs.getString("location_name")%>

</option>

<%
    }

    rs.close();
    ps.close();
    con.close();

}catch(Exception e){

    out.println(
    "<option>Error Loading Locations</option>"
    );
}
%>

</select>

</div>

<div class="mb-4">

<label class="form-label">Upload Photo</label>

<input type="file"
       name="photo"
       class="form-control"
       accept="image/*"
       required>

</div>

<button type="submit"
        class="btn-register">

Register

</button>

</form>

<div class="back">

<a href="index.jsp">

← Back To Home

</a>

</div>

</div>

</div>

<div class="footer">

Developed By 🚀

<span>

ANKIT KUMAR SHAH

</span>

</div>

</body>
</html>