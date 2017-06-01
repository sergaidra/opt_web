<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>

<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<!-- <meta http-equiv="X-UA-Compatible" content="IE=9" /> -->
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<meta http-equiv="X-UA-Compatible" content="IE=7" />
<title>이미지 증거물 관리시스템</title> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/base.css'/>" media="all"/> 
<link rel="stylesheet" type="text/css" href="<c:url value='/css/global.css'/>" media="all"/>
<style>
	.blockuiLoading { position:absolute; left:0; top:0; z-index:150; width:100%; height:100%; filter:alpha(opacity=50); opacity:0.5; background-color:#000;}
</style> 
<script type="text/javascript" src="<c:url value='/js/ajax.js'/>" ></script>
<script type="text/javascript" src="<c:url value='/js/jquery-1.11.1.js'/>"></script>
<script type="text/javascript" src="<c:url value='/js/solrFunction.js'/>"></script>

<script type="text/javascript">
	var contextRoot = "${pageContext.request.contextPath}";

	$(document).ready(function() {

		initBtn();

	});

	function initBtn() {

		var txt = $("#solrTxt").val();
		var txtOld = $("#solrTxtOld").val();
		var cPageNo = $('#currentPageNo').val();
		var fIndex = $('#firstIndex').val();
		

		// 메인에서 검색할 경우
		if (txt != '') {
			relatedInsert(txt, txtOld, "S");
			solrSearchAll(cPageNo, fIndex, txt);
			$('#relatedSearchList').hide();
		}

		// 연관검색어 영역 숨김
		$('#solrTxt').bind('click', function() {
			$('#relatedSearchList').hide();
		});
		
	}

	/* 통합검색  */
	function searchClick() {

		var txt = $("#solrTxt").val();
		var txtOld = $("#solrTxtOld").val();
		var cPageNo = $('#currentPageNo').val();
		var fIndex = $('#firstIndex').val();
		
		
		relatedInsert(txt, txtOld, "S");
		$('#relatedSearchList').hide();
		
		if(txt == null || txt == ''){
			alert("검색어를 입력하세요");
			return false;
		}
		
		solrSearchAll(cPageNo, fIndex, txt);		
		
	}
	
	
	/* 연관검색어 조회  */
	function fnInputKeyup(event) {
		
		var txt = $("#solrTxt").val();

		if (event.keyCode != 13) {
			if (txt.length > 0) {
				relatedSearch(txt, "S");
				$('#relatedSearchList').show();
			} else if (txt.length == 0) {
				$('#relatedSearchList').hide();
			}
		}
	}
	
	/* enter event 통합검색  */
	function fnInputEnter(event) {

		if (event.keyCode == 13) {
			searchClick();
		}

		$('#relatedSearchList').hide();
	}

	/* 페이징 */
	function linkPage(pageNo, pageFlag, resultFlag) {

		var firstIndex = (pageNo - 1) * 5; // 조회결과 시작 인덱스 = (pageNo-1)*rows
		var txt = $("#solrTxt").val();
		var sUrl = "http://10.14.4.42:8983/solr/";
		//var sUrl = "http://10.17.52.197:8983/solr/";
		//var sUrl = "http://localhost:8983/solr/";

		if (pageNo != undefined) {
			$('#currentPageNo').val(pageNo);
		}

		if(resultFlag == "info"){
			solrSearchInfo(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}else if(resultFlag == "report"){
			solrSearchReport(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}else if(resultFlag == "image"){
			solrSearchImage(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}else if(resultFlag == "video"){
			solrSearchVideo(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}else if(resultFlag == "audio"){
			solrSearchAudio(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}else if(resultFlag == "doc"){
			solrSearchDoc(sUrl, txt, resultFlag, pageNo, firstIndex, pageFlag);
		}
	}
	
	/* 사건정보/승인요청 페이지 이동 */
	
	function goPage(_flag, _authYn, _param1, _param2, _param3, _param4 ){
			
		// info: receiptNo, caseId, deptCode, deptName, crimeName
		// image ~ doc :fileId, fileNo, receiptNo, caseId, deptCode, crimeName

		saveSearchHist(_param1, _param2, _param3, _param4);	// 검색기록 저장후 상세페이지 이동
		
		var reUrl = "";
		if(_authYn == "N"){	// 비공개 =
			if(_param2 == null || _param2 == ""){
				reUrl = contextRoot + '/approval/requestApprovalFileDown.do?receiptNo='+_param1+'&deptCode='+_param3;
			}else{
				reUrl = contextRoot + '/approval/requestApprovalFileDown.do?caseId='+_param2+'&deptCode='+_param3;
			}
			location.href = reUrl;
			
		}else{	// 공개
			if(_param2 == null || _param2 == ""){
				reUrl = contextRoot + '/scenefile/sceneFileList.do?receiptNo=' + _param1 + '&deptCode=' + _param3 + '&accessAuth='+_authYn+'&flowPath=search';
			}else{
				reUrl = contextRoot + '/scenecase/sceneCaseDetail.do?caseId=' + _param2 + '&flowPath=search';
			}
			location.href = reUrl;
		}
	
	}
	
	
	/* 검색 기록 저장 */
	function saveSearchHist(receiptNo, caseId, deptCode, crimeName){

		var url = contextRoot + "/scenefile/insertSearchHistAjax.do";
		var queryString = "";
		if(caseId == null || caseId == ""){
			queryString = 'receiptNo=' + receiptNo + '&deptCode=' + deptCode + '&crimeName=' + crimeName + '&menuId=' + layout_menuId;
		}else{
			queryString = 'caseId=' + caseId + '&caseNm=' + crimeName + '&menuId=' + layout_menuId;	
		}
		var processAfterGet = function(data) {};
		Ajax.getJson(url, queryString, processAfterGet);		
	}
	
</script>
</head>
<body>
		<article class="maincon2">
		<div class="m_right2">
			<h2><img src="<c:url value='/images/main/txt_title.png'/>" alt="이미지 증거물 통합검색"></h2>
			<div class="search2" >			
				<input type="text" id="solrTxt" name="solrTxt" class="input1" onkeypress="fnInputEnter(event)" onkeyup="fnInputKeyup(event)" value="${searchVO.searchTxt}">
				<input type="hidden" id="solrTxtOld" name="solrTxtOld">
				<button type="button" class="btnBL searchS" onclick="searchClick()"><span><em>검색</em></span></button>
				<ul id="relatedSearchList">
					<!-- 
						<li><input type='text' id='relatedSearch_0' name='relatedSearch' onclick='doSelectClick(0)' >연관검색어1</li>
						<li><input type='text' id='relatedSearch_0' name='relatedSearch' onclick='doSelectClick(0)' >연관검색어1</li>
						-->
				</ul>
			</div><!-- //.search -->
		</div>
		</article>
		<!-- 조회결과 시작.subcon  -->
		<article class="subcon">
			<!-- 동영상증거물 시작  -->
			<section class="board_3">
				<h2 class="serch_title">동영상증거물 검색결과</h2>
				<ul class="search_photo" id="videoTbl" style="display:none"></ul>
				<article class="total_search"  id="videoInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<div class="pagenum_common" id="page_video"></div>
			</section>
 			<!-- //동영상증거물 끝  -->

			<!-- 사건정보 시작  -->
			<section class="board_1">				
				<h2 class="serch_title">사건정보 검색결과</h2>
				<!-- <div id="infoTotal" class="tot"></div> -->
				<article class="total_search"  id="infoTbl" style="display:none" ></article>
				<article class="total_search"  id="infoInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<input type="hidden" id="currentPageNo" name="currentPageNo" value="${searchVO.currentPageNo}" /> 
				<input type="hidden" id="firstIndex" name="firstIndex" value="${searchVO.firstIndex}" /> 
				<input type="hidden" id="lastIndex" name="lastIndex" value="${searchVO.lastIndex}" />

				<div class="total_pagenum_common" id="page_info"></div>
			</section>
			<!-- //사건정보 끝  -->
			<!-- 보고서정보 시작  -->
			<section class="board_1">				
				<h2 class="serch_title">보고서정보 검색결과</h2>
				<ul class="search_photo" id="reportTbl" style="display:none"></ul>
				<article class="total_search"  id="reportInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<div class="total_pagenum_common" id="page_report"></div>
			</section>
			<!-- //보고서정보 끝  -->
			<!-- 이미지증거물 시작  -->
			<section class="board_3">
				<h2 class="serch_title">이미지증거물 검색결과</h2>
				<ul class="search_photo" id="imageTbl" style="display:none"></ul>
				<article class="total_search"  id="imageInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<div class="total_pagenum_common" id="page_image"></div>
			</section><!-- //.board_3 -->
			<!-- //이미지증거물 끝  --> 			
 			<!-- 오디오증거물 시작  -->
			<section class="board_1">				
				<h2 class="serch_title">오디오증거물 검색결과</h2>
				<ul class="search_audio" id="audioTbl" style="display:none"></ul>
				
				<article class="total_search"  id="audioInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<div class="total_pagenum_common" id="page_audio"></div>
			</section>
 			<!-- //오디오증거물 끝  -->
 			<!-- 문서증거물 끝  -->
			<section class="board_1">				
				<h2 class="serch_title">문서증거물 검색결과</h2>
				<!-- <article class="total_search" id="docTbl" style="display:none"></article> -->
				
				<ul class="search_audio" id="docTbl" style="display:none"></ul>
				
				<article class="total_search" id="docInit" >
					<div>
						<dl><p>-- 검색결과 없음 --</p></dl>
					</div>
				</article>
				<div class="total_pagenum_common" id="page_doc"></div>
			</section>
 			<!-- //문서증거물 끝  -->
		</article>
		<!-- //조회결과 끝.subcon  -->
	
</body>
<script type="text/javascript">
	function fnOpen(file_id, file_no) {
		var url = "<c:url value='/cmm/mediaPlayer/'/>?file_id="+file_id+"&file_no="+file_no;
		var name = "";
		var openWindows = window.open(url,name,"width=680,height=600,top=100,left=100,toolbar=no,status=no,location=no,scrollbars=yes,menubar=no,resizable=no");
		if (window.focus) {openWindows.focus()}
	}
</script>
</html>