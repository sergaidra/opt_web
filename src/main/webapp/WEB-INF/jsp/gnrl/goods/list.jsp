<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<head>

<script type="text/javascript">
$(function(){	
	$(".list_tab li").click(function(){
		if(!$(this).hasClass("on")) {
			$(".list_tab li").removeClass("on");
			$(this).addClass("on");
			var upper_cl_code = $(this).find("#cl_code").val();
			//$("#tabresult").empty();
			$(".panelTab").hide();
			if($("#divPan" + upper_cl_code).length > 0) {
				$("#divPan" + upper_cl_code).show();
				return;				
			}

			var url = "<c:url value='/goods/getClInfo'/>";
			$.ajax({
		        url : url,
		        type: "post",
		        dataType : "json",
		        async: "true",
		        contentType: "application/json; charset=utf-8",
		        data : JSON.stringify({ "hidUpperClCode" : upper_cl_code } ),
		        //data : "hidUpperClCode=00411",
		        success : function(data,status,request){
					var search = $("#pan").clone();
					$(search).attr("id", "divPan" + upper_cl_code);
					
					var html_upper_cl_code = "<input type='hidden' id='upper_cl_code' name='upper_cl_code' value='" + upper_cl_code + "' >";
					$(search).append(html_upper_cl_code);
					
					var html1 = "", html2 = "";
		        	for(var cnt = 0; cnt < data.tourClList.length; cnt++) {
		        		html1 += "<option value='" + data.tourClList[cnt].CL_CODE + "'>#" + data.tourClList[cnt].CL_NM + "</option>";
		        	}
		        	for(var cnt = 0; cnt < data.ctyList.length; cnt++) {
		        		html2 += "<option value='" + data.ctyList[cnt].CTY_CODE + "'>#" + data.ctyList[cnt].CTY_NM + "</option>";
		        	}
		        	
		        	$(search).find("#sboxClCode").append(html1);
		        	$(search).find("#sboxCtyCode").append(html2);
					$(search).show();
					
					$("#tabresult").append(search);
										
					$(search).find("#btnSearch").trigger("click");
		        },
		        error : function(request,status,error) {
		        	alert(error);
		        },
			});			
			
		}
	});
	
	$(document).on("change", "select", function() {
		fnSearch($(this), false);
	});
	
	$(document).on("keydown", "#sboxKeyword", function(key) {
		if(key.keyCode == 13){
			fnSearch($(this), false);
        } 				
	});
	
	
	
	$(document).on("click", "#btnSearch", function() {
		fnSearch($(this), false);
	});

	$("#tabresult").on("click", "li", function() {
		fnDetail($(this));
	});
	//$(search).find("select").change(function () {
	//});

	$(window).scroll(function() {
	   if($(window).scrollTop() + $(window).height() == $(document).height()) {
			var obj = $(".panelTab:visible").find("input:eq(0)");
			fnSearch($(obj), true);
	   }
	   return;
		var scrollHeight = $(document).height();
		var scrollPosition = $(window).height() + $(window).scrollTop();		
		if ((scrollHeight - scrollPosition) / scrollHeight < 0.1) {
		} else {			
		}
	});
	
	if (window.location.hash) {
		var item = window.location.hash.split("_");
		if(item[0] == "#ucc") {
			$(".list_tab li").each(function() {
				if($(this).find("#cl_code").val() == item[1]) {
					$(this).trigger("click");
				}
			});
		} else {
			$(".list_tab li:eq(0)").trigger("click");
		}
	} else {
		$(".list_tab li:eq(0)").trigger("click");
	}
});

function nextSearch() {
	var obj = $(".panelTab:visible").find("input:eq(0)");
	fnSearch($(obj), true);
}

