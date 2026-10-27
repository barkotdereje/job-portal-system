package com.jobportal.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.jobportal.model.CV;

import db.DBConnection;
public class CVDAO {

public boolean buildCV(int userId, String content){
try{
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("INSERT INTO cv(jobseeker_id, skills) VALUES(?,?)");
ps.setInt(1,userId);
ps.setString(2,content);
ps.executeUpdate();
return true;
} catch(Exception e){ e.printStackTrace(); return false; }
}

public static CV getCVByUserId(int userId) {
CV cv = null;
try (Connection conn = DBConnection.getConnection()) {
PreparedStatement ps = conn.prepareStatement(
"SELECT * FROM cv WHERE jobseeker_id=?"
);
ps.setInt(1, userId);
ResultSet rs = ps.executeQuery();
if (rs.next()) {
cv = new CV();
cv.setId(rs.getInt("id"));
cv.setUserId(rs.getInt("jobseeker_id"));
cv.setContent(rs.getString("skills"));
}
} catch (Exception e) {
e.printStackTrace();
}
return cv;
}

public String getCV(int userId){
try{
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("SELECT content FROM cv WHERE jobseeker_id=?");
ps.setInt(1,userId);
ResultSet rs = ps.executeQuery();
if(rs.next()){
return rs.getString("content");
}
} catch(Exception e){ e.printStackTrace(); }
return null;
}

public static boolean saveCV(CV cv) {
boolean saved = false;
try (Connection conn = DBConnection.getConnection()) {
PreparedStatement ps = conn.prepareStatement(
"INSERT INTO cv (jobseeker_id, skills) VALUES (?, ?)"
);
ps.setInt(1, cv.getUserId());
ps.setString(2, cv.getContent());
saved = ps.executeUpdate() > 0;
} catch (Exception e) {
e.printStackTrace();
}
return saved;
}

public static boolean updateCV(int cvId, String content) {
boolean status = false;
String sql = "UPDATE cv SET skills=? WHERE id=?";

try (Connection conn = DBConnection.getConnection();
PreparedStatement ps = conn.prepareStatement(sql)) {

ps.setString(1, content);
ps.setInt(2, cvId);

status = ps.executeUpdate() > 0;

} catch (Exception e) {
e.printStackTrace();
}
return status;
}


public boolean deleteCV(int cvId){
try{
Connection con = DBConnection.getConnection();
PreparedStatement ps = con.prepareStatement("DELETE FROM cv WHERE id=?");
ps.setInt(1, cvId);
ps.executeUpdate();
return true;
} catch(Exception e){ e.printStackTrace(); return false; }
}
}