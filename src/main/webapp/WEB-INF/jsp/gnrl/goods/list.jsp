<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>

<head>

<style>
/**** pc ****/
@media only all and (min-width:1101px) {
.list_box02 ul li .fr_info .in .origin{ position: absolute; right: 20px; bottom:70px; color: #999; font-size: 15px; font-weight: normal; font-family:'Noto Sans Korean', 'Noto Sans KR'; text-decoration: line-through; }
.list_box02 ul li .fr_info .in .origin em{  font-size: 12px;; color: #999;}
}

@media all and (max-width:1100px) and (min-width:769px) {
.list_box02 ul li .fr_info .in .origin{ position: absolute; right: 20px; bottom:60px; color: #999; font-size: 13px; font-weight: normal; font-family:'Noto Sans Korean', 'Noto Sans KR'; text-decoration: line-through; }
.list_box02 ul li .fr_info .in .origin em{  font-size: 12px;; color: #999;}
}

/**** 모바일 ****/
@media only all and (max-width:768px) {	
.list_box02 ul li .fr_info .in .origin{ position: absolute; right: 10px; bottom: 50px; color: #999; font-size: 13px; font-weight: normal; font-family:'Noto Sans Korean', 'Noto Sans KR'; text-decoration: line-through; }
.list_box02 ul li .fr_info .in .origin em{  font-size: 12px;; color: #999;}
}

</style>
<script type="text/javascript">
$(function(){	
	$(".list_tab li").click(function(){
		if(!$(this).hasClass("on")) {
			$(".list_tab li").removeClass("on");
			$(this).addClass("on");
			var upper_cl_code = $(this).find("#cl_code").val();
			var dc = $(this).find("#dc").val();
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
		        data : JSON.stringify({ "hidUpperClCode" : upper_cl_code, "keyword" : "${keyword}", "category" : "${category}", "date" : "${date}", "mode" : "${mode}" } ),
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
		        	if(dc == "")
		        		$(search).find("span[name='dc']").closest("div").hide();
		        	else
		        		$(search).find("span[name='dc']").text(dc);
					$(search).show();
					
					$("#tabresult").append(search);
										
					$(search).find("#btnSearch").trigger("click");
		        },
		        error : function(request,status,error) {
		        	alertPopup(error, null, null);
		        },
			});			
			
		}
	});
	
	$("#container").on("change", "select", function() {
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
	param.date = "${date}";
	param.mode = "${mode}";

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
				
				if(data.list[cnt].REPRSNT_PRICE != null && data.list[cnt].REPRSNT_PRICE != "") {
					$(item).find(".total").append(data.list[cnt].REPRSNT_PRICE);
					$(item).find(".total_s").hide();
				} else {
					if(data.list[cnt].HOTDEAL_AT == "Y") {
						//$(item).find("span[name='cf_reprsnt_amount']").text(numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT));				
						//$(item).find("span[name='cf_hotdeal_amount']").text(numberWithCommas(Math.round(data.list[cnt].CF_REPRSNT_AMOUNT * data.list[cnt].DSCNT_RATE)));
						//$(item).find(".total_s").append(numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT) + "<spring:message code='goodslist.goodsprice.unit'/>");
						//$(item).find(".total").append(numberWithCommas(Math.round(data.list[cnt].CF_REPRSNT_AMOUNT * data.list[cnt].DSCNT_RATE)) + "<spring:message code='goodslist.goodsprice.unit'/>");
						$(item).find(".total_s").append("￦ " + numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT));
						$(item).find(".total").append("￦ " + numberWithCommas(Math.round(data.list[cnt].CF_REPRSNT_AMOUNT * data.list[cnt].DSCNT_RATE)));
						$(item).find(".total_s").show();
					} else {
						//$(item).find(".total").append(numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT) + "<spring:message code='goodslist.goodsprice.unit'/>");
						$(item).find(".total").append("￦ " + numberWithCommas(data.list[cnt].CF_REPRSNT_AMOUNT));
						$(item).find(".total_s").hide();
					}
				}
              	<c:if test="${pageContext.response.locale.language == 'en'}">
				$(item).find("span[name='cty_nm']").text(nvl(data.list[cnt].CTY_NM_ENG));
				$(item).find("span[name='upper_cl_nm']").text(nvl(data.list[cnt].UPPER_CL_NM_ENG));
				$(item).find("span[name='cl_nm']").text(nvl(data.list[cnt].CL_NM_ENG));
				$(item).find("div[name='goods_nm']").text(nvl(data.list[cnt].GOODS_NM_SUB_ENG));	
				$(item).find("div[name='goods_nm_title']").text(nvl(data.list[cnt].GOODS_NM_ENG));
				</c:if>
              	<c:if test="${pageContext.response.locale.language != 'en'}">
				$(item).find("span[name='cty_nm']").text(nvl(data.list[cnt].CTY_NM));
				$(item).find("span[name='upper_cl_nm']").text(nvl(data.list[cnt].UPPER_CL_NM));
				$(item).find("span[name='cl_nm']").text(nvl(data.list[cnt].CL_NM));
				$(item).find("div[name='goods_nm']").text(nvl(data.list[cnt].GOODS_NM_SUB));		
				$(item).find("div[name='goods_nm_title']").text(nvl(data.list[cnt].GOODS_NM));
				</c:if>
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
        	alertPopup(error, null, null);
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
	var mode = "I";
	if($(obj).hasClass("hit_on")) {
		mode = "D";		
	}
	
	var msg = "";
	if(mode == "I") {
		msg = "<spring:message code='confirm.wish'/>";
	} else {
		msg = "<spring:message code='confirm.wish.cancel'/>";
	}
	confirmPopup(msg
			, function() {
				$.featherlight.close();
				addWishAction(goods_code, obj);
			}, null);
}

function addWishAction(goods_code, obj) {		
	var lst = [];
	lst.push(goods_code);

	var param = {};
	param.goods_code = lst;

	var mode = "I";
	if($(obj).hasClass("hit_on")) {
		mode = "D";		
	}

	var url = "<c:url value='/purchs/insertWish'/>";
	if($(obj).hasClass("hit_on")) {
		url = "<c:url value='/purchs/deleteWish'/>";
		mode = "D";		
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
					alertPopup("<spring:message code='info.wish'/>", null, null);
					$(obj).removeClass("hit").addClass("hit_on");
				} else {
					alertPopup("<spring:message code='info.wish.cancel'/>", null, null);
					$(obj).removeClass("hit_on").addClass("hit");
				}
			} else if(data.result == "-2") {
				alertPopup("<spring:message code='info.login'/>"
						, function() {
							$.featherlight.close();
							go_login();
						}, null);
			} else if(data.result == "9") {
				alertPopup(data.message, null, null);
			} else{
				alertPopup("<spring:message code='info.ajax.fail'/>", null, null);
			}	        	
        },
        error : function(request,status,error) {
        	alertPopup(error, null, null);
        },
	});			
}

function numberWithCommas(x) {
	if(x == null)
		return "";
	else
    	return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}


</script>
</head>

<body>

<form id="frmList" name="frmList" action="<c:url value='/goods/detail'/>">
	<input type="hidden" id="hidGoodsCode" name="hidGoodsCode">
	<input type="hidden" id="category" name="category" value="${category}">
	<input type="hidden" id="date" name="date" value="${date}">
	<input type="hidden" id="mode" name="mode" value="${mode}">
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
           	<c:if test="${pageContext.response.locale.language == 'en'}">
		   		<li>${result.CL_NM_ENG}<input type="hidden" id="cl_code" name="cl_code" value="${result.CL_CODE}"><input type="hidden" id="dc" name="dc" value="${result.DC_ENG}"></li>
		   	</c:if>
           	<c:if test="${pageContext.response.locale.language != 'en'}">
		   		<li>${result.CL_NM}<input type="hidden" id="cl_code" name="cl_code" value="${result.CL_CODE}"><input type="hidden" id="dc" name="dc" value="${result.DC}"></li>
		   	</c:if>
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
		<input type="hidden" name="hidDate" value="">
		<input type="hidden" name="hidMode" value="">
	    <div class="list_search" style="color:#ff9600; padding-top:5px; padding-bottom:5px; margin-bottom:0px; font-weight:bold;">
	    	<span name="dc"></span>
	    </div>
	    <div class="list_search">
	      <div class="info_text" style="display:none;"><spring:message code='goodslist.goodscount.msg' arguments="<span name='totalcount'> </span>"/></div>
		  <div class="inputbox">
		    <div class="search_input">
		    	<input name="sboxKeyword" id="sboxKeyword" type="text" value="${keyword}">
		      <div id="btnSearch" class="btn" ><i class="material-icons">&#xE8B6;</i></div>
		    </div>
		    <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxClCode" id="sboxClCode"  class="w_100p">
						<option value=""><spring:message code='goodslist.search.detail'/></option>
					</select>
				
	<!--//기본 셀렉트 박스 --></div>
			   <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxCtyCode" id="sboxCtyCode" class="w_100p">
						<option value=""><spring:message code='goodslist.search.city'/></option>
				</select>
				
	<!--//기본 셀렉트 박스 --></div>
			   <div class="search_select"><!--기본 셀렉트 박스 .w_100p는 사이즈-->
					<select name="sboxSortOrd" id="sboxSortOrd" class="w_100p">
						<option value=""><spring:message code='goodslist.search.sort'/></option>
						<option value="L"><spring:message code='goodslist.search.sort.asc'/></option>
						<option value="H"><spring:message code='goodslist.search.sort.desc'/></option>
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
				<a href="javascript:nextSearch();"> <div class="ok_btn"><spring:message code='goodslist.more'/></div></a>
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
		    <div class="tx1" name="goods_nm"></div>
			   <div class="tx2" name="goods_nm_title"></span></div>
			   <div id="divHit" class="hit" style="z-index:999;" ><i class="material-icons">favorite</i>

				   </div>
			    <div class="total_s"></div>
			    <div class="total"></div>
		  </div>
			<div class="ar_text"><span name="cty_nm"></span>  >  <span name="upper_cl_nm"></span>  >  <span name="cl_nm"></span></div>
        </div>
    </li>
	<!-- 아이템 끝 -->
        
</body>