function fnSearch(obj, isNext) {
	var list_search = $(obj).closest(".panelTab");
	var ul = list_search.find("ul");
	var divMore = list_search.find("#divMore");

	if(isNext == true) {
		var totalCount = Number($(list_search).find("input[name='hidTotalcount']").val());
		
		if(totalCount <= ul.find("li").length)
			return;
		
		var hidPage = Number($(list_search).find("input[name='hidPage']").val());
		hidPage++;
		$(list_search).find("input[name='hidPage']").val(hidPage);
	} else {
		var hidClCode = $(list_search).find("#sboxClCode").val();
		var hidCtyCode = $(list_search).find("#sboxCtyCode").val();
		var hidUpperClCode = $(list_search).find("#upper_cl_code").val();
		var hidSortOrd = $(list_search).find("#sboxSortOrd").val();
		var hidKeyword = $(list_search).find("#sboxKeyword").val();
		$(list_search).find("input[name='hidClCode']").val(hidClCode);
		$(list_search).find("input[name='hidCtyCode']").val(hidCtyCode);
		$(list_search).find("input[name='hidUpperClCode']").val(hidUpperClCode);
		$(list_search).find("input[name='hidSortOrd']").val(hidSortOrd);
		$(list_search).find("input[name='hidKeyword']").val(hidKeyword);
		$(list_search).find("input[name='hidTotalcount']").val("-1");
		$(list_search).find("input[name='hidPage']").val("1");

		$(ul).empty();
	}
	
	var param = {};
	param.hidClCode = $(list_search).find("input[name='hidClCode']").val();
	param.hidCtyCode = $(list_search).find("input[name='hidCtyCode']").val();
	param.hidUpperClCode = $(list_search).find("input[name='hidUpperClCode']").val();
	param.hidSortOrd = $(list_search).find("input[name='hidSortOrd']").val();
	param.hidKeyword = $(list_search).find("input[name='hidKeyword']").val();
	param.hidPage = $(list_search).find("input[name='hidPage']").val();
	param.hidNext = (isNext == true ? "Y" : "N");
	param.category = $("#category").val();

	var url = "<c:url value='/goods/getGoodsList'/>";
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify(param ),
        success : function(data,status,request){
        	if(isNext == false) {
            	$(list_search).find("span[name='totalcount']").text(data.totalCount).closest("div").show();
            	$(list_search).find("input[name='hidTotalcount']").val(data.totalCount);
        	}
        	
			for(var cnt = 0; cnt < data.list.length; cnt++) {
				var item = $("#liItem").clone();
				$(item).attr("id", "");
				
				$(item).find("span[name='cty_nm']").text(data.list[cnt].CTY_NM);
				$(item).find("span[name='upper_cl_nm']").text(data.list[cnt].UPPER_CL_NM);
				$(item).find("span[name='cl_nm']").text(data.list[cnt].CL_NM);
				if(data.list[cnt].HOTDEAL_AT == "Y")
					$(item).find("span[name='cf_reprsnt_amount']").text(numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT * data.list[cnt].DSCNT_RATE));
				else
					$(item).find("span[name='cf_reprsnt_amount']").text(numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT));
				$(item).find("span[name='goods_nm']").text(data.list[cnt].GOODS_NM_SUB);		
				$(item).find("span[name='goods_nm_title']").text(data.list[cnt].GOODS_NM);	
				$(item).find("span[name='favorite']").text("favorite_border");
				$(item).find("input[name='goods_code']").val(data.list[cnt].GOODS_CODE);
				$(item).find("div[name='imgFile']").css("background", "url(<c:url value='/file/getImageThumb/'/>?file_code=" + data.list[cnt].FILE_CODE + ")");
				$(item).find("div[name='imgFile']").css("background-size", "cover");
				//$(item).find("span[name='favorite']").text("favorite");	
				
				if(data.list[cnt].BKMK == "Y") {
					$(item).find("#divHit").removeClass("hit").addClass("hit_on");
					$(item).find("#divHit").click(function(e) {
						e.stopPropagation();
						addWish($(this).closest("li").find("input[name='goods_code']").val(), $(this));
					});
				} else {
					$(item).find("#divHit").click(function(e) {
						e.stopPropagation();
						addWish($(this).closest("li").find("input[name='goods_code']").val(), $(this));
					});
				}
				if(data.list[cnt].HOTDEAL_AT == "Y") {
					$(item).find("[name='hoticon']").show();
				}
				if(data.list[cnt].RECOMEND_AT == "Y") {
					$(item).find("[name='recomicon']").show();
				}

				$(item).show();
				ul.append(item);
			}
			
			var totalCount = $(list_search).find("input[name='hidTotalcount']").val();
			if(totalCount <= $(ul).find("li").length) {
				$(divMore).hide();
			} else {
				$(divMore).show();
			}
        },
        error : function(request,status,error) {
        	alert(error);
        },
	});
}

function fnDetail(obj) {
	var upper_cl_code = $(obj).closest(".panelTab").find("[name='hidUpperClCode']").val();
	window.location.hash = '#ucc_' + upper_cl_code;
	var goods_code = $(obj).find("input[name='goods_code']").val();
	var form = $("form[id=frmList]");
	$("input:hidden[id=hidGoodsCode]").val(goods_code);
	form.attr({"method":"get","action":"<c:url value='/goods/detail'/>"});
	form.submit();		
}

