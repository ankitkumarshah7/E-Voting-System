package com.evoting;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@WebServlet("/VoterLogin5")
public class VoterLogin5 extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {

            String voterId = request.getParameter("voter_id");
            String password = request.getParameter("password");

            if (voterId == null || voterId.trim().isEmpty()
                    || password == null || password.trim().isEmpty()) {

                out.println("<script>"
                        + "alert('Please Enter Voter ID and Password');"
                        + "location='voterlogin.html';"
                        + "</script>");
                return;
            }

            int id = Integer.parseInt(voterId);

            try (Connection con = DBConnection.getConnection()) {
                String voterQuery =
                        "SELECT * FROM voter WHERE voter_id=?";
                
                PreparedStatement voterPs =
                        con.prepareStatement(voterQuery);
                
                voterPs.setInt(1, id);
                
                ResultSet rs = voterPs.executeQuery();
                
                if (!rs.next()) {
                    
                    out.println("<script>"
                            + "alert('Voter ID Not Found');"
                            + "location='voterlogin.html';"
                            + "</script>");
                    return;
                }
                
                String dbPassword = rs.getString("password");
                String status = rs.getString("status");
                int loginAttempt = rs.getInt("login_attempt");
                
                // BLOCKED
                if ("blocked".equalsIgnoreCase(status)) {
                    
                    out.println("<script>"
                            + "alert('Your Account Is Blocked By Admin');"
                            + "location='voterlogin.html';"
                            + "</script>");
                    return;
                }
                
                // INACTIVE
                if ("inactive".equalsIgnoreCase(status)) {
                    
                    out.println("<script>"
                            + "alert('Your Account Is Inactive. Contact Admin');"
                            + "location='voterlogin.html';"
                            + "</script>");
                    return;
                }
                
                // PASSWORD MATCH
                if (password.equals(dbPassword)) {
                    
                    // RESET LOGIN ATTEMPTS
                    PreparedStatement resetPs =
                            con.prepareStatement(
                                    "UPDATE voter SET login_attempt=0 WHERE voter_id=?");
                    
                    resetPs.setInt(1, id);
                    resetPs.executeUpdate();
                    
                    // SESSION
                    HttpSession session = request.getSession();
                    
                    session.setAttribute(
                            "voter_id",
                            rs.getInt("voter_id"));
                    
                    session.setAttribute(
                            "full_name",
                            rs.getString("full_name"));
                    
                    session.setAttribute(
                            "email",
                            rs.getString("email"));
                    
                    session.setAttribute(
                            "district",
                            rs.getString("district"));
                    
                    session.setAttribute(
                            "location",
                            rs.getString("location"));
                    
                    // COOKIE
                    Cookie voterCookie =
                            new Cookie(
                                    "voter_email",
                                    rs.getString("email"));
                    
                    voterCookie.setMaxAge(60 * 60 * 24);
                    response.addCookie(voterCookie);
                    
                    // LOGIN LOG
                    PreparedStatement logPs =
                            con.prepareStatement(
                                    "INSERT INTO fraud_log(voter_id,message) VALUES(?,?)");
                    
                    logPs.setInt(1, id);
                    logPs.setString(2, "Successful Login");
                    logPs.executeUpdate();
                    
                    response.sendRedirect("voterpage.jsp");
                    
                } else {
                    
                    // WRONG PASSWORD
                    loginAttempt++;
                    
                    PreparedStatement updatePs =
                            con.prepareStatement(
                                    "UPDATE voter SET login_attempt=? WHERE voter_id=?");
                    
                    updatePs.setInt(1, loginAttempt);
                    updatePs.setInt(2, id);
                    updatePs.executeUpdate();
                    
                    // LOG FAILED ATTEMPT
                    PreparedStatement logPs =
                            con.prepareStatement(
                                    "INSERT INTO fraud_log(voter_id,message) VALUES(?,?)");
                    
                    logPs.setInt(1, id);
                    logPs.setString(2,
                            "Wrong Password Attempt : " + loginAttempt);
                    
                    logPs.executeUpdate();
                    
                    // BLOCK AFTER 3 ATTEMPTS
                    if (loginAttempt >= 3) {
                        
                        PreparedStatement blockPs =
                                con.prepareStatement(
                                        "UPDATE voter SET status='blocked' WHERE voter_id=?");
                        
                        blockPs.setInt(1, id);
                        blockPs.executeUpdate();
                        
                        PreparedStatement blockLogPs =
                                con.prepareStatement(
                                        "INSERT INTO fraud_log(voter_id,message) VALUES(?,?)");
                        
                        blockLogPs.setInt(1, id);
                        blockLogPs.setString(2,
                                "Account Blocked Due To Multiple Wrong Password Attempts");
                        
                        blockLogPs.executeUpdate();
                        
                        out.println("<script>"
                                + "alert('Account Blocked After 3 Wrong Attempts');"
                                + "location='voterlogin.html';"
                                + "</script>");
                        
                    } else {
                        
                        out.println("<script>"
                                + "alert('Invalid Password. Attempt "
                                + loginAttempt
                                + "/3');"
                                        + "location='voterlogin.html';"
                                        + "</script>");
                    }
                }
                
                rs.close();
                voterPs.close();
            }

        } catch (NumberFormatException e) {

            out.println("<script>"
                    + "alert('Invalid Voter ID Format');"
                    + "location='voterlogin.html';"
                    + "</script>");

        } catch (IOException | SQLException e) {

            out.println("<script>"
                    + "alert('Error : " + e.getMessage() + "');"
                    + "location='voterlogin.html';"
                    + "</script>");
        }
    }
}