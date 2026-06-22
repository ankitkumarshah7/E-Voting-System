<%@ page language="java"
contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%@page import="java.sql.*"%>
<%@page import="com.evoting.DBConnection"%>
<%
String adminDistrict =
(String)session.getAttribute("district");

if(adminDistrict == null){

    response.sendRedirect("landing.jsp");
    return;
}
%>
<%
    String msg = (String) session.getAttribute("msg");
%>

<% if (msg != null) { %>

<div class="container mt-3">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        <%= msg %>
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    </div>
</div>

<%
    session.removeAttribute("msg");
} 
%>
<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>Admin Dashboard</title>

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

    url('https://images.unsplash.com/photo-1454165804606-c3d57bc86b40?q=80&w=1400&auto=format&fit=crop');

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
.history-btn{

     background:#0d6efd;

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

.card-box{

    background:white;

    border-radius:25px;

    padding:30px;

    text-align:center;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);

    transition:0.3s;

    height:230px;
}

.card-box:hover{

    transform:translateY(-10px);
}

.icon{

    font-size:60px;

    margin-bottom:15px;
}

.card-title{

    font-size:22px;

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

.table-box{

    background:white;

    border-radius:25px;

    padding:30px;

    margin-top:40px;

    box-shadow:0px 0px 20px rgba(0,0,0,0.3);
}

.table-title{

    font-size:28px;

    font-weight:bold;

    margin-bottom:20px;

    text-align:center;
}

table{

    border-radius:15px;

    overflow:hidden;
}

.btn-activate{

    background:#198754;

    color:white;

    border:none;

    padding:6px 12px;

    border-radius:8px;

    font-weight:bold;
}

.btn-deactivate{

    background:#dc3545;

    color:white;

    border:none;

    padding:6px 12px;

    border-radius:8px;

    font-weight:bold;
}

.symbol-img{

    width:70px;

    height:70px;

    object-fit:contain;

    border-radius:10px;
}

.voter-img{

    width:60px;

    height:60px;

    border-radius:50%;

    object-fit:cover;
}

td{

    vertical-align:middle;

    text-align:center;
}

</style>

</head>

<body>

<!-- NAVBAR -->

<nav class="navbar">

<div class="container-fluid">

<span class="navbar-brand">

🗳️ Admin Dashboard
<span style="color:white;font-size:18px;">

👨‍💼 <%=session.getAttribute("admin")%>

&nbsp;&nbsp;

📍 <%=session.getAttribute("country")%>
|
<%=session.getAttribute("state")%>
|
<%=session.getAttribute("district")%>

</span>
</span>
<a href="addlocation.jsp">

<button class="btn btn-warning">

Add Location

</button>

</a>
<a href="history.jsp">

<button class="history-btn">

Check History

</button>
<a href="ResetFraudServlet">

<button class="btn btn-danger">

Reset Fraud Alerts

</button>

</a>
</a>
    <a href="pendingvoters.jsp">
<button class="btn btn-warning">
📩 Registered Voters
</button>
</a>
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

Election Management Panel

</div>
<div class="text-center text-white mb-4">

<h4>

Welcome Admin :
<%=session.getAttribute("admin")%>

</h4>

<h5>

District :
<%=adminDistrict%>

</h5>

</div>
<div class="container">

<!-- BUTTONS -->

<div class="row g-4">

<!-- ADD CANDIDATE -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">🧑‍💼</div>

<div class="card-title">

Add Candidate

</div>

<a href="addcandidate.jsp">

<button class=
"btn btn-primary btn-custom">

Open

</button>

</a>

</div>

</div>

<!-- START VOTING -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">🟢</div>

<div class="card-title">

Start Voting

</div>

<a href="StartVote3">

<button class=
"btn btn-success btn-custom">

Start

</button>

</a>

</div>

</div>

<!-- STOP VOTING -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">🔴</div>

<div class="card-title">

Stop Voting

</div>

<a href="StopVote4">

<button class=
"btn btn-danger btn-custom">

Stop

</button>

</a>

</div>

</div>

<!-- SHOW RESULT -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">📊</div>

<div class="card-title">

Publish Result

</div>

<a href="ShowResult3">

<button class=
"btn btn-info btn-custom">

Publish

</button>

</a>

</div>

</div>

<!-- HIDE RESULT -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">🙈</div>

<div class="card-title">

Hide Result

</div>

<a href="HideResult3">

<button class=
"btn btn-secondary btn-custom">

Hide

</button>

</a>

</div>

</div>

<!-- RESET ELECTION -->

<div class="col-md-4">

<div class="card-box">

<div class="icon">♻️</div>

<div class="card-title">

Reset Election

</div>

<a href="ResetElection2">

<button class=
"btn btn-warning btn-custom">

Reset

</button>

</a>

</div>

</div>



<!-- SMALL CANDIDATE PREVIEW -->

<div class="table-box">

<div class="d-flex justify-content-between align-items-center mb-4">

<div class="table-title m-0">

🧑‍💼 Recent Candidates

</div>

<a href="candidatelist.jsp">

<button class="btn btn-primary">

Candidate List

</button>

</a>

</div>

<table class="table table-bordered table-hover">

<thead class="table-dark">

<tr>

<th>ID</th>

<th>Name</th>

<th>Party</th>

<th>Location</th>

</tr>

</thead>

<tbody>

<%

try{

    Connection con =
            DBConnection.getConnection();

    String query =
"SELECT * FROM candidate " +
"WHERE location=? " +
"ORDER BY candidate_id DESC LIMIT 5";

PreparedStatement ps =
con.prepareStatement(query);

ps.setString(1, adminDistrict);

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

</tr>

<%

    }

    con.close();

}catch(Exception e){

    out.println(e);
}

