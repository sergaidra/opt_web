<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
	<meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=0.1">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<title>원패스투어</title>
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/layout.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/content.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/ay_com.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/btn.css'/>" media="all">	
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/bbs.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/member.css'/>" media="all">
	<link rel="stylesheet" type="text/css" href="<c:url value='/css/mail.css'/>" media="all">
	<link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">

	<script src="<c:url value='/jq/pdf/bluebird.min.js' />" type="text/javascript"></script>
	<script src="<c:url value='/jq/pdf/html2canvas.min.js' />" type="text/javascript"></script>
	<script src="<c:url value='/jq/pdf/jspdf.min.js' />" type="text/javascript"></script>


</head>

<body>
<div id="wrap" class="mail_box">
	<div class="head_box"><img src="<c:url value='/images/mail/mailto_01.jpg'/>" alt=""/>
	<div class="go_ga">가이드용</div>
		<div class="go_btn"><a href="javascript:savePDF();" class="btnst1">저장하기</a><!-- <a href="javascript:window.print();" class="btnst2">인쇄하기</a> --></div>
	</div>
	<div class="tb_box ">
		<div class="oder_guide "><em>대표 여행자</em> : ${purchs.TOURIST_NM}&nbsp;&nbsp;&nbsp;&nbsp;<em>연락처 </em>: ${purchs.TOURIST_CTTPC}&nbsp;&nbsp;&nbsp;&nbsp;<em>kakao ID</em> : ${purchs.KAKAO_ID}  </div>
		<c:forEach var="flight" items="${lstFlight}">
			<div class="tb_01_box">
				<table class="tb_01">
					<col width="20%">
					<col width="">
					<tbody>
					<tr>
						<td rowspan="2">출국</td>
						<td class="left">${flight.DTRMC_START_ARPRT_NM} &rarr; ${flight.DTRMC_ARVL_ARPRT_NM} (항공편명:${flight.DTRMC_FLIGHT})</td>
					</tr>
					<tr>
						<td class="left">[출발] ${flight.DTRMC_START_DT} [도착] ${flight.DTRMC_ARVL_DT}<br></td>
					</tr>
					<tr>
						<td rowspan="2">입국</td>
						<td class="left">${flight.HMCMG_START_ARPRT_NM} &rarr; ${flight.HMCMG_ARVL_ARPRT_NM} (항공편명:${flight.HMCMG_FLIGHT})</td>
					</tr>
					<tr>
						<td class="left">[출발] ${flight.HMCMG_START_DT} [도착] ${flight.HMCMG_ARVL_DT}<br></td>
					</tr>
					</tbody>
				</table>
			</div>
			<div class="sp_box1" style="width:900px;"></div>
		</c:forEach>
		<div class="tb_01_box">
			<table class="tb_01">
				<col width="15%">
				<col width="15%">
				<col width="">
				<tbody>
				<c:forEach var="item" items="${lstReservation}" varStatus="status1">
					<c:forEach var="list" items="${item.list}" varStatus="status2">
						<tr>
						<c:if test="${status2.index == 0}">
							<c:if test="${list.chckt_de eq ''}">
								<td rowspan='${fn:length(item.list)}'>${item.day}</td>
								<c:set var="isTime" value="1"/>
							</c:if>
							<c:if test="${list.chckt_de ne ''}">
								<td rowspan='${fn:length(item.list)}' colspan="2">${item.day} ~ ${list.chckt_de}</td>
								<c:set var="isTime" value="0"/>
							</c:if>
						</c:if>
						<c:if test="${isTime eq '1'}">
							<td>${list.time}</td>
						</c:if>
						<td align="left">${list.text}</td>
						<td align="left">${list.options}</td>
						</tr>
					</c:forEach>
				</c:forEach>
				</tbody>
			</table>
		</div>
	</div>

	<c:forEach var="item" items="${lstReservation}" varStatus="status1">
	<c:forEach var="list" items="${item.list}" varStatus="status2">
	<div class="info_box">
		<div class="title">
			<i class="material-icons">&#xE147;</i>
			<div class="tx">
				<em>여행일자 : </em>
				<c:if test="${list.chckt_de ne ''}">
					${item.day} ~ ${list.chckt_de}
				</c:if>  
				<c:if test="${list.chckt_de eq ''}">
					${item.day} ${list.time}
				</c:if>  
			</div>
		</div>
		<div class="sp_box1" style="width:900px;"></div>
		<div class="title">
			<i class="material-icons">&#xE147;</i>  <div class="tx" ><em>${list.text} : </em> <c:out value="${fn:replace(list.options, '<br/>', ', ')}"/></div>
		</div>
		<c:if test="${list.purchs.PICKUP_PLACE != null }">
			<div class="incont">
				<div class="stitle">픽업장소 : ${list.purchs.PICKUP_PLACE}</div> 
			</div>
		</c:if>		
		<c:if test="${list.purchs.DROP_PLACE != null }">
			<div class="incont">
				<div class="stitle">드랍장소 : ${list.purchs.DROP_PLACE}</div> 
			</div>
		</c:if>		
		<c:if test="${list.purchs.USE_NMPR != null }">
			<div class="incont">
				<div class="stitle">이용인원 : ${list.purchs.USE_NMPR}</div> 
			</div>
		</c:if>
		<c:if test="${list.purchs.USE_PD != null }">
			<div class="incont">
				<div class="stitle">이용기간 : ${list.purchs.USE_PD}</div> 
			</div>
		</c:if>		
	</div>
	
	<c:if test="${!(status1.last and status2.last)}">
		<div class="line"></div>
	</c:if>
	
	</c:forEach>
	</c:forEach>	
	
  <div class="mail_bottom">
  <div class="inbox">
    <div class="tx1">${purchs.CURR_DT}</div>
	    <div class="tx2">가이드 : <br>
