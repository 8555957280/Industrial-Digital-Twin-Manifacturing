package com.testbench.model;

public class AASSetting {
    private int id;
    private String aasName;
    private String aasType;
    private String variableControlled;
    private double passiveValue;
    private double reactiveValue;
    private String status;

    public AASSetting() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getAasName() { return aasName; }
    public void setAasName(String v) { this.aasName = v; }
    public String getAasType() { return aasType; }
    public void setAasType(String v) { this.aasType = v; }
    public String getVariableControlled() { return variableControlled; }
    public void setVariableControlled(String v) { this.variableControlled = v; }
    public double getPassiveValue() { return passiveValue; }
    public void setPassiveValue(double v) { this.passiveValue = v; }
    public double getReactiveValue() { return reactiveValue; }
    public void setReactiveValue(double v) { this.reactiveValue = v; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
}