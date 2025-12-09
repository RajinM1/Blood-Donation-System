package com.blooddonation.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class BloodReport {
    private int id;
    private int donorId;
    private Integer appointmentId;
    private BigDecimal hemoglobin;
    private BigDecimal rbc;
    private BigDecimal hct;
    private BigDecimal mcv;
    private BigDecimal mch;
    private BigDecimal mchc;
    private BigDecimal rdw;
    private BigDecimal wbc;
    private BigDecimal esr;
    private BigDecimal plt;
    private BigDecimal gra;
    private BigDecimal lym;
    private BigDecimal eos;
    private BigDecimal bas;
    private Integer bloodPressureSystolic;
    private Integer bloodPressureDiastolic;
    private Integer pulseRate;
    private BigDecimal temperature;
    private BigDecimal weightAtDonation;
    private Integer donationVolume;
    private String medicalStaffNotes;
    private String status;
    private Integer testedBy;
    private Timestamp testedAt;
    private Timestamp createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getDonorId() { return donorId; }
    public void setDonorId(int donorId) { this.donorId = donorId; }
    public BigDecimal getHemoglobin() { return hemoglobin; }
    public void setHemoglobin(BigDecimal hemoglobin) { this.hemoglobin = hemoglobin; }
    public BigDecimal getRbc() { return rbc; }
    public void setRbc(BigDecimal rbc) { this.rbc = rbc; }
    public BigDecimal getHct() { return hct; }
    public void setHct(BigDecimal hct) { this.hct = hct; }
    public BigDecimal getMcv() { return mcv; }
    public void setMcv(BigDecimal mcv) { this.mcv = mcv; }
    public BigDecimal getMch() { return mch; }
    public void setMch(BigDecimal mch) { this.mch = mch; }
    public BigDecimal getMchc() { return mchc; }
    public void setMchc(BigDecimal mchc) { this.mchc = mchc; }
    public BigDecimal getRdw() { return rdw; }
    public void setRdw(BigDecimal rdw) { this.rdw = rdw; }
    public BigDecimal getWbc() { return wbc; }
    public void setWbc(BigDecimal wbc) { this.wbc = wbc; }
    public BigDecimal getEsr() { return esr; }
    public void setEsr(BigDecimal esr) { this.esr = esr; }
    public BigDecimal getPlt() { return plt; }
    public void setPlt(BigDecimal plt) { this.plt = plt; }
    public BigDecimal getGra() { return gra; }
    public void setGra(BigDecimal gra) { this.gra = gra; }
    public BigDecimal getLym() { return lym; }
    public void setLym(BigDecimal lym) { this.lym = lym; }
    public BigDecimal getEos() { return eos; }
    public void setEos(BigDecimal eos) { this.eos = eos; }
    public BigDecimal getBas() { return bas; }
    public void setBas(BigDecimal bas) { this.bas = bas; }
    public Integer getAppointmentId() { return appointmentId; }
    public void setAppointmentId(Integer appointmentId) { this.appointmentId = appointmentId; }
    public Integer getBloodPressureSystolic() { return bloodPressureSystolic; }
    public void setBloodPressureSystolic(Integer bloodPressureSystolic) { this.bloodPressureSystolic = bloodPressureSystolic; }
    public Integer getBloodPressureDiastolic() { return bloodPressureDiastolic; }
    public void setBloodPressureDiastolic(Integer bloodPressureDiastolic) { this.bloodPressureDiastolic = bloodPressureDiastolic; }
    public Integer getPulseRate() { return pulseRate; }
    public void setPulseRate(Integer pulseRate) { this.pulseRate = pulseRate; }
    public BigDecimal getTemperature() { return temperature; }
    public void setTemperature(BigDecimal temperature) { this.temperature = temperature; }
    public BigDecimal getWeightAtDonation() { return weightAtDonation; }
    public void setWeightAtDonation(BigDecimal weightAtDonation) { this.weightAtDonation = weightAtDonation; }
    public Integer getDonationVolume() { return donationVolume; }
    public void setDonationVolume(Integer donationVolume) { this.donationVolume = donationVolume; }
    public String getMedicalStaffNotes() { return medicalStaffNotes; }
    public void setMedicalStaffNotes(String medicalStaffNotes) { this.medicalStaffNotes = medicalStaffNotes; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public Integer getTestedBy() { return testedBy; }
    public void setTestedBy(Integer testedBy) { this.testedBy = testedBy; }
    public Timestamp getTestedAt() { return testedAt; }
    public void setTestedAt(Timestamp testedAt) { this.testedAt = testedAt; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}