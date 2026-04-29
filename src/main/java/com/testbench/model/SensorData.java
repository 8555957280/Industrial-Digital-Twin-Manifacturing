package com.testbench.model;

public class SensorData {
    private int id;
    private double temperature;
    private double pressure;
    private double flowRate;
    private double level;
    private String deviceId;
    private String recordedAt;

    public SensorData() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public double getTemperature() { return temperature; }
    public void setTemperature(double temperature) { this.temperature = temperature; }
    public double getPressure() { return pressure; }
    public void setPressure(double pressure) { this.pressure = pressure; }
    public double getFlowRate() { return flowRate; }
    public void setFlowRate(double flowRate) { this.flowRate = flowRate; }
    public double getLevel() { return level; }
    public void setLevel(double level) { this.level = level; }
    public String getDeviceId() { return deviceId; }
    public void setDeviceId(String deviceId) { this.deviceId = deviceId; }
    public String getRecordedAt() { return recordedAt; }
    public void setRecordedAt(String recordedAt) { this.recordedAt = recordedAt; }
}