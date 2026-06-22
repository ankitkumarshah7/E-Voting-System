
<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
String district =
(String)session.getAttribute("district");

if(district == null){

    response.sendRedirect("Adminlogin.html");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Add Candidate</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
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
    linear-gradient(rgba(0,0,0,0.7),
    rgba(0,0,0,0.7)),

    url('https://images.unsplash.com/photo-1517048676732-d65bc937f952?q=80&w=1400&auto=format&fit=crop');

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

.candidate-box{

    width:550px;

    background:white;

    padding:40px;

    border-radius:25px;

    box-shadow:0px 0px 25px rgba(0,0,0,0.4);
}

.icon{

    text-align:center;

    font-size:70px;

    margin-bottom:10px;
}

h2{

    text-align:center;

    color:#0d6efd;

    font-weight:bold;

    margin-bottom:30px;
}

.form-control{

    height:50px;

    border-radius:10px;
}

.btn-add{

    width:100%;

    height:50px;

    border:none;

    border-radius:12px;

    font-size:18px;

    font-weight:bold;

    background:
    linear-gradient(45deg,#0d6efd,#0056d2);

    color:white;

    transition:0.3s;
}

.btn-add:hover{

    transform:translateY(-5px);

    box-shadow:0px 8px 20px rgba(0,0,0,0.3);
}

.back{

    text-align:center;

    margin-top:20px;
}

.back a{

    text-decoration:none;

    color:#0d6efd;

    font-weight:bold;
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
}

.footer span{

    color:#00bfff;

    font-size:20px;

    text-shadow:0px 0px 10px #00bfff;
}

</style>

</head>

<body>

<div class="main-container">

<div class="candidate-box">

<div class="icon">

🧑‍💼

</div>

<h2>

Add Candidate

</h2>

<form action="Addcandidate"
method="post"
enctype="multipart/form-data">

<div class="mb-3">

<label class="form-label">

Candidate Name

</label>

<input type="text"
name="candidate_name"
class="form-control"
placeholder="Enter Candidate Name"
required>

</div>

<div class="mb-3">

<label class="form-label">

Party Name

</label>

<input type="text"
name="party_name"
class="form-control"
placeholder="Enter Party Name"
required>

</div>

<div class="mb-3">

<label class="form-label">

District

</label>

<input type="text"
class="form-control"
value="<%=district%>"
readonly>

</div>

<div class="mb-3">

<label class="form-label">

Location

</label>

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
    "SELECT * FROM location WHERE district=? ORDER BY location_name");

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

    out.println(e);
}
%>

</select>

</div>

<div class="mb-4">

<label class="form-label">

Upload Party Symbol

</label>

<input type="file"
name="symbol"
class="form-control"
required>

</div>

<button type="submit"
class="btn-add">

Add Candidate

</button>

</form>

<div class="back">

<a href="admindashboard.jsp">

← Back to Dashboard

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

