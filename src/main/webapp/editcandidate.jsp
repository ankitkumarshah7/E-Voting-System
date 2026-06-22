<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Edit Candidate</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    background:#f5f5f5;

    font-family:Arial;
}

.form-box{

    width:550px;

    margin:auto;

    margin-top:50px;

    background:white;

    padding:30px;

    border-radius:20px;

    box-shadow:0px 0px 10px gray;
}

h2{

    text-align:center;

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

    box-shadow:0px -2px 10px rgba(0,0,0,0.3);
}

.footer span{

    color:#00bfff;

    font-size:20px;

    text-shadow:0px 0px 10px #00bfff;
}

</style>

</head>

<body>

<div class="form-box">

<h2>

✏ Edit Candidate

</h2>

<%

String district =
(String)session.getAttribute("district");

String id =
request.getParameter("candidate_id");

if(id == null){

%>

<div class="alert alert-danger">

Invalid Candidate ID

</div>

<%

}else{

Connection con =
DBConnection.getConnection();

PreparedStatement ps =
con.prepareStatement(

"SELECT * FROM candidate WHERE candidate_id=? AND district=?"

);

ps.setInt(1,
Integer.parseInt(id));

ps.setString(2,
district);

ResultSet rs =
ps.executeQuery();

if(rs.next()){

%>

<form action="UpdateCandidate"
method="post"
enctype="multipart/form-data">

<input type="hidden"
name="candidate_id"
value="<%=rs.getInt("candidate_id")%>">

<div class="mb-3">

<label>

Candidate ID

</label>

<input type="text"
class="form-control"
value="<%=rs.getInt("candidate_id")%>"
readonly>

</div>

<div class="mb-3">

<label>

Candidate Name

</label>

<input type="text"
name="candidate_name"
class="form-control"
value="<%=rs.getString("candidate_name")%>"
required>

</div>

<div class="mb-3">

<label>

Party Name

</label>

<input type="text"
name="party_name"
class="form-control"
value="<%=rs.getString("party_name")%>"
required>

</div>

<div class="mb-3">

<label>

Location

</label>

<select
name="location"
class="form-control"
required>

<option value="">

Select Location

</option>

<%

PreparedStatement locPs =
con.prepareStatement(

"SELECT * FROM location WHERE district=? ORDER BY location_name"

);

locPs.setString(1,
district);

ResultSet locRs =
locPs.executeQuery();

while(locRs.next()){

String loc =
locRs.getString("location_name");

%>

<option value="<%=loc%>"
<%=loc.equals(rs.getString("location"))
? "selected"
: ""%>>

<%=loc%>

</option>

<%
}
%>

</select>

</div>

<div class="mb-3">

<label>

District

</label>

<input type="text"
class="form-control"
value="<%=district%>"
readonly>

</div>

<div class="mb-3">

<label>

Current Symbol

</label>

<br>

<img src="Showimage?id=<%=rs.getInt("candidate_id")%>"
width="100"
height="100"
style="border-radius:10px;">

</div>

<div class="mb-3">

<label>

Change Symbol

</label>

<input type="file"
name="symbol"
class="form-control">

</div>

<button type="submit"
class="btn btn-success w-100">

Update Candidate

</button>

</form>

<%

}else{

%>

<div class="alert alert-danger">

Candidate not found in your district.

</div>

<%

}

con.close();

}

%>

<br>

<a href="candidatelist.jsp">

<button class="btn btn-primary w-100">

⬅ Back Candidate List

</button>

</a>

</div>

<div class="footer">

Developed By 🚀

<span>

ANKIT KUMAR SHAH

</span>

</div>

</body>

</html>
