package com.testbench.servlet;

import com.testbench.dao.DBConnection;
import com.testbench.util.PasswordUtil;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.sql.*;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("=== TestBench System Starting... ===");
        verifyTables();
        createAdminIfNotExists();
        System.out.println("=== TestBench System Ready ===");
    }

    private void verifyTables() {
        String[] tables = {"users", "admins", "sensor_data", "alerts", "control_settings", "aas_settings", "system_settings"};
        try (Connection conn = DBConnection.getConnection()) {
            DatabaseMetaData meta = conn.getMetaData();
            for (String table : tables) {
                ResultSet rs = meta.getTables(null, null, table, new String[]{"TABLE"});
                if (rs.next()) {
                    System.out.println("[INIT] Table verified: " + table);
                } else {
                    System.out.println("[INIT] WARNING: Table NOT found: " + table);
                }
            }
        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Table verification failed: " + e.getMessage());
        }
    }

    private void createAdminIfNotExists() {
        String checkSQL  = "SELECT COUNT(*) FROM admins WHERE LOWER(email) = LOWER(?)";
        String insertSQL = "INSERT INTO admins (name, email, password, status) VALUES (?, ?, ?, 'active')";

        try (Connection conn = DBConnection.getConnection()) {

            // Check if admin exists
            try (PreparedStatement ps = conn.prepareStatement(checkSQL)) {
                ps.setString(1, "admin@testbench.com");
                ResultSet rs = ps.executeQuery();
                if (rs.next() && rs.getInt(1) > 0) {
                    System.out.println("[INIT] Admin already exists — skipping creation.");

                    // Always update hash to ensure it is correct
                    updateAdminHash(conn);
                    return;
                }
            }

            // Insert fresh admin with correctly hashed password
            String hashedPassword = PasswordUtil.hashPassword("Admin@123");
            try (PreparedStatement ps = conn.prepareStatement(insertSQL)) {
                ps.setString(1, "System Administrator");
                ps.setString(2, "admin@testbench.com");
                ps.setString(3, hashedPassword);
                ps.executeUpdate();
                System.out.println("[INIT] Admin created. Email: admin@testbench.com | Password: Admin@123");
                System.out.println("[INIT] Stored hash: " + hashedPassword);
            }

        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Admin creation failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    private void updateAdminHash(Connection conn) {
        // Force-update password hash to ensure it matches PasswordUtil logic
        String updateSQL = "UPDATE admins SET password = ? WHERE LOWER(email) = LOWER(?)";
        try (PreparedStatement ps = conn.prepareStatement(updateSQL)) {
            String correctHash = PasswordUtil.hashPassword("Admin@123");
            ps.setString(1, correctHash);
            ps.setString(2, "admin@testbench.com");
            ps.executeUpdate();
            System.out.println("[INIT] Admin password hash refreshed: " + correctHash);
        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Hash update failed: " + e.getMessage());
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== TestBench System Stopped ===");
    }
}