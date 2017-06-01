<%@ page language="java" contentType="application/vnd.ms-excel;charset=utf-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%
	response.setHeader("Content-Disposition", "attachment; filename=excelCreate.xls");
	response.setHeader("Content-Description", "JSP Generated Data");
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>excel</title>
<style>
td {mso-number-format:"@"}
</style>
</head>
<body>
	<c:forEach items="${excel}" varStatus="status" var="excel">
		<table border="1" style="table-layout: fixed; width: 100%;">
			<thead>
				<tr>
					<th colspan="${fn:length(excel.label)>0?fn:length(excel.label)+1:1}" style="background-color:; height:40px; font-weight:bold; font-size:25px;">
						${excel.subject}
					</th>
				</tr>
				<tr>
					<th colspan="${fn:length(excel.label)>0?fn:length(excel.label)+1:1}" style="background-color: #e1d7ed; height:10px;">
					</th>
				</tr>
				<c:if test="${fn:length(excel.subLabel)>0}">
					<tr>
						<th style="background-color: #e5f2fc; height:30px;" colspan="1" rowspan="2">번호</th>
						<c:forEach items="${excel.subLabel}" var="subLabel">
							<th colspan="${subLabel.colspan}" style="background-color: #e5f2fc; height:30px;">
								${subLabel.subValue}
							</th>
						</c:forEach>
					</tr>
				</c:if>
				<tr>
					<c:if test="${fn:length(excel.subLabel)==0}">
						<th style="background-color: #e5f2fc; height:30px;" colspan="1" rowspan="1">번호</th>
					</c:if>				
					<c:forEach items="${excel.label}" var="label">						
						<th style="background-color: #e5f2fc; height:30px;">${label.label}</th>
					</c:forEach>
				</tr>
			</thead>
			<tbody>
				<c:forEach items="${excel.data}" varStatus="status" var="row">
					<tr>
						<td>${status.count}</td>
						<c:forEach items="${excel.label}" var="keyMap">							
							<td>${row[keyMap.keyValue]}</td>
						</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
			<tfoot>
				<c:if test="${fn:length(excel.foot)>0}">
					<tr>
						<th style="background-color: #e5f2fc;"></th>
						<c:forEach items="${excel.foot}" var="foot">
							<th style="background-color: #e5f2fc;" colspan="${foot[1]}">${foot[0]}</th>
						</c:forEach>
					</tr>
				</c:if>
			</tfoot>
		</table>
		<br>
	</c:forEach>
</body>
</html>