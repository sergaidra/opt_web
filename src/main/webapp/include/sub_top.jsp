<%@ page contentType="text/html; charset=utf-8" language="java" import="java.sql.*" errorPage="" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>    

<script type="text/javascript">
$(function(){
	$("#txtSubtopKeyword").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#imgSubtopSearch").trigger("click");
        } 
    });
	$("#imgSubtopSearch").click(function () {
		if($.trim($("#txtSubtopKeyword").val()) == "") {
			alert("검색어를 입력하세요.");
			$("#txtSubtopKeyword").focus();
			return;
		}
		
		var frm = $("#frmSubtopSearch");
		frm.attr("action", "<c:url value='/goods/list'/>");
		frm.attr("method", "get");
		frm.find("input[name='keyword']").val($.trim($("#txtSubtopKeyword").val()));
		frm.submit();
	});
});

</script>

<section>
      <div class="subtop${bp}">
    <div class="inner2">
          <div class="b_title">
        <div class="tx1">${btitle}</div>
        <div class="route_t">HOME > ${btitle} > ${mtitle}</div>
      </div>
          <div class="search_box">
        <div class="btn_icon"><img id="imgSubtopSearch" src="<c:url value='/images/com/search_icon.png' />" width="36" height="36" alt=""/></div>
        <input type="text" id="txtSubtopKeyword">
      </div>
          <div class="copy_text">Details package tour is <em>OnePassTour</em></div>
        </div>
  </div>
<form id="frmSubtopSearch" name="frmSubtopSearch">
	<input type="hidden" id="keyword" name="keyword">
</form>  
</section>