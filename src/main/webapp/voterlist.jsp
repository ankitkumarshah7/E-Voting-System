<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%
String adminDistrict =
(String)session.getAttribute("district");

if(adminDistrict == null){

    response.sendRedirect("Adminlogin.html");
    return;
}
%>
<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Voter List</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    font-family:Arial, sans-serif;

    background:#f4f6f9;

    margin:0;

    padding:20px;
}

/* TOP BAR */

.top-bar{

    width:95%;

    margin:auto;

    display:flex;

    justify-content:space-between;

    align-items:center;

    margin-bottom:25px;
}

.page-title{

    font-size:40px;

    font-weight:bold;

    color:#212529;
}

.back-btn{

    background:#0d6efd;

    color:white;

    padding:10px 20px;

    border-radius:10px;

    text-decoration:none;

    font-weight:bold;
}

.back-btn:hover{

    background:#0b5ed7;

    color:white;
}

/* LOCATION BOX */

.location-box{

    width:95%;

    margin:auto;

    margin-bottom:40px;

    background:white;

    border-radius:20px;

    padding:25px;

    box-shadow:0px 0px 15px rgba(0,0,0,0.2);
}

.location-title{

    text-align:center;

    font-size:30px;

    font-weight:bold;

    color:#0d6efd;

    margin-bottom:25px;
}

/* TABLE */

table{

    width:100%;

    border-collapse:collapse;
}

th{

    background:#212529;

    color:white;

    padding:12px;
}

td{

    padding:12px;

    text-align:center;

    border:1px solid #ccc;

    vertical-align:middle;
}

tr:hover{

    background:#f2f2f2;
}

/* IMAGE */

img{

    width:90px;

    height:90px;

    object-fit:cover;

    border-radius:10px;
}

/* STATUS */

.active{

    background:green;

    color:white;

    padding:6px 12px;

    border-radius:8px;

    font-weight:bold;
}

.inactive{

    background:red;

    color:white;

    padding:6px 12px;

    border-radius:8px;

    font-weight:bold;
}

.blocked{

    background:black;

    color:white;

    padding:6px 12px;

    border-radius:8px;

    font-weight:bold;
}

/* BUTTON */

.btn-action{

    border:none;

    padding:8px 14px;

    border-radius:8px;

    color:white;

    font-weight:bold;

    cursor:pointer;

    margin:2px;
}

.activate{

    background:#198754;
}

.inactivate{

    background:#ffc107;

    color:black;
}

.delete{

    background:#dc3545;
}