확인자 : </div>
  </div>	
 
</div>
<div id="blankImageBottom" style="width:900px; height:50px; margin: 0 auto; box-sizing: border-box; background:white; border-top:10px solid #ff6600;">
</div>
<div id="blankImageTop" style="width:900px; height:50px; margin: 0 auto; box-sizing: border-box; background:white; border-bottom:10px solid #ff6600;">
</div>
<!-- //본문 -->
<script>
var blankImageBottom = null;
var blankImageTop = null;
var blankWidth = null;
var blankHeight = null;
html2canvas(document.getElementById("blankImageBottom"), {
	  onrendered: function(canvas) {
		  blankImageBottom = canvas.toDataURL('image/png');
		  blankWidth = canvas.width;
		  blankHeight = canvas.height;
		  document.getElementById("blankImageBottom").style.display = "none";
	  }
});
html2canvas(document.getElementById("blankImageTop"), {
	  onrendered: function(canvas) {
		  blankImageTop = canvas.toDataURL('image/png');
		  //blankWidth = canvas.width;
		  //blankHeight = canvas.height;
		  document.getElementById("blankImageTop").style.display = "none";
	  }
});

function savePDF() {
	html2canvas(document.getElementById("wrap"), {
		  onrendered: function(canvas) {
				 
			    // 캔버스를 이미지로 변환
			    var imgData = canvas.toDataURL('image/png');
			    var padding = 10;
			     
			    var imgWidth = 210; // 이미지 가로 길이(mm) A4 기준
			    var blankImgWidth = 210;
			    var pageHeight = imgWidth * 1.414;  // 출력 페이지 세로 길이 계산 A4 기준
			    var imgHeight = canvas.height * imgWidth / canvas.width;
			    var blankImgHeight = blankHeight * blankImgWidth / blankWidth;
			    var heightLeft = imgHeight;
			     
			        var doc = new jsPDF('p', 'mm');
			        var position = 0;
			         
			        // 첫 페이지 출력
			        var tmp = heightLeft - (pageHeight - blankImgHeight * 3);
			        if(tmp < 1) { // 1장인 경우
			        	doc.addImage(imgData, 'PNG', padding, padding, imgWidth - (padding * 2), imgHeight);
				        //doc.addImage(blankImageBottom, 'PNG', padding, pageHeight - padding, blankImgWidth - (padding * 2), blankImgHeight);
				        heightLeft -= (pageHeight - blankImgHeight * 3);
			        } else {
			        	doc.addImage(imgData, 'PNG', padding, padding, imgWidth - (padding * 2), imgHeight);
				        doc.addImage(blankImageBottom, 'PNG', padding, pageHeight - padding, blankImgWidth - (padding * 2), blankImgHeight);
				        heightLeft -= (pageHeight - blankImgHeight * 3);
			        }
			         
			        // 한 페이지 이상일 경우 루프 돌면서 출력
			        while (heightLeft >= 0) {
			          position = heightLeft - imgHeight;
			          doc.addPage();
			          doc.addImage(imgData, 'PNG', padding, position, imgWidth - (padding * 2), imgHeight);
			          doc.addImage(blankImageTop, 'PNG', padding, 0, blankImgWidth - (padding * 2), blankImgHeight);
			          heightLeft -= (pageHeight - blankImgHeight * 2);
			          if(heightLeft >= 0) {
				          doc.addImage(blankImageBottom, 'PNG', padding, pageHeight - padding, blankImgWidth - (padding * 2), blankImgHeight);
			          }
			        }
			 
			        // 파일 저장
			        // 결제일자_대표여행자이름_결제번호.pdf
			        doc.save('${purchs.PURCHS_DE}_${purchs.TOURIST_NM}_${purchs.PURCHS_SN}(가이드용).pdf');
		  }
		});	
}
</script>	
</body>
</html>