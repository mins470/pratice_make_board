package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
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
			     
			         public int login(String UserID, String UserPassword) {
			   String SQL = "SELECT UserPassword FROM BOARD WHERE userID = ?";          // 오라클에서 만들었던 테이블명
			   try {
				   pstmt = conn.prepareStatement(SQL);
				   pstmt.setString(1,UserID);
				   rs = pstmt.executeQuery();
				   if (rs.next()) {
					   if(rs.getNString(1).contentEquals(UserPassword)) 
						return -1; // 로그인 성공했을때 반환
					else
						return 0; // 비밀번호 불일치일때 반환
				   }
				   return -1; // 아이디가 없을때 반환하도록
			   } catch (Exception e) {
				   e.printStackTrace();
			   }
			   return -2; // 데이터베이스 오류
			         }
}