package com.evoting;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/AICopilotServlet")
public class AICopilotServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain;charset=UTF-8");

        PrintWriter out = response.getWriter();

        String message = request.getParameter("message");

        if (message == null || message.trim().isEmpty()) {
            out.print("Please ask something.");
            return;
        }

        message = message.toLowerCase().trim();

        HttpSession session = request.getSession(false);

        String country = "";
        String state = "";
        String district = "";

        if (session != null) {
            country = (String) session.getAttribute("country");
            state = (String) session.getAttribute("state");
            district = (String) session.getAttribute("district");
        }

        String reply ;

        try (Connection con = DBConnection.getConnection()) {

            // =====================================
            // TOTAL CANDIDATES
            // =====================================

            if (message.contains("total candidate")
                    || message.contains("candidate count")
                    || message.contains("how many candidate")) {

                reply = getTotalCandidates(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // TOTAL VOTERS
            // =====================================

            else if (message.contains("total voter")
                    || message.contains("voter count")
                    || message.contains("how many voter")) {

                reply = getTotalVoters(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // ACTIVE VOTERS
            // =====================================

            else if (message.contains("active voter")) {

                reply = getActiveVoters(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // INACTIVE VOTERS
            // =====================================

            else if (message.contains("inactive voter")) {

                reply = getInactiveVoters(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // BLOCKED VOTERS
            // =====================================

            else if (message.contains("blocked voter")
                    || message.contains("blocked account")) {

                reply = getBlockedVoters(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // PENDING VOTERS
            // =====================================

            else if (message.contains("pending voter")
                    || message.contains("not voted")) {

                reply = getPendingVoters(
                        con,
                        country,
                        state,
                        district);
            }

            // =====================================
            // TOTAL VOTES
            // =====================================

            else if (message.contains("total vote")
                    || message.contains("votes cast")) {

                reply = getTotalVotes(
                        con,
                        district);
            }

           
else if(message.contains("voting status")
        || message.contains("election status")) {

    reply = getVotingStatus(
            con,country,state,district);
}

else if(message.contains("result status")
        || message.contains("result published")) {

    reply = getResultStatus(
            con,country,state,district);
}

else if(message.contains("winner")
        || message.contains("leading")) {

    reply = getCurrentWinner(
            con,country,state,district);
}

else if(message.contains("prediction")
        || message.contains("who will win")) {

    reply = getPrediction(
            con,country,state,district);
}

else if(message.contains("highest vote")) {

    reply = getHighestVote(
            con,country,state,district);
}

else if(message.contains("lowest vote")) {

    reply = getLowestVote(
            con,country,state,district);
}

else if(message.contains("fraud")
        || message.contains("suspicious")) {

    reply = getFraudCount(
            con,country,state,district);
}

else if(message.contains("last fraud")) {

    reply = getLastFraud(
            con,country,state,district);
}

else if(message.contains("history")) {

    reply = getElectionHistory(
            con,country,state,district);
}

else if(message.contains("help")) {

    reply = getHelp();
}

else {

    reply =
    "🤖 Sorry, I understand only election related queries.\nType HELP.";
}
        } catch (Exception e) {

            reply = "❌ Error : " + e.getMessage();
        }

        out.print(reply);
    }

    // ==================================================
    // TOTAL CANDIDATES
    // ==================================================

    private String getTotalCandidates(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM candidate "
                + "WHERE country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "🧑‍💼 Total Candidates in "
                    + district
                    + " : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // TOTAL VOTERS
    // ==================================================

    private String getTotalVoters(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM voter "
                + "WHERE country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "🧑‍💻 Total Voters in "
                    + district
                    + " : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // ACTIVE VOTERS
    // ==================================================

    private String getActiveVoters(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM voter "
                + "WHERE status='active' "
                + "AND country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "✅ Active Voters : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // INACTIVE VOTERS
    // ==================================================

    private String getInactiveVoters(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM voter "
                + "WHERE status='inactive' "
                + "AND country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "❌ Inactive Voters : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // BLOCKED VOTERS
    // ==================================================

    private String getBlockedVoters(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM voter "
                + "WHERE status='blocked' "
                + "AND country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "🚫 Blocked Voters : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // PENDING VOTERS
    // ==================================================

    private String getPendingVoters(
            Connection con,
            String country,
            String state,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM voter "
                + "WHERE has_voted=0 "
                + "AND country=? "
                + "AND state=? "
                + "AND district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, country);
        ps.setString(2, state);
        ps.setString(3, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "⌛ Pending Voters : "
                    + rs.getInt(1);
        }

        return "0";
    }

    // ==================================================
    // TOTAL VOTES
    // ==================================================

    private String getTotalVotes(
            Connection con,
            String district) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM vote "
                + "WHERE district=?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, district);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            return "🗳️ Total Votes Cast in "
                    + district
                    + " : "
                    + rs.getInt(1);
        }

        return "0";
    }


private String getVotingStatus(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT voting_status " +
        "FROM election_status " +
        "WHERE country=? AND state=? AND district=?";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "📢 Voting Status : "
            + rs.getString("voting_status");
}

return "No election status found.";


}

private String getResultStatus(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT result_status " +
        "FROM election_status " +
        "WHERE country=? AND state=? AND district=?";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "📊 Result Status : "
            + rs.getString("result_status");
}

return "No result status found.";


}

private String getCurrentWinner(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT * FROM result_view " +
        "WHERE country=? AND state=? AND district=? " +
        "ORDER BY total_votes DESC LIMIT 1";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "🏆 Current Winner : "
            + rs.getString("candidate_name")
            + " ("
            + rs.getString("party_name")
            + ") with "
            + rs.getInt("total_votes")
            + " votes";
}

return "No winner found.";


}

private String getPrediction(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT * FROM result_view " +
        "WHERE country=? AND state=? AND district=? " +
        "ORDER BY total_votes DESC LIMIT 1";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "🤖 AI Prediction : "
            + rs.getString("candidate_name")
            + " from "
            + rs.getString("party_name")
            + " is leading with "
            + rs.getInt("total_votes")
            + " votes.";
}

return "Prediction unavailable.";


}

private String getHighestVote(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT * FROM result_view " +
        "WHERE country=? AND state=? AND district=? " +
        "ORDER BY total_votes DESC LIMIT 1";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "🔥 Highest Votes : "
            + rs.getInt("total_votes")
            + " by "
            + rs.getString("candidate_name");
}

return "No vote data found.";


}

private String getLowestVote(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT * FROM result_view " +
        "WHERE country=? AND state=? AND district=? " +
        "ORDER BY total_votes ASC LIMIT 1";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "📉 Lowest Votes : "
            + rs.getInt("total_votes")
            + " by "
            + rs.getString("candidate_name");
}

return "No vote data found.";


}

private String getFraudCount(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT COUNT(*) " +
        "FROM fraud_log f " +
        "INNER JOIN voter v " +
        "ON f.voter_id=v.voter_id " +
        "WHERE v.country=? " +
        "AND v.state=? " +
        "AND v.district=?";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    int count = rs.getInt(1);

    if(count==0) {

        return "✅ No Fraud Activity Detected.";
    }

    return "🚨 Fraud Alerts Found : "
            + count;
}

return "No fraud records.";


}

private String getLastFraud(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT f.message,f.log_time " +
        "FROM fraud_log f " +
        "INNER JOIN voter v " +
        "ON f.voter_id=v.voter_id " +
        "WHERE v.country=? " +
        "AND v.state=? " +
        "AND v.district=? " +
        "ORDER BY f.log_time DESC LIMIT 1";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "🚨 Last Fraud : "
            + rs.getString("message")
            + " | "
            + rs.getTimestamp("log_time");
}

return "✅ No Fraud Records Found.";


}

private String getElectionHistory(
Connection con,
String country,
String state,
String district) throws Exception {


String sql =
        "SELECT COUNT(*) " +
        "FROM election_history " +
        "WHERE country=? " +
        "AND state=? " +
        "AND district=?";

PreparedStatement ps =
        con.prepareStatement(sql);

ps.setString(1,country);
ps.setString(2,state);
ps.setString(3,district);

ResultSet rs = ps.executeQuery();

if(rs.next()) {

    return "📜 Election History Records : "
            + rs.getInt(1);
}

return "No history found.";


}

private String getHelp() {


return
"🤖 Available Commands:\n\n"
+ "• total candidates\n"
+ "• total voters\n"
+ "• active voters\n"
+ "• inactive voters\n"
+ "• blocked voters\n"
+ "• pending voters\n"
+ "• total votes\n"
+ "• voting status\n"
+ "• result status\n"
+ "• winner\n"
+ "• prediction\n"
+ "• highest vote\n"
+ "• lowest vote\n"
+ "• fraud\n"
+ "• last fraud\n"
+ "• history";


}
}
