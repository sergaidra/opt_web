<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<script type="text/javascript">

$(function(){	
	$("#faqkeyword").keydown(function (key) {		 
        if(key.keyCode == 13){
        	$("#btnSearch").trigger("click");
        } 
    });
	$("#btnSearch").click(function () {
		$(".faq_list_tab .icon_on").removeClass("icon_on").addClass("icon");		
		$("#liAll").removeClass("icon").addClass("icon_on");
		
		search("");
	});
	
	search("");
});

function search(subcategory) {
	var url = "<c:url value='/cs/getFaqList'/>";
	$("#divList").empty(); 

	var param = {};
	param.subcategory = subcategory;
	param.keyword = $("#faqkeyword").val();
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	for(var cnt = 0; cnt < data.list.length; cnt++) {
        		var categorynm = "";
        		switch(data.list[cnt].SUBCATEGORY) {
        		case "U":
        			categorynm = "회원관련";
        			break;
        		case "G":
        			categorynm = "상품관련";
        			break;
        		}
				var h6 = $("<h6 class=\"acc_trigger\"></h6>");
				var aTag = $("<a href=\"#\"></a>");
				$(aTag).append("<p class=\"no pc_view\">" + (cnt + 1) + "</p>");
				$(aTag).append("<p class=\"cate\">" + categorynm + "</p>");
				$(aTag).append(data.list[cnt].SUBJECT);
				$(h6).append(aTag);
				
				var div1 = $("<div class=\"acc_container\"></div>");
				var div2 = $("<div class=\"block\"></div>");
				$(div2).append(data.list[cnt].CONTENTS);
			   	<c:if test="${author_cl == 'A'}">
    				$(div2).append("<div class=\"btn\" style=\"float:right\"><a href=\"javascript:openFaq(" + data.list[cnt].BBS_SN + ");\" class=\"button_st1 fl mr_m1\">수정</a></div>");
    			</c:if>

				$(div1).append(div2);
        		
				$("#divList").append($(h6));
				$("#divList").append($(div1));
        	}
        	
        	$('.acc_container').hide(); //Hide/close all containers
        	$('.acc_trigger:first').addClass('active').next().show(); //Add "active" class to first trigger, then show/open the immediate next container

        	$('.acc_trigger').click(function(){
        		if( $(this).next().is(':hidden') ) { //If immediate next container is closed...
        			$('.acc_trigger').removeClass('active').next().slideUp(); //Remove all .acc_trigger classes and slide up the immediate next container
        			$(this).toggleClass('active').next().slideDown(); //Add .acc_trigger class to clicked trigger and slide down the immediate next container
        		}
        		return false; //Prevent the browser jump to the link anchor
        	});
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function openFaq(bbs_sn) {
	if(bbs_sn != 0) {
		var url = "<c:url value='/cs/viewFaq'/>";
		
		var param = {};
		param.bbs_sn = bbs_sn;
		
		$.ajax({
	        url : url,
	        type: "post",
	        dataType : "json",
	        async: "true",
	        contentType: "application/json; charset=utf-8",
	        data : JSON.stringify(param ),
	        success : function(data,status,request){
	        	$.featherlight($('#pa_faq'), {});
	        	$(".featherlight #bbs_sn").val(bbs_sn);
	        	$(".featherlight #subcategory").val(data.data.SUBCATEGORY);
	        	$(".featherlight #subject").val(data.data.SUBJECT);
	        	$(".featherlight #contents").val(data.data.CONTENTS);
	        },
	        error : function(request,status,error) {
	        	alert(error);
	        },
		});					
	} else {
		$.featherlight($('#pa_faq'), {});
    	$(".featherlight #bbs_sn").val("");
    	$(".featherlight #subcategory").val("");
    	$(".featherlight #subject").val("");
    	$(".featherlight #contents").val("");
	}
}

function saveFaq() {	
	if($.trim($(".featherlight #subcategory").val()) == "") {
		alert("분류를 선택해주세요.");
		$(".featherlight #subcategory").focus();
		return;
	}
	if($.trim($(".featherlight #subject").val()) == "") {
		alert("질문을 입력해주세요.");
		$(".featherlight #subject").focus();
		return;
	}
	if($.trim($(".featherlight #contents").val()) == "") {
		alert("답변을 입력해주세요.");
		$(".featherlight #contents").focus();
		return;
	}
	
	var url = "<c:url value='/cs/saveFaq'/>";
	
	var param = {};
	param.subcategory = $(".featherlight #subcategory").val();
	param.subject = $(".featherlight #subject").val();
	param.contents = $(".featherlight #contents").val();
	param.bbs_sn = $(".featherlight #bbs_sn").val();
	
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
			if(data.result == "0") {	        	
				alert("등록되었습니다.");
				$.featherlight.close();
				search("");
			} else if(data.result == "-2") {
				alert("로그인이 필요합니다.");
				go_login();
			} else if(data.result == "9") {
				alert(data.message);
			} else{
				alert("작업을 실패하였습니다.");
			}	        	
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});				
}

