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

@WebServlet("/ResetElection2")
public class ResetElection2 extends HttpServlet {


@Override
protected void doGet(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    Connection con = null;

    try {

        HttpSession session = request.getSession(false);

        if(session == null ||
           session.getAttribute("district") == null){

            response.sendRedirect("Adminlogin.html");
            return;
        }

        String adminDistrict =
                session.getAttribute("district").toString();

        con = DBConnection.getConnection();

        // =========================
        // SAVE RESULT TO HISTORY
        // =========================

        String historyQuery =
        "INSERT INTO election_history " +
        "(candidate_id,candidate_name,party_name,country,state,district,location,total_votes) " +
        "SELECT candidate_id,candidate_name,party_name,country,state,district,location,total_votes " +
        "FROM result_view " +
        "WHERE district=?";

        PreparedStatement historyPs =
                con.prepareStatement(historyQuery);

        historyPs.setString(1, adminDistrict);

        historyPs.executeUpdate();

        // =========================
        // DELETE DISTRICT VOTES
        // =========================

        String deleteVote =
        "DELETE v FROM vote v " +
        "INNER JOIN candidate c " +
        "ON v.candidate_id=c.candidate_id " +
        "WHERE c.district=?";

        PreparedStatement deletePs =
                con.prepareStatement(deleteVote);

        deletePs.setString(1, adminDistrict);

        deletePs.executeUpdate();

        // =========================
        // RESET DISTRICT VOTERS
        // =========================

        String resetVoter =
        "UPDATE voter " +
        "SET has_voted=0 " +
        "WHERE district=?";

        PreparedStatement resetPs =
                con.prepareStatement(resetVoter);

        resetPs.setString(1, adminDistrict);

        resetPs.executeUpdate();

        // =========================
        // RESET DISTRICT ELECTION
        // =========================

        String resetElection =
        "UPDATE election_status " +
        "SET voting_status='stopped', " +
        "result_status='hidden' " +
        "WHERE district=?";

        PreparedStatement electionPs =
                con.prepareStatement(resetElection);

        electionPs.setString(1, adminDistrict);

        electionPs.executeUpdate();

        // =========================
        // SUCCESS MESSAGE
        // =========================

        session.setAttribute(
                "msg",
                "Election Reset Successfully For " + adminDistrict
        );

        response.sendRedirect("admindashboard.jsp");

    } catch (IOException | SQLException e) {

        HttpSession session =
                request.getSession();

        session.setAttribute(
                "msg",
                "Error : " + e.getMessage()
        );

        response.sendRedirect("admindashboard.jsp");

    } finally {

        try {

            if(con != null){

                con.close();
            }

        } catch (SQLException e) {
        }
    }
}


}
