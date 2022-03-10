package bookbbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BookBbsDAO {
	
	private Connection conn;
	private ResultSet rs;
	
	public BookBbsDAO() {
		try {
			
			String dbURL = "jdbc:mysql://localhost:3306/BBS";
			   String dbID = "root";
			   String dbPassword = "root";
			   Class.forName("com.mysql.jdbc.Driver");
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
		String SQL = "SELECT bbsID FROM BOOKBBS ORDER BY bbsID DESC";
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
	public int getCount(int boardID) {
		String SQL = "SELECT COUNT(*) FROM BOOKBBS WHERE boardID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			rs = pstmt.executeQuery();
			if (rs.next()) {	
				return rs.getInt(1);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1;
	}
	public int write(int boardID, String bbsTitle, String userID, String bbsContent) {
		String SQL = "INSERT INTO BOOKBBS VALUES (?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2, getNext());
			pstmt.setString(3, bbsTitle);
			pstmt.setString(4, userID);
			pstmt.setString(5, getDate());
			pstmt.setString(6, bbsContent);
			pstmt.setInt(7, 1);
			pstmt.executeUpdate();
			return getNext();
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return -1; //데이터베이스 오류
	}
	
	public ArrayList<BookBbs> getList(int boardID, int pageNumber) {
		String SQL = "SELECT * FROM BOOKBBS WHERE boardID = ? AND bbsID < ? AND bbsAvailable = 1 ORDER BY bbsID DESC LIMIT 10";
		ArrayList<BookBbs> list = new ArrayList<BookBbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, boardID);
			pstmt.setInt(2, getNext() - (pageNumber - 1) * 10);
			rs = pstmt.executeQuery();
			while (rs.next()) {
				BookBbs bbs = new BookBbs();
				bbs.setBoardID(rs.getInt(1));
				bbs.setBbsID(rs.getInt(2));
				bbs.setBbsTitle(rs.getString(3));
				bbs.setUserID(rs.getString(4));
				bbs.setBbsDate(rs.getString(5));
				bbs.setBbsContent(rs.getString(6));
				bbs.setBbsAvailable(rs.getInt(7));
				list.add(bbs);
			}
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return list; //데이터베이스 오류
	}
	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM BOOKBBS WHERE bbsID < ? AND bbsAvailable = 1";
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
	
	public BookBbs getBbs(int bbsID) {
		String SQL = "SELECT * FROM BOOKBBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1,  bbsID);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				BookBbs bbs = new BookBbs();
				bbs.setBoardID(rs.getInt(1));
				bbs.setBbsID(rs.getInt(2));
				bbs.setBbsTitle(rs.getString(3));
				bbs.setUserID(rs.getString(4));
				bbs.setBbsDate(rs.getString(5));
				bbs.setBbsContent(rs.getString(6));
				bbs.setBbsAvailable(rs.getInt(7));
				return bbs;
			}
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return null; //데이터베이스 오류
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent) {
		String SQL = "UPDATE BOOKBBS SET bbsTitle =?, bbsContent = ? WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return -1; //데이터베이스 오류
		
	}
	
	public int delete(int bbsID) {
		String SQL = "DELETE FROM BOOKBBS WHERE bbsID = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();	
		} 
		return -1; //데이터베이스 오류
		
	}
	
	public ArrayList<BookBbs> getSearch(String searchField, String searchText){//특정한 리스트를 받아서 반환
	      ArrayList<BookBbs> list = new ArrayList<BookBbs>();
	      String SQL ="select * from BOOKBBS WHERE "+searchField.trim();
	      try {
	            if(searchText != null && !searchText.equals("") ){//이거 빼면 안 나온다ㅜ 왜지?
	                SQL +=" LIKE '%"+searchText.trim()+"%' order by bbsID desc limit 10";
	            }
	            PreparedStatement pstmt=conn.prepareStatement(SQL);
				rs=pstmt.executeQuery();//select
	         while(rs.next()) {
	            BookBbs bbs = new BookBbs();
	            bbs.setBbsID(rs.getInt(1));
	            bbs.setBbsTitle(rs.getString(2));
	            bbs.setUserID(rs.getString(3));
	            bbs.setBbsDate(rs.getString(4));
	            bbs.setBbsContent(rs.getString(5));
	            bbs.setBbsAvailable(rs.getInt(6));
	            list.add(bbs);//list에 해당 인스턴스를 담는다.
	         }         
	      } catch(Exception e) {
	         e.printStackTrace();
	      }
	      return list;//게시글 리스트 반환
	   }
}
