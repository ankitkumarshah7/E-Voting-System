<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>

<%
if(session.getAttribute("voter_id")==null){

    response.sendRedirect("voterlogin.html");
    return;
}

int voter_id =
Integer.parseInt(session.getAttribute("voter_id").toString());

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;

String full_name = "";
String gender = "";
int age = 0;
String mobile = "";
String email = "";
String address = "";
String location = "";
String district = "";

try{

    con = DBConnection.getConnection();

    String query =
    "SELECT * FROM voter WHERE voter_id=?";

    ps = con.prepareStatement(query);

    ps.setInt(1, voter_id);

    rs = ps.executeQuery();

    if(rs.next()){

        full_name = rs.getString("full_name");
        gender = rs.getString("gender");
        age = rs.getInt("age");
        mobile = rs.getString("mobile");
        email = rs.getString("email");
        address = rs.getString("address");
        location = rs.getString("location");
        district = rs.getString("district");
    }

}catch(Exception e){

    out.println(e);
}
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Edit Profile</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:
    linear-gradient(rgba(0,0,0,0.7),
    rgba(0,0,0,0.7)),
    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1400&auto=format&fit=crop');
    background-size:cover;
    background-position:center;
    min-height:100vh;
}

.container-box{
    width:50%;
    margin:auto;
    margin-top:40px;
    background:white;
    padding:35px;
    border-radius:25px;
    box-shadow:0px 0px 20px rgba(0,0,0,0.4);
}

.title{
    text-align:center;
    font-size:38px;
    font-weight:bold;
    margin-bottom:30px;
    color:#0d6efd;
}

.form-control,
.form-select{
    height:50px;
    border-radius:10px;
}

label{
    font-weight:bold;
    margin-bottom:8px;
}

.btn-update{
    width:100%;
    height:50px;
    border:none;
    border-radius:10px;
    background:#198754;
    color:white;
    font-size:18px;
    font-weight:bold;
}

.back-btn{
    text-decoration:none;
    background:#0d6efd;
    color:white;
    padding:10px 20px;
    border-radius:10px;
    font-weight:bold;
}

.top-bar{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:25px;
}

.footer{
    width:100%;
    background:rgba(0,0,0,0.85);
    color:white;
    text-align:center;
    padding:15px;
    font-size:18px;
    font-weight:bold;
    letter-spacing:1px;
    margin-top:40px;
}

.footer span{
    color:#00bfff;
    font-size:20px;
}

</style>

</head>

<body>

<div class="container-box">

<div class="top-bar">

<a href="voterpage.jsp" class="back-btn">

⬅ Back

</a>

</div>

<div class="title">

✏️ Edit Profile

</div>

<form action="UpdatevoterProfile"
method="post"
enctype="multipart/form-data">

<!-- Hidden Values -->

<input type="hidden"
name="old_location"
value="<%=location%>">

<input type="hidden"
name="district"
value="<%=district%>">

<div class="mb-3">

<label>Voter ID</label>

<input type="text"
class="form-control"
value="<%= voter_id %>"
readonly>

</div>

<div class="mb-3">

<label>Full Name</label>

<input type="text"
name="full_name"
class="form-control"
value="<%= full_name %>"
required>

</div>

<div class="mb-3">

<label>Gender</label>

<select name="gender"
class="form-select"
required>

<option value="Male"
<%= gender.equals("Male") ? "selected" : "" %>>
Male
</option>

<option value="Female"
<%= gender.equals("Female") ? "selected" : "" %>>
Female
</option>

<option value="Other"
<%= gender.equals("Other") ? "selected" : "" %>>
Other
</option>

</select>

</div>

<div class="mb-3">

<label>Age</label>

<input type="number"
name="age"
class="form-control"
value="<%= age %>"
required>

</div>

<div class="mb-3">

<label>Mobile</label>

<input type="text"
name="mobile"
class="form-control"
value="<%= mobile %>"
required>

</div>

<div class="mb-3">

<label>Email</label>

<input type="email"
name="email"
class="form-control"
value="<%= email %>"
required>

</div>

<div class="mb-3">

<label>Address</label>

<textarea name="address"
class="form-control"
style="height:100px;"
required><%= address %></textarea>

</div>

<div class="mb-3">

<label>Location</label>

<select name="location"
class="form-select"
required>

<%
try{

    Connection locCon = DBConnection.getConnection();

    String locQuery =
    "SELECT location_name FROM location WHERE district=?";

    PreparedStatement locPs =
    locCon.prepareStatement(locQuery);

    locPs.setString(1, district);

    ResultSet locRs =
    locPs.executeQuery();

    while(locRs.next()){

        String loc =
        locRs.getString("location_name");
%>

<option value="<%=loc%>"
<%= loc.equalsIgnoreCase(location) ? "selected" : "" %>>

<%=loc%>

</option>

<%
    }

    locRs.close();
    locPs.close();
    locCon.close();

}catch(Exception e){

    out.println(e);
}
%>

</select>

</div>

<div class="mb-3">

<label>Change Profile Photo</label>

<input type="file"
name="photo"
class="form-control">

</div>

<button type="submit"
class="btn-update">

Update Profile

</button>

</form>

</div>

<div class="footer">

Developed By 🚀

<span>

ANKIT KUMAR SHAH

</span>

</div>

</body>
</html>