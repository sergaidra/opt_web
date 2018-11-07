<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<head>

<script type="text/javascript">
var selectedItem = [];
$(function(){	
	$(".list_box01 li").click(function(){
		if($(this).hasClass("ch")) {
			$(this).removeClass("ch");
			for(var cnt = 0; cnt < selectedItem.length; cnt++) {
				if(selectedItem[cnt] == $(this).find("#cl_code").val())
					selectedItem.splice(cnt, 1);
			}
		} else {
			$(this).addClass("ch");
			selectedItem.push($(this).find("#cl_code").val());
		}
	});
	
});

function btnOk() {
	var form = $("form[id=frmCategory]");
	var cateList = "";
	//$(".list_box01 .ch").each(function() {
	//	cateList += $(this).find("#cl_code").val() + "@";	
	//});

	for(var cnt = 0; cnt < selectedItem.length; cnt++) {
		cateList += selectedItem[cnt] + "@";	
	}

	if(cateList == "") {
		alertPopup("<spring:message code='category.info.msg'/>"
				, function() {
					$.featherlight.close();
				}, null);
		return;
	} else {
		cateList = cateList.substr(0, cateList.length - 1);
		form.find("input:hidden[id=hidUpperClCodeNavi]").val(cateList);
		form.attr({"method":"get","action":"<c:url value='/goods/list'/>"});
		form.submit();	
	}
}
</script>

</head>

<body>

<form id="frmCategory" name="frmCategory" action="<c:url value='/goods/list'/>">
	<input type="hidden" id="hidUpperClCodeNavi" name="hidUpperClCodeNavi">
	<input type="hidden" id="category" name="category" value="${category}">
</form>

<div id="container">
  <div class="sp_50 pc_view"></div>
  <div class="sp_20 mobile_view"></div>
  <div class="inner2">
    <div class="list_title">
      <div class="tx1">Choice!</div>
      <div class="tx2"><spring:message code='category.msg'/></div>
      <div class="select_btn">
       <a href="javascript:btnOk();" id="btnOk"> <div class="ok_btn"><spring:message code='category.btnok'/></div></a>
      </div>
    </div>
    <!---->
    <div class="list_box01">
      <ul>
		<c:forEach var="result" items="${upperTourClList}" varStatus="status">
		<li>
          <div class="inline"></div>
          <div class="photo"><div class="imgbox" style="background: url(<c:url value='/file/getImage/'/>?file_code=${result.FILE_CODE}&file_sn=1)"></div></div>
          <div class="text_box">
           	<c:if test="${pageContext.response.locale.language == 'ja'}">
	            <div class="tx1">${result.DC_ENG}</div>
    	        <div class="tx2">${result.CL_NM_ENG}</div>
           	</c:if>
           	<c:if test="${pageContext.response.locale.language != 'ja'}">
	            <div class="tx1">${result.DC}</div>
    	        <div class="tx2">${result.CL_NM}</div>
           	</c:if>
            <div class="ch_icon"></div>
          </div>
          <input type="hidden" id="cl_code" name="cl_code" value="${result.CL_CODE}" >
		</li>
		</c:forEach>      
      </ul>
    </div>
    <div class="sp_50 pc_view"></div>
    <div class="list_title">
      <div class="select_btn">
       <a href="javascript:btnOk();" id="btnOk2"> <div class="ok_btn"><spring:message code='category.btnok'/></div></a>
      </div>
    </div></div>
  <div class="sp_50 pc_view"></div>
  <div class="sp_20 mobile_view"></div> 
</div>

</body>
