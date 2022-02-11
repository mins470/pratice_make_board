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
			     
			         public int login(String userID, String userPassword) {
			   String SQL = "SELECT userPassword FROM INFO WHERE userID = ?";          // 오라클에서 만들었던 테이블명
			   try {
				   pstmt = conn.prepareStatement(SQL);
				   pstmt.setString(1,userID);
				   rs = pstmt.executeQuery();
				   if (rs.next()) {
					   if(rs.getString(1).contentEquals(userPassword)) 
						return 1; // 로그인 성공했을때 반환
					else
						return 0; // 비밀번호 불일치일때 반환
				   }
				   return -1; // 아이디가 없을때 반환하도록
			   } catch (Exception e) {
				   e.printStackTrace();
			   }
			   return -2; // 데이터베이스 오류
			  }
			         
			  public int join(User user) {
				  String SQL= "INSERT INTO INFO VALUES (?, ?, ?, ?, ?)";
				  try {
					  pstmt = conn.prepareStatement(SQL);
					  pstmt.setString(1, user.getUserID());
					  pstmt.setString(2, user.getUserPassword());
					  pstmt.setString(3, user.getUserName());
					  pstmt.setString(4, user.getUserGender());
					  pstmt.setString(5, user.getUserEmail());
					  return pstmt.executeUpdate();
				  } catch (Exception e) {
					  e.printStackTrace();
				  }
				  return -1; //데이터 베이스 오류
			  }
}