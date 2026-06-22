package com.evoting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/StartVote3")
public class StartVote3 extends HttpServlet {

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

        System.out.println("Country : " + country);
        System.out.println("State    : " + state);
        System.out.println("District : " + district);

        try (Connection con = DBConnection.getConnection()) {

            // CHECK IF RECORD EXISTS

            PreparedStatement checkPs =
                    con.prepareStatement(

                            "SELECT id FROM election_status "
                            + "WHERE country=? "
                            + "AND state=? "
                            + "AND district=?"

                    );

            checkPs.setString(1, country);
            checkPs.setString(2, state);
            checkPs.setString(3, district);

            ResultSet rs =
                    checkPs.executeQuery();

            // INSERT IF NOT EXISTS

            if (!rs.next()) {

                int newId = 1;

                PreparedStatement maxPs =
                        con.prepareStatement(

                                "SELECT IFNULL(MAX(id),0)+1 "
                                + "FROM election_status"

                        );

                ResultSet maxRs =
                        maxPs.executeQuery();

                if (maxRs.next()) {

                    newId =
                            maxRs.getInt(1);
                }

                PreparedStatement insertPs =
                        con.prepareStatement(

                                "INSERT INTO election_status "
                                + "(id,voting_status,result_status,"
                                + "country,state,district) "
                                + "VALUES(?,?,?,?,?,?)"

                        );

                insertPs.setInt(1, newId);
                insertPs.setString(2, "stopped");
                insertPs.setString(3, "hidden");
                insertPs.setString(4, country);
                insertPs.setString(5, state);
                insertPs.setString(6, district);

                insertPs.executeUpdate();
            }

            // START VOTING

            PreparedStatement updatePs =
                    con.prepareStatement(

                            "UPDATE election_status "
                            + "SET voting_status='started' "
                            + "WHERE country=? "
                            + "AND state=? "
                            + "AND district=?"

                    );

            updatePs.setString(1, country);
            updatePs.setString(2, state);
            updatePs.setString(3, district);

            int rows =
                    updatePs.executeUpdate();

            if (rows > 0) {

                session.setAttribute(
                        "msg",
                        "Voting Started Successfully For "
                        + district
                );

            } else {

                session.setAttribute(
                        "msg",
                        "Unable To Start Voting"
                );
            }

            response.sendRedirect(
                    "admindashboard.jsp"
            );

        } catch (SQLException e) {

            e.printStackTrace();

            session.setAttribute(
                    "msg",
                    "Error : " + e.getMessage()
            );

            response.sendRedirect(
                    "admindashboard.jsp"
            );
        }
    }
}