package forum;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

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
	
	public ArrayList<Forum> getList(int pageNumber) {
		String SQL = "SELECT * FROM FORUM WHERE ForumID < ? AND forumAvailable = 1 ORDER BY ForumID DESC LIMIT 10";
		ArrayList<Forum> list = new ArrayList<Forum>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				Forum forum = new Forum();
				forum.setForumID(rs.getInt(1));
				forum.setForumTitle(rs.getString(2));
				forum.setUserID(rs.getString(3));
				forum.setForumDate(rs.getString(4));
				forum.setForumContent(rs.getString(5));
				forum.setForumAvailable(rs.getInt(6));
				list.add(forum);
			}
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return list; //데이터베이스 오류
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM FORUM WHERE ForumID < ? AND forumAvailable = 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return false; //데이터베이스 오류
	}
}
