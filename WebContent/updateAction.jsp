<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 <%@ page import="bbs.BbsDAO" %>   
 <%@ page import="bbs.Bbs" %>   
 <%@ page import="java.io.PrintWriter" %>   
 <%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@ page import="com.oreilly.servlet.MultipartRequest"%>
 <%
    	request.setCharacterEncoding("UTF-8");
    %>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset="UTF-8">
<title>JSP로 만든 게시판 웹사이트</title>
</head>
<body>
 <%
 	String userID = null;
 	if (session.getAttribute("userID") !=null) {
 	 	userID = (String) session.getAttribute("userID");
 	}
 	int boardID = 0;
	if (request.getParameter("boardID") != null){
		boardID = Integer.parseInt(request.getParameter("boardID"));
	}
 	if (userID == null) {
 		PrintWriter script = response.getWriter();
 		script.println("<script>");
 		script.println("alert('로그인을 하세요.')");
 		script.println("location.href = 'login.jsp'");
 		script.println("</script>");
 	}
 	// 글이 유효한지 판별함
 	int bbsID = 0;
	if (request.getParameter("bbsID") != null) {
		bbsID = Integer.parseInt(request.getParameter("bbsID"));
	}
	if (bbsID == 0) {
		PrintWriter script = response.getWriter();
 		script.println("<script>");
 		script.println("alert('유효하지 않은 글입니다.')");
 		script.println("location.href = 'bbs.jsp'");
 		script.println("</script>");
	}
	Bbs bbs = new BbsDAO().getBbs(bbsID);
	String realFolder="";
	String saveFolder = "bbsUpload";
	String encType = "utf-8";
	String map="";
	int maxSize=5*1024*1024;
	
	ServletContext context = this.getServletContext();
	realFolder = context.getRealPath(saveFolder);
	
	MultipartRequest multi = null;
	
	multi = new MultipartRequest(request,realFolder,maxSize,encType,new DefaultFileRenamePolicy());		
	String fileName = multi.getFilesystemName("fileName");
	String bbsTitle = multi.getParameter("bbsTitle");
	String bbsContent = multi.getParameter("bbsContent");
	bbs.setBbsTitle(bbsTitle);
	bbs.setBbsContent(bbsContent);
	
	if (!userID.equals(bbs.getUserID())) {
		PrintWriter script = response.getWriter();
 		script.println("<script>");
 		script.println("alert('권한이 없습니다.')");
 		script.println("location.href = 'bbs.jsp'");
 		script.println("</script>");
	} else {
 		if(request.getParameter("bbsTitle") == null || request.getParameter("bbsContent") == null
 			|| request.getParameter("bbsTitle").equals("") || request.getParameter("bbsTitle").equals("")){
 	 		PrintWriter script = response.getWriter();
 	 		script.println("<script>");
 	 		script.println("alert('입력이 안 된 사항이 있습니다.')");
 	 		script.println("history.back()");
 	 		script.println("</script>");		
 	 	} else {
 	 		BbsDAO bbsDAO = new BbsDAO();
 	 	 	int result = bbsDAO.update(bbsID,request.getParameter("bbsTitle"), request.getParameter("bbsContent"));
 	 	 	if (result == -1) {
 	 	 		PrintWriter script = response.getWriter();
 	 	 		script.println("<script>");
 	 	 		script.println("alert('글 수정에 실패했습니다.')");
 	 	 		script.println("history.back()");
 	 	 		script.println("</script>");
 	 	 	}
 	 	 	else {
 	 	 		PrintWriter script = response.getWriter();
 	 	 		if(fileName != null){
					String real = "C:\\JSP2\\apache-tomcat-8.5.57-windows-x64\\apache-tomcat-8.5.57\\webapps\\pratice_make_board\\bbsUpload";
					File delFile = new File(real+"\\"+bbsID+"사진.jpg");
					if(delFile.exists()){
						delFile.delete();
					}
					File oldFile = new File(realFolder+"\\"+fileName);
					File newFile = new File(realFolder+"\\"+bbsID+"사진.jpg");
					oldFile.renameTo(newFile);
				}
 	 	 		
 	 	 		script.println("<script>");
 	 	 		script.println("location.href = 'bbs.jsp'");
 	 	 		script.println("</script>");
 	 	 	}
 	 	}
 	}
 %>
</body>
</html>