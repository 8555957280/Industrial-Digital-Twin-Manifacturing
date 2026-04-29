package com.testbench.dao;

import com.testbench.model.SensorData;
import com.testbench.model.ControlSetting;
import com.testbench.model.AASSetting;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class SensorDAO {

    public SensorData getLatestReading() {
        String sql = "SELECT * FROM sensor_data ORDER BY recorded_at DESC LIMIT 1";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) {
                SensorData s = new SensorData();
                s.setId(rs.getInt("id"));
                s.setTemperature(rs.getDouble("temperature"));
                s.setPressure(rs.getDouble("pressure"));
                s.setFlowRate(rs.getDouble("flow_rate"));
                s.setLevel(rs.getDouble("level"));
                s.setDeviceId(rs.getString("device_id"));
                s.setRecordedAt(rs.getString("recorded_at"));
                return s;
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return null;
    }

    public List<SensorData> getLast50Readings() {
        List<SensorData> list = new ArrayList<>();
        String sql = "SELECT * FROM sensor_data ORDER BY recorded_at DESC LIMIT 50";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                SensorData s = new SensorData();
                s.setId(rs.getInt("id"));
                s.setTemperature(rs.getDouble("temperature"));
                s.setPressure(rs.getDouble("pressure"));
                s.setFlowRate(rs.getDouble("flow_rate"));
                s.setLevel(rs.getDouble("level"));
                s.setDeviceId(rs.getString("device_id"));
                s.setRecordedAt(rs.getString("recorded_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public List<SensorData> getAllReadings() {
        List<SensorData> list = new ArrayList<>();
        String sql = "SELECT * FROM sensor_data ORDER BY recorded_at DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                SensorData s = new SensorData();
                s.setId(rs.getInt("id"));
                s.setTemperature(rs.getDouble("temperature"));
                s.setPressure(rs.getDouble("pressure"));
                s.setFlowRate(rs.getDouble("flow_rate"));
                s.setLevel(rs.getDouble("level"));
                s.setDeviceId(rs.getString("device_id"));
                s.setRecordedAt(rs.getString("recorded_at"));
                list.add(s);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return list;
    }

    public int countReadings() {
        String sql = "SELECT COUNT(*) FROM sensor_data";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            if (rs.next()) return rs.getInt(1);
        } catch (SQLException e) { e.printStackTrace(); }
        return 0;
    }

    public List<ControlSetting> getControlSettings() {
        Map<String, ControlSetting> uniqueSettings = new LinkedHashMap<>();
        String sql = "SELECT * FROM control_settings ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                ControlSetting cs = new ControlSetting();
                cs.setId(rs.getInt("id"));
                cs.setVariableName(rs.getString("variable_name"));
                cs.setMinThreshold(rs.getDouble("min_threshold"));
                cs.setMaxThreshold(rs.getDouble("max_threshold"));
                cs.setCurrentSetpoint(rs.getDouble("current_setpoint"));
                cs.setActive(rs.getBoolean("is_active"));
                uniqueSettings.putIfAbsent(cs.getVariableName(), cs);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return new ArrayList<>(uniqueSettings.values());
    }

    public boolean updateControlSetting(String variableName, double min, double max, double setpoint) {
        String sql = "UPDATE control_settings SET min_threshold=?, max_threshold=?, current_setpoint=? WHERE variable_name=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, min);
            ps.setDouble(2, max);
            ps.setDouble(3, setpoint);
            ps.setString(4, variableName);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public List<AASSetting> getAASSettings() {
        Map<String, AASSetting> uniqueSettings = new LinkedHashMap<>();
        String sql = "SELECT * FROM aas_settings ORDER BY id";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement();
             ResultSet rs = st.executeQuery(sql)) {
            while (rs.next()) {
                AASSetting a = new AASSetting();
                a.setId(rs.getInt("id"));
                a.setAasName(rs.getString("aas_name"));
                a.setAasType(rs.getString("aas_type"));
                a.setVariableControlled(rs.getString("variable_controlled"));
                a.setPassiveValue(rs.getDouble("passive_value"));
                a.setReactiveValue(rs.getDouble("reactive_value"));
                a.setStatus(rs.getString("status"));
                uniqueSettings.putIfAbsent(a.getAasName(), a);
            }
        } catch (SQLException e) { e.printStackTrace(); }
        return new ArrayList<>(uniqueSettings.values());
    }

    public boolean updateAASSetting(int id, double passive, double reactive, String type, String status) {
        String sql = "UPDATE aas_settings SET passive_value=?, reactive_value=?, aas_type=?, status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, passive);
            ps.setDouble(2, reactive);
            ps.setString(3, type);
            ps.setString(4, status);
            ps.setInt(5, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }

    public boolean deleteAllSensorData() {
        String sql = "DELETE FROM sensor_data WHERE recorded_at < DATE_SUB(NOW(), INTERVAL 90 DAY)";
        try (Connection conn = DBConnection.getConnection();
             Statement st = conn.createStatement()) {
            st.executeUpdate(sql);
            return true;
        } catch (SQLException e) { e.printStackTrace(); }
        return false;
    }
}