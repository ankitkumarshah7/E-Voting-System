package com.evoting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/HideResult3")
public class HideResult3 extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null
                || session.getAttribute("country") == null
                || session.getAttribute("state") == null
                || session.getAttribute("district") == null) {

            response.sendRedirect("Adminlogin.html");
            return;
        }

        String country =
                session.getAttribute("country").toString();

        String state =
                session.getAttribute("state").toString();

        String district =
                session.getAttribute("district").toString();

        try (Connection con = DBConnection.getConnection()) {

            String sql =
                    "UPDATE election_status "
                    + "SET result_status='hidden' "
                    + "WHERE country=? "
                    + "AND state=? "
                    + "AND district=?";

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, country);
            ps.setString(2, state);
            ps.setString(3, district);

            int rows = ps.executeUpdate();

            if (rows > 0) {

                session.setAttribute(
                        "msg",
                        "Result hidden successfully for "
                        + district
                );

            } else {

                session.setAttribute(
                        "msg",
                        "No election record found for "
                        + district
                );
            }

        } catch (SQLException e) {

            session.setAttribute(
                    "msg",
                    "Error hiding result : "
                    + e.getMessage()
            );
        }

        response.sendRedirect("admindashboard.jsp");
    }
}