%>

</tbody>

</table>

</div>

<!-- SMALL VOTER PREVIEW -->

<div class="table-box">

<div class="d-flex justify-content-between align-items-center mb-4">

<div class="table-title m-0">

🧑‍💻 Recent Voters

</div>

<a href="voterlist.jsp">

<button class="btn btn-success">

Voter List

</button>

</a>

</div>

<table class="table table-bordered table-hover">

<thead class="table-dark">

<tr>

<th>Voter ID</th>

<th>Name</th>

<th>Location</th>

<th>Status</th>

</tr>

</thead>

<tbody>

<%

try{

    Connection con =
            DBConnection.getConnection();

   String voterQuery =
"SELECT * FROM voter " +
"WHERE location=? " +
"ORDER BY voter_id DESC LIMIT 5";

PreparedStatement voterPs =
con.prepareStatement(voterQuery);

voterPs.setString(1, adminDistrict);

ResultSet voterRs =
voterPs.executeQuery();

    while(voterRs.next()){

%>

<tr>

<td>

<%= voterRs.getInt("voter_id") %>

</td>

<td>

<%= voterRs.getString("full_name") %>

</td>

<td>

<%= voterRs.getString("location") %>

</td>

<td>

<%

String status =
        voterRs.getString("status");

if(status.equalsIgnoreCase("active")){

%>

<span class="badge bg-success">

Active

</span>

<%

}else{

%>

<span class="badge bg-danger">

Inactive

</span>

<%

}

%>

</td>

</tr>

<%

    }

    con.close();

}catch(Exception e){

    out.println(e);
}

%>


</tbody>

</table>

</div>
</div>

</div>
<!-- AI BUTTON -->

<button class="ai-toggle-btn"
onclick="toggleCopilot()">

🤖 AI Copilot Help

</button>

<!-- AI COPILOT BOX -->

<div class="copilot-box"
id="copilotBox">

    <!-- HEADER -->

    <div class="copilot-header">

        🤖 Election AI Assistant

    </div>

    <!-- CHAT BODY -->

    <div class="copilot-body"
    id="chatBody">

        <div class="bot-msg">

            👋 Hello Admin! <br><br>

            Ask me about:
            <br><br>

            Say HELP to know what you can ask

        </div>

    </div>

    <!-- INPUT AREA -->

    <div class="copilot-input">

        <input type="text"
        id="userInput"
        placeholder="Ask something...">

        <button onclick="sendMessage()">

            Send

        </button>

    </div>

