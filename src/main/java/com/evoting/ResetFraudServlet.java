package com.evoting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.SQLException;

@WebServlet("/ResetFraudServlet")

public class ResetFraudServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        try{

            Connection con =
            DBConnection.getConnection();

            String query =
            "DELETE FROM fraud_log";

            PreparedStatement ps =
            con.prepareStatement(query);

            ps.executeUpdate();

            response.getWriter().println(

            "<script>"

            + "alert('Fraud Alerts Reset Successfully');"

            + "window.location='admindashboard.jsp';"

            + "</script>"

            );

        }catch(IOException | SQLException e){

            response.getWriter().println(e);
        }
    }
}