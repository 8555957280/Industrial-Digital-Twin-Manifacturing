package com.testbench.model;

public class ControlSetting {
    private int id;
    private String variableName;
    private double minThreshold;
    private double maxThreshold;
    private double currentSetpoint;
    private boolean isActive;

    public ControlSetting() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getVariableName() { return variableName; }
    public void setVariableName(String v) { this.variableName = v; }
    public double getMinThreshold() { return minThreshold; }
    public void setMinThreshold(double v) { this.minThreshold = v; }
    public double getMaxThreshold() { return maxThreshold; }
    public void setMaxThreshold(double v) { this.maxThreshold = v; }
    public double getCurrentSetpoint() { return currentSetpoint; }
    public void setCurrentSetpoint(double v) { this.currentSetpoint = v; }
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
}