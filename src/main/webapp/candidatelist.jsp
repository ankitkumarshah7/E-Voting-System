<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Candidate List</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    font-family:Arial,sans-serif;

    background:#f5f5f5;

    margin:0;
    padding:0;
}

.container-box{

    width:90%;

    margin:auto;

    margin-top:30px;

    margin-bottom:40px;
}

.top-bar{

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:30px;
}

.page-title{

    font-size:40px;

    font-weight:bold;

    color:#333;
}

.back-btn{

    background:#0d6efd;

    color:white;

    border:none;

    padding:10px 20px;

    border-radius:10px;

    font-weight:bold;

    text-decoration:none;
}

.location-box{

    background:white;

    padding:25px;

    border-radius:20px;

    margin-bottom:40px;

    box-shadow:0px 0px 10px gray;
}

.location-title{

    font-size:30px;

    font-weight:bold;

    margin-bottom:20px;

    color:#0d6efd;
}

table{

    width:100%;

    border-collapse:collapse;
}

th,td{

    border:1px solid #ddd;

    padding:12px;

    text-align:center;
}

th{

    background:#343a40;

    color:white;
}

img{

    width:100px;

    height:100px;

    object-fit:contain;

    border-radius:10px;
}

.delete-btn{

    background:red;

    color:white;

    border:none;

    padding:8px 15px;

    border-radius:8px;

    cursor:pointer;

    font-weight:bold;
}

.delete-btn:hover{

    background:darkred;
}
/* FOOTER */

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

<div class="container-box">

<!-- TOP BAR -->

<div class="top-bar">

<div class="page-title">

🧑‍💼 Candidate List

</div>

<a href="admindashboard.jsp"
class="back-btn">

⬅ Back Dashboard

</a>

</div>

<%

// DELETE CODE

String deleteId =
        request.getParameter("deleteId");

if(deleteId != null){

    try{

        Connection con =
                DBConnection.getConnection();

        String adminDistrict =
(String)session.getAttribute("district");

String deleteQuery =
"DELETE FROM candidate WHERE candidate_id=? AND district=?";
        PreparedStatement dps =
                con.prepareStatement(deleteQuery);

       dps.setInt(1,
Integer.parseInt(deleteId));

dps.setString(2,
adminDistrict);

        dps.executeUpdate();

%>

<script>

alert("Candidate Deleted Successfully");

window.location="candidatelist.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);
    }
}

%>

<%

try{

    Connection con =
            DBConnection.getConnection();

    // DISTINCT LOCATIONS

   String adminDistrict =
(String)session.getAttribute("district");

String locationQuery =
"SELECT DISTINCT location FROM candidate WHERE district=? ORDER BY location";

PreparedStatement locationPs =
con.prepareStatement(locationQuery);

locationPs.setString(1, adminDistrict);

ResultSet locationRs =
locationPs.executeQuery();

    while(locationRs.next()){

        String location =
                locationRs.getString("location");

%>

<!-- LOCATION SECTION -->

<div class="location-box">

<div class="location-title">

📍 <%= location %>

</div>

<table>

<tr>

<th>Candidate ID</th>

<th>Candidate Name</th>

<th>Party</th>

<th>Location</th>

<th>District</th>

<th>Symbol</th>

<th>Action</th>

<th>Edit</th>

</tr>

<%

String query =
"SELECT * FROM candidate WHERE location=? AND district=? ORDER BY candidate_id DESC";

PreparedStatement ps =
con.prepareStatement(query);

ps.setString(1, location);
ps.setString(2, adminDistrict);

ResultSet rs =
ps.executeQuery();

while(rs.next()){

%>

<tr>

<td>

<%= rs.getInt("candidate_id") %>

</td>

<td>

<%= rs.getString("candidate_name") %>

</td>

<td>

<%= rs.getString("party_name") %>

</td>

<td>

<%= rs.getString("location") %>

</td>

<td>
<%= rs.getString("district") %>
</td>

<td>

<img src=
"ShowImage?candidate_id=<%= rs.getInt("candidate_id") %>">

</td>

<td>

<a href=
"candidatelist.jsp?deleteId=<%= rs.getInt("candidate_id") %>"
onclick=
"return confirm('Are you sure to delete this candidate?')">

<button class="delete-btn">

Delete

</button>

</a>

</td>

<td>

<a href=
"editcandidate.jsp?candidate_id=<%= rs.getInt("candidate_id") %>">

<button
style="
background:#198754;
color:white;
border:none;
padding:8px 15px;
border-radius:8px;
font-weight:bold;
">

Edit

</button>

</a>

</td>

</tr>

<%

}

%>

</table>

</div>

<%

    }

    con.close();

}catch(Exception e){

    out.println(e);
}

%>

</div>
<!-- FOOTER -->

<div class="footer">

    Developed By 🚀

    <span>

        ANKIT KUMAR SHAH

    </span>

</div>
</body>

</html>