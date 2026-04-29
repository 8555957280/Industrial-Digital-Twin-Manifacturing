package com.testbench.dao;

import com.testbench.model.Alert;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AlertDAO {

    public List<Alert> getAllAlerts() {
        List<Alert> list = new ArrayList<>();
        String sql = "SELECT * FROM alerts ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Alert a = new Alert();
                a.setId(rs.getInt("id"));
                a.setAlertType(rs.getString("alert_type"));
                a.setMessage(rs.getString("message"));
                a.setVariableName(rs.getString("variable_name"));
                a.setVariableValue(rs.getDouble("variable_value"));
                a.setThresholdValue(rs.getDouble("threshold_value"));
                a.setSeverity(rs.getString("severity"));
                a.setRead(rs.getBoolean("is_read"));
                a.setCreatedAt(rs.getString("created_at"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<Alert> getUnreadAlerts() {
        List<Alert> list = new ArrayList<>();
        String sql = "SELECT * FROM alerts WHERE is_read=FALSE ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                Alert a = new Alert();
                a.setId(rs.getInt("id"));
                a.setMessage(rs.getString("message"));
                a.setSeverity(rs.getString("severity"));
                a.setCreatedAt(rs.getString("created_at"));
                list.add(a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countUnread() {
        String sql = "SELECT COUNT(*) FROM alerts WHERE is_read=FALSE";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public boolean markAllRead() {
        String sql = "UPDATE alerts SET is_read=TRUE";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
            return true;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean addAlert(String type, String message, String varName, double varVal, double threshold, String severity) {
        String sql = "INSERT INTO alerts (alert_type, message, variable_name, variable_value, threshold_value, severity) VALUES (?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, type);
            ps.setString(2, message);
            ps.setString(3, varName);
            ps.setDouble(4, varVal);
            ps.setDouble(5, threshold);
            ps.setString(6, severity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}