function changeKind(obj, subcategory) {
	$(".faq_list_tab .icon_on").removeClass("icon_on").addClass("icon");
	
	$(obj).removeClass("icon").addClass("icon_on");
	search(subcategory);
}

</script>

</head>

<body>
	
<!-- 본문 -->
<section>
 <div id="container">
<div class="sp_50 pc_view"></div>
	 <div class="sp_20 mobile_view"></div>
    <div class="inner2">
		<div class="cont_all">
            <!--FAQ검색-->  <div class="bbs_search">
			    <div class="search_text">
			      <div class="tx1"><i class="material-icons">&#xE8FD;</i></div>
				  <div class="tx2">무엇을 도와드릴까요? 고객님의 궁금함을 빠르게 해결해 드리겠습니다. </div>
			    </div>
        <div class="search_in">
          <div class="search_input  search_input_w">
            <input type="text" class="w_100p" id="faqkeyword" name="faqkeyword">
            <div class="btn pointer" id="btnSearch"><i class="material-icons">&#xE8B6;</i></div>
          </div>
        </div>
      </div>
			    
      <!--//FAQ검색-->
       
	<!--faq 아이콘 탭 -->
      <div class="faq_list_tab">
        <div class="icon_bar">
        <ul> 
			<li class="icon_on" onclick="changeKind(this, '');" style="cursor:pointer;" id="liAll">
				<p class="img"><i class="material-icons">&#xE39D;</i></p>
				<p class="text"><a href="javascript:changeKind(this, '');">전체</a></p>
			</li>
			<li class="line"></li>
			<li class="icon" onclick="changeKind(this, 'U');" style="cursor:pointer;">
				<p class="img"><i class="material-icons">&#xE85E;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'U');">회원관련</a></p>
			</li>
			<li class="line"></li>
			<li class="icon" onclick="changeKind(this, 'G');" style="cursor:pointer;">
				<p class="img"><i class="material-icons">&#xE8B1;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'G');">상품관련</a></p>
			</li>
			<li class="line"></li>
			<li class="icon">
				<p class="img"><i class="material-icons">&#xE870;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'P');">결제관련</a></p>
			</li>
			<li class="line"></li>
			<li class="icon">			
				<p class="img"><i class="material-icons">&#xE863;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'C');">반품/취소</a></p>
			</li>
			<li class="line"></li>
			<li class="icon">
				<p class="img"><i class="material-icons">&#xE558;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'O');">주문/배송</a></p>
			</li>
			<li class="line"></li>
			<li class="icon">
				<p class="img"><i class="material-icons">&#xE8D1;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'W');">업무제휴</a></p>
			</li>
			<li class="line"></li>
			<li class="icon">
				<p class="img"><i class="material-icons">&#xE0C6;</i></p>
				<p class="text"><a href="javascript:changeKind(this, 'X');">기타</a></p>
			</li>
		</ul>
      </div>
      </div>
	<!--//faq 아이콘 탭 -->

	<!--faq 리스트 --> 
	<div class="list_box">
		<div class="tb_03_box">
			<table width="100%" class="tb_03  pc_view">
				<col width="50px;" />
				<col width="55px" />
				<col width="80px" />
				<col width="" />
				<thead>
					<tr>
						<th>&nbsp;</th>
						<th>번호</th>
						<th>구분</th>
						<th>제목</th>
					</tr>
				</thead>
			</table>
		</div>
		<div class="faq_container" id="divList">
		</div>
	</div> 
	<!--/faq 리스트 --> 
	
   	<c:if test="${author_cl == 'A'}">
	<div class="right_btn" style="margin-top:20px;"><a href="javascript:openFaq(0);" class="button_m1">작성하기</a> </div>
	</c:if>
	
</div></div>   
<div class="sp_50 pc_view"></div>
<div class="sp_20 mobile_view"></div>

</div>
   
</section>
<!-- //본문 -->

<!--팝업 : FAQ 작성 -->
<div class="lightbox" id="pa_faq">
  <div class="popup_com">
    <div class="title">FAQ 작성하기</div>
    <input type="hidden" name="bbs_sn" id="bbs_sn" />
    <div class="popup_cont">
      <div class="tb_01_box">
        <table width="100%"  class="tb_01">
          <col width="20%">
          <col width="">
          <tbody>
            <tr>
              <th >분류</th>
				<td>
					<select id="subcategory" style="width:100%;" >
						<option value="U">회원관련</option>
						<option value="G">상품관련</option>
						<option value="P">결제관련</option>
						<option value="C">반품/취소</option>
						<option value="O">주문/배송</option>
						<option value="W">업무제휴</option>
						<option value="X">기타</option>
					</select>
				</td>
            </tr>
            <tr>
              <th >질문</th>
              <td><input type="text" placeholder="" class="w_100p input_st" id="subject" name="subject"></td>
            </tr>
            <tr>
              <th >답변</th>
              <td><textarea name="contents" id="contents" class="w_100p input_st"  placeholder="" style="height: 300px"></textarea></td>
            </tr>
          </tbody>
        </table>
      </div>
      <div class="popup_btn"><a href="javascript:saveFaq();">등록하기</a></div>
    </div>
  </div>
</div>
<!--팝업-->

</body>
