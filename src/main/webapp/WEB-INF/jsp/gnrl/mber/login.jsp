<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<script type="text/javascript">
	function login(){
		frmLogin.action="<c:url value='/member/loginAction/'/>";
		frmLogin.submit();
	}

	<c:choose>
		<c:when test="${result eq 'fail'}">
			alert("ID/PW가 정확하지 않습니다.");
		</c:when>
		<c:when test="${result eq 'need'}">
			alert("로그인해야 사용할 수 있습니다.");
		</c:when>
		<c:otherwise></c:otherwise>
	</c:choose>
</script>
<div align="center">
	<table width="400">
	<form name="frmLogin" action="<c:url value='/member/loginAction/'/>">
		<tr>
			<td colspan="2" align="center">현재 접속자수 : ${userCnt}</td>
		</tr>
		<tr>
			<th align="left">아이디</th>
			<td align="left"><input type="text" id="txtID" name="txtID"></td>
		</tr>
		<tr>
			<th align="left">비밀번호</th>
			<td align="left"><input type="text" id="txtPW" name="txtPW"></td>
		</tr>
		<tr>
			<th align="center" colspan="2"><a href="javascript:login();">로그인</a></th>
		</tr>
	</form>

	</table>
</div>