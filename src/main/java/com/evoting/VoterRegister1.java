package com.evoting;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.sql.SQLException;

@WebServlet("/VoterRegister1")
@MultipartConfig(maxFileSize = 1024 * 1024 * 10)
public class VoterRegister1 extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");

        try {

           HttpSession session = request.getSession(false);

if(session == null){
    response.getWriter().println(
        "<script>"
        + "alert('Session Expired');"
        + "location='index.jsp';"
        + "</script>");
    return;
}

// GET SESSION DATA

String country =
(String)session.getAttribute("country");

String state =
(String)session.getAttribute("state");

String district =
(String)session.getAttribute("district");

session.setAttribute("country", country);
session.setAttribute("state", state);
session.setAttribute("district", district);
if(country == null ||
   state == null ||
   district == null){

    response.getWriter().println(
        "<script>"
        + "alert('Country/State/District Session Missing');"
        + "location='index.jsp';"
        + "</script>");
    return;
}

            String fullName = request.getParameter("full_name");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String ageStr = request.getParameter("age");
            String mobile = request.getParameter("mobile");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String location = request.getParameter("location");

            if (fullName == null || fullName.trim().isEmpty()
                    || password == null || password.trim().isEmpty()
                    || gender == null || gender.trim().isEmpty()
                    || ageStr == null || ageStr.trim().isEmpty()
                    || mobile == null || mobile.trim().isEmpty()
                    || email == null || email.trim().isEmpty()
                    || address == null || address.trim().isEmpty()
                    || location == null || location.trim().isEmpty()) {

                response.getWriter().println(
                        "<script>"
                        + "alert('All Fields Are Required');"
                        + "history.back();"
                        + "</script>");
                return;
            }

            int age = Integer.parseInt(ageStr);

            Part filePart = request.getPart("photo");
            InputStream photo = filePart.getInputStream();

            try (Connection con = DBConnection.getConnection()) {

                // CHECK IN voter_requests TABLE

                String checkPending =
                        "SELECT voter_id FROM voter_requests "
                        + "WHERE mobile=? OR email=?";

                PreparedStatement ps1 =
                        con.prepareStatement(checkPending);

                ps1.setString(1, mobile);
                ps1.setString(2, email);

                ResultSet rs1 = ps1.executeQuery();

                if (rs1.next()) {

                    response.getWriter().println(
                            "<script>"
                            + "alert('Registration Request Already Exists');"
                            + "history.back();"
                            + "</script>");
                    return;
                }

                // CHECK IN voter TABLE

                String checkVoter =
                        "SELECT voter_id FROM voter "
                        + "WHERE mobile=? OR email=?";

                PreparedStatement ps2 =
                        con.prepareStatement(checkVoter);

                ps2.setString(1, mobile);
                ps2.setString(2, email);

                ResultSet rs2 = ps2.executeQuery();

                if (rs2.next()) {

                    response.getWriter().println(
                            "<script>"
                            + "alert('Voter Already Registered');"
                            + "history.back();"
                            + "</script>");
                    return;
                }

                // INSERT REQUEST

               String sql =
"INSERT INTO voter_requests(" +
"full_name," +
"gender," +
"age," +
"mobile," +
"email," +
"address," +
"country," +
"state," +
"district," +
"location," +
"password," +
"photo," +
"request_status" +
") VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?)";

               PreparedStatement ps =
con.prepareStatement(sql);

ps.setString(1, fullName);
ps.setString(2, gender);
ps.setInt(3, age);
ps.setString(4, mobile);
ps.setString(5, email);
ps.setString(6, address);
ps.setString(7, country);
ps.setString(8, state);
ps.setString(9, district);
ps.setString(10, location);
ps.setString(11, password);
ps.setBlob(12, photo);
ps.setString(13, "Pending");

                int i = ps.executeUpdate();

                if (i > 0) {

                    response.getWriter().println(
                            "<script>"
                            + "alert('Registration Request Submitted Successfully');"
                            + "location='index.jsp';"
                            + "</script>");

                } else {

                    response.getWriter().println(
                            "<script>"
                            + "alert('Registration Failed');"
                            + "history.back();"
                            + "</script>");
                }
            }

        } catch (ServletException | IOException | NumberFormatException | SQLException e) {

            response.getWriter().println(
                    "<h3 style='color:red;text-align:center;'>"
                    + e.getMessage()
                    + "</h3>");
        }
    }
}