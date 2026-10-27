package com.jobportal.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.jobportal.model.User;

import db.DBConnection;

public class UserDAO {

    public boolean register(User user) {
        try {
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password) VALUES(?,?,?)"
            );
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.executeUpdate();
            return true;
        } catch(Exception e){ e.printStackTrace(); return false; }
    }

    public static User login(String email, String password){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=? AND password=?"
            );
            ps.setString(1,email);
            ps.setString(2,password);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                u.setPassword(rs.getString("password"));
                return u;
            }
        } catch(Exception e){ e.printStackTrace(); }
        return null;
    }

    public static User getUserById(int id){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("SELECT * FROM users WHERE id=?");
            ps.setInt(1,id);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                User u = new User();
                u.setId(rs.getInt("id"));
                u.setFullName(rs.getString("name"));
                u.setEmail(rs.getString("email"));
                return u;
            }
        } catch(Exception e){ e.printStackTrace(); }
        return null;
    }

    public boolean update(User user){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET name=?, email=? WHERE id=?"
            );
            ps.setString(1,user.getFullName());
            ps.setString(2,user.getEmail());
            ps.setInt(3,user.getId());
            ps.executeUpdate();
            return true;
        } catch(Exception e){ e.printStackTrace(); return false; }
    }
    public static boolean deleteUser(int userId){
        try{
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement("DELETE FROM users WHERE id=?");
            ps.setInt(1, userId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch(Exception e){
            e.printStackTrace();
            return false;
        }

    }

}