</div>

<style>

/* AI BUTTON */

.ai-toggle-btn{

    position:fixed;

    bottom:25px;

    right:25px;

    background:#0d6efd;

    color:white;

    border:none;

    padding:14px 22px;

    border-radius:50px;

    font-size:18px;

    font-weight:bold;

    cursor:pointer;

    z-index:999;

    box-shadow:0px 0px 15px rgba(0,0,0,0.4);

    transition:0.3s;
}

.ai-toggle-btn:hover{

    background:#0b5ed7;

    transform:scale(1.05);
}

/* MAIN BOX */

.copilot-box{

    position:fixed;

    bottom:90px;

    right:25px;

    width:360px;

    height:520px;

    background:white;

    border-radius:20px;

    overflow:hidden;

    display:none;

    flex-direction:column;

    box-shadow:0px 0px 20px rgba(0,0,0,0.4);

    z-index:999;
}

/* HEADER */

.copilot-header{

    background:linear-gradient(45deg,#0d6efd,#00bfff);

    color:white;

    padding:18px;

    font-size:22px;

    font-weight:bold;

    text-align:center;
}

/* CHAT BODY */

.copilot-body{

    flex:1;

    padding:15px;

    overflow-y:auto;

    background:#f1f5ff;
}

/* BOT MESSAGE */

.bot-msg{

    background:#e1ecff;

    padding:12px;

    border-radius:15px;

    margin-bottom:12px;

    width:85%;

    font-size:15px;
}

/* USER MESSAGE */

.user-msg{

    background:#0d6efd;

    color:white;

    padding:12px;

    border-radius:15px;

    margin-bottom:12px;

    margin-left:auto;

    width:85%;

    text-align:right;

    font-size:15px;
}

/* INPUT AREA */

.copilot-input{

    display:flex;

    border-top:1px solid #ddd;

    background:white;
}

.copilot-input input{

    flex:1;

    border:none;

    padding:15px;

    outline:none;

    font-size:15px;
}

.copilot-input button{

    background:#0d6efd;

    color:white;

    border:none;

    padding:0px 25px;

    font-weight:bold;

    cursor:pointer;
}

.copilot-input button:hover{

    background:#0b5ed7;
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

<script>

function toggleCopilot(){

    let box =
    document.getElementById("copilotBox");

    if(box.style.display === "flex"){

        box.style.display = "none";

    }else{

        box.style.display = "flex";
    }
}

function sendMessage(){

    let input =
    document.getElementById("userInput");

    let message =
    input.value.trim();

    let chatBody =
    document.getElementById("chatBody");

    // EMPTY CHECK

    if(message === ""){

        return;
    }

    // USER MESSAGE

    chatBody.innerHTML +=
    "<div class='user-msg'>"
    + message +
    "</div>";

    // AUTO SCROLL

    chatBody.scrollTop =
    chatBody.scrollHeight;

    // AJAX

    let xhr =
    new XMLHttpRequest();

    xhr.open(
    "POST",
    "AICopilotServlet",
    true
    );

    xhr.setRequestHeader(
    "Content-type",
    "application/x-www-form-urlencoded"
    );

    // RESPONSE

    xhr.onload = function(){

        if(xhr.status === 200){

            let reply =
            xhr.responseText;

            chatBody.innerHTML +=
            "<div class='bot-msg'>"
            + reply +
            "</div>";

        }else{

            chatBody.innerHTML +=
            "<div class='bot-msg'>Server Error</div>";
        }

        // AUTO SCROLL

        chatBody.scrollTop =
        chatBody.scrollHeight;
    };

    // SEND MESSAGE

    xhr.send(
    "message=" +
    encodeURIComponent(message)
    );

    // CLEAR INPUT

    input.value="";
}

// ENTER BUTTON SUPPORT

document.getElementById("userInput")
.addEventListener("keypress",

function(event){

    if(event.key === "Enter"){

        sendMessage();
    }
});

</script>
<!-- FOOTER -->

<div class="footer">

    Developed By 🚀

    <span>

        ANKIT KUMAR SHAH

    </span>

</div>
</body>

</html>