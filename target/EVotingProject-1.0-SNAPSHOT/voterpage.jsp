<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"
session="true"%>

<%

// SESSION CHECK

if(session.getAttribute("voter_id")==null){

    response.sendRedirect("voterlogin.html");

    return;
}

// GET SESSION DATA

String full_name =
(String)session.getAttribute("full_name");

String email =
(String)session.getAttribute("email");

int voter_id =
Integer.parseInt(
session.getAttribute("voter_id").toString()
);

%>
<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>

<%
String district = "";
String location = "";

try{

    Connection con = DBConnection.getConnection();

    PreparedStatement ps =
    con.prepareStatement(
    "SELECT district,location,status FROM voter WHERE voter_id=?"
    );

    ps.setInt(1,voter_id);

    ResultSet rs = ps.executeQuery();

    if(rs.next()){

        district = rs.getString("district");
        location = rs.getString("location");

        session.setAttribute("district",district);
        session.setAttribute("location",location);
    }

    con.close();

}catch(Exception e){

    out.println(e);
}
%>
<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Voter Dashboard</title>

<link href=
"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

body{

    margin:0;
    padding:0;

    font-family:Arial, sans-serif;

    background:
    linear-gradient(rgba(0,0,0,0.7),
    rgba(0,0,0,0.7)),

    url('https://images.unsplash.com/photo-1529107386315-e1a2ed48a620?q=80&w=1400&auto=format&fit=crop');

    background-size:cover;
    background-position:center;

    min-height:100vh;
}

.navbar{

    background:rgba(0,0,0,0.6);

    padding:15px 40px;
}

.navbar-brand{

    color:white !important;

    font-size:30px;

    font-weight:bold;
}

.logout-btn{

    background:#dc3545;

    border:none;

    padding:10px 20px;

    border-radius:10px;

    color:white;

    font-weight:bold;
}

.dashboard-container{

    padding:40px;
}

.title{

    text-align:center;

    color:white;

    font-size:45px;

    font-weight:bold;

    margin-bottom:40px;
}

.profile-box{

    background:white;

    border-radius:25px;

    padding:30px;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    margin-bottom:40px;
}

.profile-img{

    width:120px;

    height:120px;

    border-radius:50%;

    object-fit:cover;

    border:5px solid #0d6efd;
}

.card-box{

    background:white;

    border-radius:25px;

    padding:30px;

    text-align:center;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    transition:0.3s;

    height:240px;
}

.card-box:hover{

    transform:translateY(-10px);
}

.icon{

    font-size:60px;

    margin-bottom:15px;
}

.card-title{

    font-size:24px;

    font-weight:bold;

    margin-bottom:15px;
}

.btn-custom{

    width:100%;

    border-radius:10px;

    padding:10px;

    font-weight:bold;

    font-size:17px;
}

.info-text{

    font-size:18px;

    margin-bottom:10px;
}

.notice-box{

    background:white;

    padding:25px;

    border-radius:20px;

    margin-top:40px;

    box-shadow:0px 0px 15px rgba(0,0,0,0.3);
}

.notice-title{

    font-size:28px;

    font-weight:bold;

    margin-bottom:20px;

    color:#dc3545;
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

<!-- NAVBAR -->

<nav class="navbar">

    <div class="container-fluid">

        <span class="navbar-brand">

            🗳️ Voter Dashboard

        </span>

        <a href="Logout">

            <button class="logout-btn">

                Logout

            </button>

        </a>

    </div>

</nav>

<!-- DASHBOARD -->

<div class="dashboard-container">

    <div class="title">

        Welcome To Online E-Voting System

    </div>

    <div class="container">

        <!-- PROFILE -->

        <div class="profile-box">

            <div class="row align-items-center">

                <div class="col-md-3 text-center">

                    <img
src="ShowImage?voter_id=<%= voter_id %>"
class="profile-img">

                </div>

                <div class="col-md-9">

                    <div class="info-text">

                        <b>Name :</b>

                        <%= full_name %>

                    </div>

                    <div class="info-text">

                        <b>Voter ID :</b>

                        <%= voter_id %>

                    </div>

                    <div class="info-text">

                        <b>Email :</b>

                        <%= email %>

                    </div>
<div class="info-text">

    <b>District :</b>

    <%= district %>

</div>

<div class="info-text">

    <b>Location :</b>

    <%= location %>

</div>
                    <div class="info-text">

                        <b>Status :</b>

                        <span class="badge bg-success">

                            Active

                        </span>

                    </div>

                </div>

            </div>

        </div>

        <!-- FEATURES -->

        <div class="row g-4">

            <div class="col-md-4">

                <div class="card-box">

                    <div class="icon">👤</div>

                    <div class="card-title">

                        Edit Profile

                    </div>

                    <a href="editprofile.jsp">

                        <button class=
                        "btn btn-primary btn-custom">

                            Open

                        </button>

                    </a>

                </div>

            </div>

            <div class="col-md-4">

                <div class="card-box">

                    <div class="icon">🗳️</div>

                    <div class="card-title">

                        Give Vote

                    </div>

                    <a href="givevote.jsp">

                        <button class=
                        "btn btn-success btn-custom">

                            Vote Now

                        </button>

                    </a>

                </div>

            </div>

            <div class="col-md-4">

                <div class="card-box">

                    <div class="icon">📊</div>

                    <div class="card-title">

                        View Result

                    </div>

                    <a href="result.jsp?from=voter">

                        <button class=
                        "btn btn-info btn-custom">

                            View Result

                        </button>

                    </a>

                </div>

            </div>

        </div>

        <!-- NOTICE -->

        <div class="notice-box">

            <div class="notice-title">

                📢 Important Notice

            </div>

            <ul>

                <li>
                    Each voter can vote only once.
                </li>

                <li>
                    Only active voters can vote.
                </li>

                <li>
                    Do not share your password.
                </li>

                <li>
                    Result will appear after election ends.
                </li>

            </ul>

        </div>

    </div>

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