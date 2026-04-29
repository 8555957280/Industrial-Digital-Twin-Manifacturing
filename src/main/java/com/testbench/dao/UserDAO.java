package com.testbench.dao;

import com.testbench.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // ─── USER AUTH ────────────────────────────────────────────────────────────

    public User loginUser(String email, String password) {
        String sql = "SELECT * FROM users WHERE LOWER(email) = LOWER(?) AND password = ? AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setProfileImage(rs.getString("profile_image"));
                return u;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] loginUser error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // ─── ADMIN AUTH ───────────────────────────────────────────────────────────

    public boolean loginAdmin(String email, String password) {
        String sql = "SELECT id FROM admins WHERE LOWER(email) = LOWER(?) AND password = ? AND status = 'active'";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            boolean found = rs.next();
            System.out.println("[UserDAO] loginAdmin attempt: email=" + email + " | found=" + found);
            return found;
        } catch (SQLException e) {
            System.err.println("[UserDAO] loginAdmin error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public String getAdminName(String email) {
        String sql = "SELECT name FROM admins WHERE LOWER(email) = LOWER(?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("name");
        } catch (SQLException e) {
            System.err.println("[UserDAO] getAdminName error: " + e.getMessage());
            e.printStackTrace();
        }
        return "Admin";
    }

    // ─── USER MANAGEMENT ─────────────────────────────────────────────────────

    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setProfileImage(rs.getString("profile_image"));
                u.setCreatedAt(rs.getString("created_at"));
                list.add(u);
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] getAllUsers error: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    public boolean addUser(User user) {
        String sql = "INSERT INTO users (name, email, password, role, status) VALUES (?, ?, ?, ?, 'active')";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getRole());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] addUser error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateUser(User user) {
        String sql = "UPDATE users SET name = ?, email = ?, role = ?, status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getRole());
            ps.setString(4, user.getStatus());
            ps.setInt(5, user.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] updateUser error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteUser(int id) {
        String sql = "DELETE FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("[UserDAO] deleteUser error: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public int countUsers() {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("[UserDAO] countUsers error: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setRole(rs.getString("role"));
                u.setStatus(rs.getString("status"));
                u.setProfileImage(rs.getString("profile_image"));
                return u;
            }
        } catch (SQLException e) {
            System.err.println("[UserDAO] getUserById error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }
}