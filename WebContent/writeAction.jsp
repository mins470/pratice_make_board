<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="forum.ForumDAO" %>   
 <%@ page import="java.io.PrintWriter" %>   
 <% request.setCharacterEncoding("UTF-8");%>
 <jsp:useBean id="forum" class="forum.Forum" scope="page" />   
 <jsp:setProperty name="forum" property="forumTitle"/>  
 <jsp:setProperty name="forum" property="forumContent"/>      
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP로 만든 게시판 웹사이트</title>
</head>
<body>
 <%
	String userID = null;
	if (session.getAttribute("userID") !=null) {
	 userID = (String) session.getAttribute("userID");
	}
	if (userID == null) {
		PrintWriter script = response.getWriter();
		script.println("<script>");
		script.println("alert('로그인을 하세요.')");
		script.println("location.href = 'login.jsp'");
		script.println("</script>");
	} else {
		if(forum.getForumTitle() == null || forum.getForumContent() == null) {
			 		PrintWriter script = response.getWriter();
			 		script.println("<script>");
			 		script.println("alert('입력이 안 된 사항이 있습니다.')");
			 		script.println("history.back()");
			 		script.println("</script>");		
			 	} else {
			 		ForumDAO forumDAO = new ForumDAO();
			 	 	int result = forumDAO.write(forum.getForumTitle(), userID, forum.getForumContent());
			 	 	if (result == -1) {
			 	 		PrintWriter script = response.getWriter();
			 	 		script.println("<script>");
			 	 		script.println("alert('글쓰기에 실패했습니다.')");
			 	 		script.println("history.back()");
			 	 		script.println("</script>");
			 	 	}
			 	 	else {
			 	 		PrintWriter script = response.getWriter();
			 	 		script.println("<script>");
			 	 		script.println("location.href = 'board.jsp'");
			 	 		script.println("</script>");
			 	 	}
			 	}
	}
 	
 %>
</body>
</html>