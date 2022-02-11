package forum;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ForumDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public ForumDAO() {
		try {
			
			String dbURL = "jdbc:oracle:thin:@localhost:1521:xe";
			   String dbID = "board";
			   String dbPassword = "1234";
			   Class.forName("oracle.jdbc.driver.OracleDriver");
			   conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
			  } catch (Exception e) {
			   e.printStackTrace();
			  }
		}
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1);
			}
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return ""; //데이터베이스 오류
	}
	
	public int getNext() {
		String SQL = "SELECT ForumID FROM FORUM ORDER BY ForumID DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫번째 게시물 인 경우 반환
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return -1; //데이터베이스 오류
	}
	
	public int write(String forumTitle, String userID, String forumContent) {
		String SQL = "INSERT INTO Forum VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, forumTitle);
			pstmt.setString(3, userID);
			pstmt.setString(4, getDate());
			pstmt.setString(5, forumContent);
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return -1; //데이터베이스 오류
	}
}
