package com.testbench.model;

public class Alert {
    private int id;
    private String alertType;
    private String message;
    private String variableName;
    private double variableValue;
    private double thresholdValue;
    private String severity;
    private boolean isRead;
    private String createdAt;

    public Alert() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getAlertType() { return alertType; }
    public void setAlertType(String alertType) { this.alertType = alertType; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getVariableName() { return variableName; }
    public void setVariableName(String variableName) { this.variableName = variableName; }
    public double getVariableValue() { return variableValue; }
    public void setVariableValue(double variableValue) { this.variableValue = variableValue; }
    public double getThresholdValue() { return thresholdValue; }
    public void setThresholdValue(double thresholdValue) { this.thresholdValue = thresholdValue; }
    public String getSeverity() { return severity; }
    public void setSeverity(String severity) { this.severity = severity; }
    public boolean isRead() { return isRead; }
    public void setRead(boolean read) { isRead = read; }
    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }
}