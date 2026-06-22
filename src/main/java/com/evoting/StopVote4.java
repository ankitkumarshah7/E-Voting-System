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

@WebServlet("/StopVote4")
public class StopVote4 extends HttpServlet {

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

            PreparedStatement ps =
                    con.prepareStatement(

                            "UPDATE election_status "
                            + "SET voting_status='stopped' "
                            + "WHERE country=? "
                            + "AND state=? "
                            + "AND district=?"

                    );

            ps.setString(1, country);
            ps.setString(2, state);
            ps.setString(3, district);

            int rows =
                    ps.executeUpdate();

            if (rows > 0) {

                session.setAttribute(
                        "msg",
                        "Voting Stopped Successfully For "
                        + district
                );

            } else {

                session.setAttribute(
                        "msg",
                        "No Voting Record Found For "
                        + district
                );
            }

            response.sendRedirect(
                    "admindashboard.jsp"
            );

        } catch (SQLException e) {


            session.setAttribute(
                    "msg",
                    "Error Stopping Voting : "
                    + e.getMessage()
            );

            response.sendRedirect(
                    "admindashboard.jsp"
            );
        }
    }
}