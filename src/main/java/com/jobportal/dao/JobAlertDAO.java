package com.jobportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.jobportal.model.JobAlert;

import db.DBConnection;

public class JobAlertDAO {

    public boolean addAlert(int userId, String keyword){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("INSERT INTO job_alerts(jobseeker_id, keyword) VALUES(?,?)");
            ps.setInt(1,userId);
            ps.setString(2, keyword);
            ps.executeUpdate();
            return true;
        } catch(Exception e){ e.printStackTrace(); return false; }
    }

    public List<JobAlert> getAlertsByUserId(int userId){
        List<JobAlert> alerts = new ArrayList<>();
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM job_alerts WHERE jobseeker_id=?");
            ps.setInt(1,userId);
            ResultSet rs = ps.executeQuery();
            while(rs.next()){
                JobAlert alert = new JobAlert();
                alert.setId(rs.getInt("id"));
                alert.setUserId(rs.getInt("jobseeker_id"));
                alert.setKeyword(rs.getString("keyword"));
                alerts.add(alert);
            }
        } catch(Exception e){ e.printStackTrace(); }
        return alerts;
    }

    public boolean deleteAlert(int alertId){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM job_alerts WHERE id=?");
            ps.setInt(1, alertId);
            ps.executeUpdate();
            return true;
        } catch(Exception e){ e.printStackTrace(); return false; }
    }
}
