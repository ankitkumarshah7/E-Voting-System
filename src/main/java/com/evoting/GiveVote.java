package com.evoting;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.sql.SQLException;

@WebServlet("/GiveVote")
public class GiveVote extends HttpServlet {


@Override
protected void doPost(HttpServletRequest request,
        HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession(false);

    if (session == null || session.getAttribute("voter_id") == null) {
        response.sendRedirect("voterlogin.html");
        return;
    }

    try {

        int voterId = Integer.parseInt(
                session.getAttribute("voter_id").toString());

        String candidateStr =
                request.getParameter("candidate_id");

        if (candidateStr == null || candidateStr.trim().isEmpty()) {

            response.getWriter().println(
                    "<script>"
                    + "alert('Please Select A Candidate');"
                    + "history.back();"
                    + "</script>");
            return;
        }

        int candidateId = Integer.parseInt(candidateStr);

        try (Connection con = DBConnection.getConnection()) {

            String country;
            String state;
            String district;
            String location;
            int hasVoted;

            String voterSql =
                    "SELECT country,state,district,location,has_voted "
                    + "FROM voter WHERE voter_id=?";

            try (PreparedStatement ps =
                    con.prepareStatement(voterSql)) {

                ps.setInt(1, voterId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {

                        response.getWriter().println(
                                "<script>"
                                + "alert('Voter Not Found');"
                                + "location='voterlogin.html';"
                                + "</script>");
                        return;
                    }

                    country = rs.getString("country");
                    state = rs.getString("state");
                    district = rs.getString("district");
                    location = rs.getString("location");
                    hasVoted = rs.getInt("has_voted");
                }
            }

            if (hasVoted == 1) {

                response.getWriter().println(
                        "<script>"
                        + "alert('You Have Already Voted');"
                        + "location='voterpage.jsp';"
                        + "</script>");
                return;
            }

            String electionSql =
                    "SELECT voting_status "
                    + "FROM election_status "
                    + "WHERE country=? "
                    + "AND state=? "
                    + "AND district=?";

            try (PreparedStatement ps =
                    con.prepareStatement(electionSql)) {

                ps.setString(1, country);
                ps.setString(2, state);
                ps.setString(3, district);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {

                        response.getWriter().println(
                                "<script>"
                                + "alert('Election Not Configured For Your District');"
                                + "location='voterpage.jsp';"
                                + "</script>");
                        return;
                    }

                    String votingStatus =
                            rs.getString("voting_status");

                    if (!"started".equalsIgnoreCase(votingStatus)) {

                        response.getWriter().println(
                                "<script>"
                                + "alert('Voting Is Closed In Your District');"
                                + "location='voterpage.jsp';"
                                + "</script>");
                        return;
                    }
                }
            }

            String candidateSql =
                    "SELECT candidate_id "
                    + "FROM candidate "
                    + "WHERE candidate_id=? "
                    + "AND country=? "
                    + "AND state=? "
                    + "AND district=? "
                    + "AND location=?";

            try (PreparedStatement ps =
                    con.prepareStatement(candidateSql)) {

                ps.setInt(1, candidateId);
                ps.setString(2, country);
                ps.setString(3, state);
                ps.setString(4, district);
                ps.setString(5, location);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {

                        response.getWriter().println(
                                "<script>"
                                + "alert('Invalid Candidate For Your Area');"
                                + "location='vote.jsp';"
                                + "</script>");
                        return;
                    }
                }
            }

            String voteSql =
                    "INSERT INTO vote(voter_id,candidate_id) "
                    + "VALUES(?,?)";

            try (PreparedStatement ps =
                    con.prepareStatement(voteSql)) {

                ps.setInt(1, voterId);
                ps.setInt(2, candidateId);

                int voteInserted =
                        ps.executeUpdate();

                if (voteInserted > 0) {

                    String updateSql =
                            "UPDATE voter "
                            + "SET has_voted=1 "
                            + "WHERE voter_id=?";

                    try (PreparedStatement updatePs =
                            con.prepareStatement(updateSql)) {

                        updatePs.setInt(1, voterId);
                        updatePs.executeUpdate();
                    }

                    response.getWriter().println(
                            "<script>"
                            + "alert('Vote Submitted Successfully');"
                            + "location='voterpage.jsp';"
                            + "</script>");

                } else {

                    response.getWriter().println(
                            "<script>"
                            + "alert('Vote Failed');"
                            + "location='vote.jsp';"
                            + "</script>");
                }
            }
        }

    } catch (IOException | NumberFormatException | SQLException e) {


        response.getWriter().println(
                "<script>"
                + "alert('Error : " + e.getMessage() + "');"
                + "history.back();"
                + "</script>");
    }
}


}
