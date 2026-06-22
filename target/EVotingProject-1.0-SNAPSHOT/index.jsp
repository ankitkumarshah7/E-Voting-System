<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
String country=(String)session.getAttribute("country");
String state=(String)session.getAttribute("state");
String district=(String)session.getAttribute("district");

if(country==null || state==null || district==null){
    response.sendRedirect("landing.jsp");
    return;
}
%>

<!DOCTYPE html>
<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1.0">

<title>E-Voting System</title>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
rel="stylesheet">

<style>

*{
margin:0;
padding:0;
box-sizing:border-box;
font-family:Arial,sans-serif;
}

html,body{
height:100%;
}

body{

min-height:100vh;

display:flex;
flex-direction:column;

background:
linear-gradient(
rgba(0,0,0,0.7),
rgba(0,0,0,0.7)),

url('https://images.unsplash.com/photo-1541872703-74c5e44368f9?q=80&w=1400&auto=format&fit=crop');

background-size:cover;
background-position:center;
}

.title{

text-align:center;

color:white;

font-size:52px;

font-weight:bold;

text-shadow:2px 2px 10px black;

padding-top:25px;

margin-bottom:10px;
}

.area-box{

text-align:center;

color:white;

font-size:22px;

font-weight:bold;

margin-bottom:20px;
}

.change-btn{

text-align:center;

margin-bottom:20px;
}

.main-container{

flex:1;

display:flex;

justify-content:center;

align-items:center;

gap:25px;

flex-wrap:wrap;

padding:20px;
}

.login-box{

width:340px;

background:white;

padding:25px;

border-radius:25px;

text-align:center;

box-shadow:0px 0px 25px rgba(0,0,0,0.4);

transition:0.3s;
}

.login-box:hover{

transform:translateY(-10px);
}

.login-icon{

font-size:70px;

margin-bottom:18px;
}

.admin{
color:#0d6efd;
}

.voter{
color:#198754;
}

.result{
color:#7b2cbf;
}

h2{

font-weight:bold;

margin-bottom:15px;

font-size:34px;
}

p{

color:gray;

margin-bottom:25px;

font-size:16px;

line-height:1.6;
}

.btn-custom{

width:100%;

padding:14px;

font-size:18px;

border-radius:12px;

font-weight:bold;

margin-top:15px;

transition:0.3s;
}

.btn-custom:hover{

transform:scale(1.03);
}

.register-btn{

width:100%;

padding:14px;

font-size:18px;

font-weight:bold;

border:none;

border-radius:12px;

background:
linear-gradient(45deg,#ffb703,#ff8800);

color:white;

transition:0.3s;

box-shadow:0px 5px 15px rgba(0,0,0,0.3);

margin-top:18px;
}

.register-btn:hover{

transform:translateY(-5px);

background:
linear-gradient(45deg,#ff8800,#ffb703);
}

.result-btn{

width:100%;

padding:14px;

font-size:18px;

font-weight:bold;

border:none;

border-radius:12px;

background:
linear-gradient(45deg,#7b2cbf,#9d4edd);

color:white;

transition:0.3s;

margin-top:18px;
}

.result-btn:hover{

transform:translateY(-5px);

background:
linear-gradient(45deg,#9d4edd,#7b2cbf);
}

.note{

margin-top:22px;

background:#222;

color:white;

padding:18px;

border-radius:15px;

font-size:15px;

font-weight:bold;

line-height:1.6;
}

a{
text-decoration:none;
}

.footer{

width:100%;

background:rgba(0,0,0,0.88);

color:white;

text-align:center;

padding:15px;

font-size:18px;

font-weight:bold;

letter-spacing:1px;

box-shadow:0px -2px 10px rgba(0,0,0,0.3);
}

.footer span{

color:#00bfff;

font-size:20px;

text-shadow:0px 0px 10px #00bfff;
}

@media(max-width:1100px){

.main-container{
flex-direction:column;
}

.title{
font-size:40px;
}
}

</style>

</head>

<body>

<div class="title">

🗳️ E-Voting System

</div>

<div class="area-box">

🌍 <%=country%>
→
🏛️ <%=state%>
→
📍 <%=district%>

</div>

<div class="change-btn">

<a href="landing.jsp">

<button class="btn btn-warning">

🔄 Change Election Area

</button>

</a>

</div>

<div class="main-container">

<div class="login-box">

<div class="login-icon admin">

👨‍💼

</div>

<h2>Admin Portal</h2>

<p>

Manage voters, candidates,
election status and results
securely.

</p>

<a href="Adminlogin.html">

<button class="btn btn-primary btn-custom">

Admin Login

</button>

</a>

</div>

<div class="login-box">

<div class="login-icon voter">

🧑‍💼

</div>

<h2>Voter Portal</h2>

<p>

Login to cast your vote
securely and participate
in digital election.

</p>

<a href="voterlogin.html">

<button class="btn btn-success btn-custom">

Voter Login

</button>

</a>

<a href="voterregister.jsp">

<button class="register-btn">

📝 Voter Registration

</button>

</a>

<div class="note">

After Registration Admin must approve
your request before login.

</div>

</div>

<div class="login-box">

<div class="login-icon result">

📊

</div>

<h2>View Result</h2>

<p>

Result will be available
after admin publishes it.

</p>

<a href="result.jsp?from=index">

<button class="result-btn">

View Result

</button>

</a>

</div>

</div>

<div class="footer">

Developed By 🚀
<span>ANKIT KUMAR SHAH</span>

</div>

</body>

</html>