.unblock{

    background:#0d6efd;
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

<!-- TOP BAR -->

<div class="top-bar">

<div class="page-title">

🧑‍💻 Voter List

</div>

<a href="admindashboard.jsp"
class="back-btn">

⬅ Back Dashboard

</a>

</div>

<%

// ACTIVATE VOTER

String activateId =
request.getParameter("activateId");

if(activateId != null){

    try{

        Connection con =
        DBConnection.getConnection();

       String query =
"UPDATE voter SET status='active' WHERE voter_id=? AND district=?";
        PreparedStatement ps =
        con.prepareStatement(query);
ps.setInt(1,Integer.parseInt(activateId));
ps.setString(2,adminDistrict);
        ps.executeUpdate();

%>

<script>

alert("Voter Activated Successfully");

window.location="voterlist.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);
    }
}


// INACTIVATE VOTER

String inactiveId =
request.getParameter("inactiveId");

if(inactiveId != null){

    try{

        Connection con =
        DBConnection.getConnection();

       String query =
"UPDATE voter SET status='inactive' WHERE voter_id=? AND district=?";

        PreparedStatement ps =
        con.prepareStatement(query);

       ps.setInt(1,Integer.parseInt(inactiveId));
ps.setString(2,adminDistrict);

        ps.executeUpdate();

%>

<script>

alert("Voter Inactivated Successfully");

window.location="voterlist.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);
    }
}


// UNBLOCK VOTER

String unblockId =
request.getParameter("unblockId");

if(unblockId != null){

    try{

        Connection con =
        DBConnection.getConnection();

       String query =
"UPDATE voter SET status='active', login_attempt=0 WHERE voter_id=? AND district=?";

        PreparedStatement ps =
        con.prepareStatement(query);

       ps.setInt(1,Integer.parseInt(unblockId));
ps.setString(2,adminDistrict);

        ps.executeUpdate();

%>

<script>

alert("Voter Unblocked Successfully");

window.location="voterlist.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);
    }
}


// DELETE VOTER

String deleteId =
request.getParameter("deleteId");

if(deleteId != null){

    try{

        Connection con =
        DBConnection.getConnection();

       String query =
"DELETE FROM voter WHERE voter_id=? AND district=?";

        PreparedStatement ps =
        con.prepareStatement(query);

       ps.setInt(1,Integer.parseInt(deleteId));
ps.setString(2,adminDistrict);

        ps.executeUpdate();

%>

<script>

alert("Voter Deleted Successfully");

window.location="voterlist.jsp";

</script>

<%

    }catch(Exception e){

        out.println(e);
    }
}

try{

    Connection con =
    DBConnection.getConnection();

    // GET LOCATIONS

   String locationQuery =
"SELECT DISTINCT location FROM voter WHERE district=? ORDER BY location";

    PreparedStatement locationPs =
    con.prepareStatement(locationQuery);
locationPs.setString(1,adminDistrict);
    ResultSet locationRs =
    locationPs.executeQuery();

    while(locationRs.next()){

        String location =
        locationRs.getString("location");

%>

<!-- LOCATION BOX -->

<div class="location-box">

<div class="location-title">

📍 <%= location %> Voters

</div>

<table>

<tr>

<th>ID</th>

<th>Photo</th>

<th>Name</th>

<th>Gender</th>

<th>Age</th>

<th>Mobile</th>

<th>Email</th>

<th>Address</th>

<th>District</th>

<th>Status</th>

<th>Login Attempt</th>

<th>Has Voted</th>

<th>Action</th>

</tr>

<%

String query =
"SELECT * FROM voter WHERE location=? AND district=?";

PreparedStatement ps =
con.prepareStatement(query);

ps.setString(1, location);
ps.setString(2, adminDistrict);

ResultSet rs =
ps.executeQuery();

while(rs.next()){

String status =
rs.getString("status");

%>

<tr>

<td>

<%= rs.getInt("voter_id") %>

</td>

<td>

<img src=
"ShowImage?voter_id=<%= rs.getInt("voter_id") %>">

</td>

<td>

<%= rs.getString("full_name") %>

</td>

<td>

<%= rs.getString("gender") %>

</td>

<td>

<%= rs.getInt("age") %>

</td>

<td>

<%= rs.getString("mobile") %>

</td>

<td>

<%= rs.getString("email") %>

</td>

<td>

<%= rs.getString("address") %>

</td>

<td>
<%= rs.getString("district") %>
</td>

<td>

<%

if(status.equalsIgnoreCase("active")){

%>

<span class="active">

Active

</span>

<%

}else if(status.equalsIgnoreCase("blocked")){

%>

<span class="blocked">

Blocked

</span>

<%

}else{

%>

<span class="inactive">

Inactive

</span>

<%

}

%>

</td>

<td>

<%= rs.getInt("login_attempt") %>

</td>

<td>

<%

boolean voted =
rs.getBoolean("has_voted");

if(voted){

%>

<span class="active">

Yes

</span>

<%

}else{

%>

<span class="inactive">

No

</span>

<%

}

%>

</td>

<td>

<%

if(status.equalsIgnoreCase("inactive")){

%>

<a href=
"voterlist.jsp?activateId=<%= rs.getInt("voter_id") %>">

<button class="btn-action activate">

Activate

</button>

</a>

<%

}else if(status.equalsIgnoreCase("active")){

%>

<a href=
"voterlist.jsp?inactiveId=<%= rs.getInt("voter_id") %>">

<button class="btn-action inactivate">

Inactivate

</button>

</a>

<%

}else if(status.equalsIgnoreCase("blocked")){

%>

<a href=
"voterlist.jsp?unblockId=<%= rs.getInt("voter_id") %>">

<button class="btn-action unblock">

Unblock

</button>

</a>

<%

}

%>

<a href=
"voterlist.jsp?deleteId=<%= rs.getInt("voter_id") %>"
onclick=
"return confirm('Are you sure to delete this voter?')">

<button class="btn-action delete">

Delete

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
<!-- FOOTER -->

<div class="footer">

    Developed By 🚀

    <span>

        ANKIT KUMAR SHAH

    </span>

</div>
</body>
</html>