function addWish(goods_code, obj) {
	var lst = [];
	lst.push(goods_code);

	var url = "<c:url value='/purchs/insertWish'/>";
	var mode = "I";
	if($(obj).hasClass("hit_on")) {
		url = "<c:url value='/purchs/deleteWish'/>";
		mode = "D";		
	}
	var param = {};
	param.goods_code = lst;
	
	if(mode == "I") {
		if(!confirm("해당 상품을 찜하겠습니까?"))
			return;
	} else {
		if(!confirm("해당 상품의 찜하기를 취소하겠습니까?"))
			return;
	}
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				if(mode == "I") {
					alert("찜하였습니다.");
					$(obj).removeClass("hit").addClass("hit_on");
				} else {
					alert("찜하기를 취소하였습니다.");
					$(obj).removeClass("hit_on").addClass("hit");
				}
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

function numberWithCommas(x) {
    return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


</script>
</head>

<body>

<form id="frmList" name="frmList" action="<c:url value='/goods/detail'/>">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<input type="hidden" id="category" name="category" value="${category}">
</form>

<!-- 본문 -->
<section>
<div id="container">
<div class="sp_50 pc_view"></div>
<div class="sp_20 mobile_view"></div>
 <div class="inner2">
 	<c:if test="${totalsearch == 'N' }">
	   <div class="list_tab">
	   	<ul>
		<c:forEach var="result" items="${upperTourClList}" varStatus="status">
	   		<li>${result.CL_NM}<input type="hidden" id="cl_code" name="cl_code" value="${result.CL_CODE}"></li>
		</c:forEach>
	   	</ul>
	   </div>
 	</c:if>
 	<c:if test="${totalsearch == 'Y' }">
	   <div class="list_tab" style="display:none;">
	   	<ul>
	   		<li><input type="hidden" id="cl_code" name="cl_code" value=""></li>
	   	</ul>
	   </div>
 	</c:if>

	<div id="tabresult" style="min-height:700px;">
	</div>

 </div>
<div class="sp_50 pc_view"></div>
	<div class="sp_20 mobile_view"></div>
</div>
</section>

	<!--패널-->
	<div id="pan" class="panelTab" style="display:none;">
		<input type="hidden" name="hidClCode" value="">
		<input type="hidden" name="hidCtyCode" value="">
		<input type="hidden" name="hidUpperClCode" value="">
		<input type="hidden" name="hidSortOrd" value="">
		<input type="hidden" name="hidKeyword" value="">
		<input type="hidden" name="hidTotalcount" value="">
		<input type="hidden" name="hidPage" value="">
	    <div class="list_search">
	      <div class="info_text" style="display:none;">총 <em><span name="totalcount"> </span>개</em>의 상품이 검색되었습니다.</div>
		  <div class="inputbox">
		    <div class="search_input">
		    	<input name="sboxKeyword" id="sboxKeyword" type="text" value="${keyword}">
		      <div id="btnSearch" class="btn" ><i class="material-icons">&#xE8B6;</i></div>
		    </div>
		    <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxClCode" id="sboxClCode"  class="w_100p">
						<option value="">상세분류</option>
					</select>
				
	<!--//기본 셀렉트 박스 --></div>
			   <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxCtyCode" id="sboxCtyCode" class="w_100p">
						<option value="">도시선택</option>
				</select>
				
	<!--//기본 셀렉트 박스 --></div>
			   <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxSortOrd" id="sboxSortOrd" class="w_100p">
						<option value="">정렬기준</option>
						<option value="L">낮은가격순</option>
						<option value="H">높은가격순</option>
					</select>
				
	<!--//기본 셀렉트 박스 --></div>
	      </div>
	    </div>
	    <div class='list_box02'>
	    	<ul>
	    	</ul>
	    </div>
		<div class="sp_50 pc_view"></div> 
	 	<div class="sp_20 mobile_view"></div>
		<div class="list_more" id="divMore">
			<div class="more_btn">
				<a href="javascript:nextSearch();"> <div class="ok_btn">더보기</div></a>
			</div>
		</div>	    
    </div>
    <!-- 검색 끝 -->
    
    <!-- 아이템 -->
	<li id="liItem" style="display:none; cursor:pointer;">
		<input type="hidden" name="goods_code">
	  <div class="inline"></div>
	  <div class="fl_photo" style="background: url(/images/sub/ex2.png); background-size: cover;" name="imgFile">
	  	  <div style="z-index:99; width:20%;"><img name="hoticon" src="/images/com/hot.png" style="width:100%; display:none;"><img name="recomicon" src="/images/com/recom.png" style="width:100%; display:none;"></div>	  
	  </div>
		<div class="fr_info">
		  <div class="in">
		    <div class="tx1"><span name="goods_nm"></span></div>
			   <div class="tx2"><span name="goods_nm_title"></span></div>
			   <div id="divHit" class="hit" style="z-index:999;" ><i class="material-icons">favorite</i>

				   </div>
			    <div class="total"><span name="cf_reprsnt_amount"></span><em>원</em></div>
		  </div>
			<div class="ar_text"><span name="cty_nm"></span>  >  <span name="upper_cl_nm"></span>  >  <span name="cl_nm"></span></div>
        </div>
    </li>
	<!-- 아이템 끝 -->
        
</body>