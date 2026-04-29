package com.testbench.listener;

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
        initializeDatabase();
        createDefaultAdmin();
        createDefaultSystemSettings();
        System.out.println("=== TestBench System Ready ===");
    }

    // ─── CREATE ALL TABLES IF THEY DON'T EXIST ──────────────────────────────
    private void initializeDatabase() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {

            // USERS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS users (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  name VARCHAR(100) NOT NULL," +
                "  email VARCHAR(150) NOT NULL UNIQUE," +
                "  password VARCHAR(255) NOT NULL," +
                "  role VARCHAR(20) DEFAULT 'user'," +
                "  status VARCHAR(20) DEFAULT 'active'," +
                "  profile_image VARCHAR(500)," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // ADMINS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS admins (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  name VARCHAR(100) NOT NULL," +
                "  email VARCHAR(150) NOT NULL UNIQUE," +
                "  password VARCHAR(255) NOT NULL," +
                "  status VARCHAR(20) DEFAULT 'active'," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // SENSOR DATA TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS sensor_data (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  temperature DECIMAL(6,2)," +
                "  pressure DECIMAL(8,2)," +
                "  flow_rate DECIMAL(8,2)," +
                "  level DECIMAL(6,2)," +
                "  device_id VARCHAR(50) DEFAULT 'RPI-001'," +
                "  recorded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // ALERTS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS alerts (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  alert_type VARCHAR(50)," +
                "  message TEXT," +
                "  variable_name VARCHAR(50)," +
                "  variable_value DECIMAL(10,2)," +
                "  threshold_value DECIMAL(10,2)," +
                "  severity VARCHAR(20) DEFAULT 'warning'," +
                "  is_read BOOLEAN DEFAULT FALSE," +
                "  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                ")"
            );

            // CONTROL SETTINGS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS control_settings (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  variable_name VARCHAR(50) NOT NULL," +
                "  min_threshold DECIMAL(10,2)," +
                "  max_threshold DECIMAL(10,2)," +
                "  current_setpoint DECIMAL(10,2)," +
                "  is_active BOOLEAN DEFAULT TRUE," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                ")"
            );

            // AAS SETTINGS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS aas_settings (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  aas_name VARCHAR(100)," +
                "  aas_type VARCHAR(50)," +
                "  variable_controlled VARCHAR(50)," +
                "  passive_value DECIMAL(10,2)," +
                "  reactive_value DECIMAL(10,2)," +
                "  status VARCHAR(20) DEFAULT 'active'," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                ")"
            );

            // SYSTEM SETTINGS TABLE
            st.executeUpdate(
                "CREATE TABLE IF NOT EXISTS system_settings (" +
                "  id INT AUTO_INCREMENT PRIMARY KEY," +
                "  setting_key VARCHAR(100) UNIQUE," +
                "  setting_value VARCHAR(500)," +
                "  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP" +
                ")"
            );

            System.out.println("[INIT] All tables verified/created.");

        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Database init failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ─── CREATE DEFAULT ADMIN IF NOT EXISTS ─────────────────────────────────
    private void createDefaultAdmin() {
        String checkSQL  = "SELECT COUNT(*) FROM admins WHERE email = ?";
        String insertSQL = "INSERT INTO admins (name, email, password, status) VALUES (?, ?, ?, 'active')";

        // *** CHANGE THESE DEFAULT CREDENTIALS AS NEEDED ***
        String adminName     = "System Administrator";
        String adminEmail    = "admin@testbench.com";
        String adminPassword = "Admin@123";   // plain text — will be hashed below

        try (Connection conn = DBConnection.getConnection()) {

            // Check if admin already exists
            PreparedStatement checkPs = conn.prepareStatement(checkSQL);
            checkPs.setString(1, adminEmail);
            ResultSet rs = checkPs.executeQuery();
            rs.next();
            int count = rs.getInt(1);

            if (count == 0) {
                // Admin does NOT exist — create it
                String hashed = PasswordUtil.hashPassword(adminPassword);
                PreparedStatement insertPs = conn.prepareStatement(insertSQL);
                insertPs.setString(1, adminName);
                insertPs.setString(2, adminEmail);
                insertPs.setString(3, hashed);
                insertPs.executeUpdate();
                System.out.println("[INIT] Default admin created: " + adminEmail);
                System.out.println("[INIT] Admin password: " + adminPassword + " (change after first login!)");
            } else {
                System.out.println("[INIT] Admin already exists — skipping creation.");
            }

        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Admin creation failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // ─── CREATE DEFAULT CONTROL SETTINGS IF EMPTY ───────────────────────────
    private void createDefaultSystemSettings() {
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {

            ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM control_settings");
            rs.next();
            if (rs.getInt(1) == 0) {
                st.executeUpdate(
                    "INSERT INTO control_settings (variable_name, min_threshold, max_threshold, current_setpoint) VALUES " +
                    "('temperature', 10.00, 85.00, 25.00)," +
                    "('pressure',    1.00,  10.00, 5.00)," +
                    "('flow_rate',   0.50,  50.00, 20.00)," +
                    "('level',       5.00,  95.00, 60.00)"
                );
                System.out.println("[INIT] Default control settings created.");
            }

            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM aas_settings");
            rs2.next();
            if (rs2.getInt(1) == 0) {
                st.executeUpdate(
                    "INSERT INTO aas_settings (aas_name, aas_type, variable_controlled, passive_value, reactive_value) VALUES " +
                    "('AAS-TEMP-01',  'Reactive', 'temperature', 25.00, 30.00)," +
                    "('AAS-PRES-01',  'Passive',  'pressure',    5.00,  7.50)," +
                    "('AAS-FLOW-01',  'Reactive', 'flow_rate',   20.00, 25.00)," +
                    "('AAS-LEVEL-01', 'Passive',  'level',       60.00, 80.00)"
                );
                System.out.println("[INIT] Default AAS settings created.");
            }

            ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM system_settings");
            rs3.next();
            if (rs3.getInt(1) == 0) {
                st.executeUpdate(
                    "INSERT INTO system_settings (setting_key, setting_value) VALUES " +
                    "('sampling_interval',   '5')," +
                    "('data_retention_days', '90')," +
                    "('alert_email',         'admin@testbench.com')," +
                    "('system_version',      '1.0.0')," +
                    "('backup_enabled',      'true')"
                );
                System.out.println("[INIT] Default system settings created.");
            }

            // Seed 10 sample sensor readings if table is empty
            ResultSet rs4 = st.executeQuery("SELECT COUNT(*) FROM sensor_data");
            rs4.next();
            if (rs4.getInt(1) == 0) {
                for (int i = 10; i >= 1; i--) {
                    double temp  = 20 + Math.random() * 30;
                    double pres  = 3  + Math.random() * 5;
                    double flow  = 10 + Math.random() * 25;
                    double level = 40 + Math.random() * 40;
                    PreparedStatement ps = conn.prepareStatement(
                        "INSERT INTO sensor_data (temperature, pressure, flow_rate, level, recorded_at) " +
                        "VALUES (?, ?, ?, ?, DATE_SUB(NOW(), INTERVAL ? MINUTE))"
                    );
                    ps.setDouble(1, Math.round(temp  * 100.0) / 100.0);
                    ps.setDouble(2, Math.round(pres  * 100.0) / 100.0);
                    ps.setDouble(3, Math.round(flow  * 100.0) / 100.0);
                    ps.setDouble(4, Math.round(level * 100.0) / 100.0);
                    ps.setInt(5, i * 20);
                    ps.executeUpdate();
                }
                System.out.println("[INIT] Sample sensor data seeded.");
            }

            // Welcome alert if alerts table is empty
            ResultSet rs5 = st.executeQuery("SELECT COUNT(*) FROM alerts");
            rs5.next();
            if (rs5.getInt(1) == 0) {
                st.executeUpdate(
                    "INSERT INTO alerts (alert_type, message, severity) VALUES " +
                    "('system_info', 'System initialized and ready for operation.', 'info')"
                );
                System.out.println("[INIT] Welcome alert created.");
            }

        } catch (SQLException e) {
            System.err.println("[INIT ERROR] Settings seed failed: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("=== TestBench System Stopped ===");
    }
}