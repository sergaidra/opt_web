//var sUrl = "http://10.14.4.42:8983/solr/";
//var sUrl = "http://10.17.52.197:8983/solr/";
var sUrl = "http://localhost:8983/solr/";

var pageCnt = 0;	// 전체 페이지 수
var pageSize = 0;	// 한페이지 출력될 갯수
var cnt = 0;	
var startPage = 0;	// 시작 페이지
var endPage = 0;	// 
var lastPage = 0;	// 마지막 페이지

// 사건정보 페이징
var info_pageCnt = 0;	
var info_pageSize = 0;	
var info_cnt = 0;	
var info_startPage = 0;	
var info_endPage = 0;	
var info_lastPage = 0;	

//보고서 페이징
var report_pageCnt = 0;	
var report_pageSize = 0;	
var report_cnt = 0;	
var report_startPage = 0;	
var report_endPage = 0;	
var report_lastPage = 0;	

//이미지 페이징
var image_pageCnt = 0;	
var image_pageSize = 0;	
var image_cnt = 0;	
var image_startPage = 0;	
var image_endPage = 0;	
var image_lastPage = 0;

//동영상 페이징
var video_pageCnt = 0;	
var video_pageSize = 0;	
var video_cnt = 0;	
var video_startPage = 0;	
var video_endPage = 0;	
var video_lastPage = 0;

//오디오 페이징
var audio_pageCnt = 0;	
var audio_pageSize = 0;	
var audio_cnt = 0;	
var audio_startPage = 0;	
var audio_endPage = 0;	
var audio_lastPage = 0;

//문서 페이징
var doc_pageCnt = 0;	
var doc_pageSize = 0;	
var doc_cnt = 0;	
var doc_startPage = 0;	
var doc_endPage = 0;	
var doc_lastPage = 0;


/* 통합검색 전체 조회 */
function solrSearchAll(_pageNo, _indexNo, _txt){
	var txt = _txt;
	
	if (txt != "") {
		
		//20170406 - shkim
		//solrSearchInfo(sUrl, txt, "info", 1, 0, "first");		// 사건정보
		//solrSearchReport(sUrl, txt, "report", 1, 0, "first");	// 보고서
		//solrSearchImage(sUrl, txt, "image", 1, 0, "first");		// 이미지
		solrSearchVideo(sUrl, txt, "video", 1, 0, "first");		// 동영상
		//solrSearchAudio(sUrl, txt, "audio", 1, 0, "first");		// 오디오
		//solrSearchDoc(sUrl, txt, "doc", 1, 0, "first");			// 문서
	}
	
	$("#solrTxt").val(txt);
	$("#solrTxtOld").val(txt);	

}

/* 조회 callback */
function callbackfn(){
	
}


/* 사건정보 조회 */
function solrSearchInfo(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_info/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "RECEIPTNO";
	var column = new Array("COP_NM", "CRIMENAME", "CRIMEOUTLINE");
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post;
	
	getInfoAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
		
}

/* 보고서정보 조회 */
function solrSearchReport(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_report/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "FILE_ID";
	var column = new Array("FILE_NM", "FILE_CN");
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post;
	
	getReportAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
		
}

/* 이미지증거물 조회 */
function solrSearchImage(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_image/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "FILE_ID";
	var column = new Array("FILE_NM", "FILE_CN");
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post;
	
	getImageAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
	
}


/* 동영상증거물 조회 */
function solrSearchVideo(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_video/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "FILE_ID";
	var column = new Array("FILE_NM", "FILE_CN");

	/* 20170406 - shkim
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	*/

	for ( var c in column) {
		hl_fl += column[c] + " ";
	}

	q = encodeURIComponent(txt);
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post+"&sort=score+desc";
	
	getVideoAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
	
}

/* 오디오 증거물 조회 */
function solrSearchAudio(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_audio/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "FILE_ID";
	var column = new Array("CRIMENAME", "FILE_NM", "FILE_CN");
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post;
	
	getAudioAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
	
}

/* 문서증거물 조회 */
function solrSearchDoc(url, txt, flag, pageNo, indexNo, pageFlag){
	
	$.support.cors = true;

	var url2 = "iems_doc/select";
	var data = "wt=json&json.wrf=callbackfn&indent=true&hl=true";
	var start = (indexNo != undefined)? indexNo : 0 ;
	var rows = 5;
	var hl_pre = "<font color=red>";
	var hl_post = "</font>";
	var q = "";
	var hl_fl = "";
	var key = "FILE_ID";
	var column = new Array("CRIMENAME", "FILE_NM");
	var txtArr = txt.split(" ");
	
	for ( var t in txtArr) {
		for ( var c in column) {
			q += column[c] + ":" + encodeURIComponent(txtArr[t]) + " ";
			hl_fl += column[c] + " ";
		}
	}
	
	data+="&q="+q+"&hl.fl="+hl_fl+"&start="+start+"&rows="+rows+"&hl.simple.pre="+hl_pre+"&hl.simple.post="+hl_post;
	
	getDocAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag);	// 조회결과 html
	
}


/*******************************************************************************
 * param1 url : url
 * param2 url2 : url2
 * param3 rows : 조회결과 항목수
 * param4 data : data
 * param5 key : key
 * param6 column : 인덱스대상
 * param7 flag : 검색결과구분 (info, report, image, video, audio, doc)
 * param8 pageNo : 현재페이지번호
 * param9 pageFlag : 페이징구분 (first, prev, next, last)
********************************************************************************/

/* 사건정보 조회결과 */
function getInfoAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){
	
	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {
							
						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";
						
						// arrKey[0]:RECEIPTNO, arrKey[1]:CASE_ID, arrKey[2]:DEPTCODE, arrKey[3]:DEPTNAME, arrKey[4]:CRIMENAME
						authYn = accessAuthChk(arrKey[0], arrKey[1], arrKey[2]);	// 권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";
						str+="<div onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[0]+"\", \""+arrKey[1]+"\",\""+arrKey[2]+"\",\""+arrKey[4]+"\")'; style='cursor:pointer;' >";
						authYn = (authYn == 'Y')?"공개":"비공개";
						
						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									
									switch (column[c]) {
									
									case "COP_NM":
										columnNm = "현장임장자";
										break;
									case "CRIMENAME":
										columnNm = "사건명";
										break;
									case "CRIMEOUTLINE":
										columnNm = "사건개요";
										break;
									default:
										columnNm = "";
										break;
									}
									
									if(entry[column[c]] != undefined && column[c] != "CRIMEOUTLINE" && column[c] != "CRIMENAME"){	
										if(arrKey[0] != '' ){
											str+="<dl><dt><em><span>- 관청/관서 : "+arrKey[3]+"</span><strong>- 현장임장번호 : "+arrKey[0]+"</strong><span>- "+columnNm+" : "+entry[column[c]]+"</span><span>- 사건공개여부 : "+authYn+" </span></em></dt>";
										}else if(arrKey[1] != '' ){
											str+="<dl><dt><em><span>- 관청/관서 : "+arrKey[3]+"</span><strong>- 현장임장번호 : "+arrKey[1]+"</strong><span>- "+columnNm+" : "+entry[column[c]]+"</span><span>- 사건공개여부 : "+authYn+" </span></em></dt>";
										}	
									}else if(docs_entry[column[c]] != undefined && column[c] != "CRIMEOUTLINE" && column[c] != "CRIMENAME"){
										if(arrKey[0] != '' ){
											str+="<dl><dt><em><span>- 관청/관서 : "+arrKey[3]+"</span><strong>- 현장임장번호 : "+arrKey[0]+"</strong><span>- "+columnNm+" : "+docs_entry[column[c]]+"</span><span>- 사건공개여부 : "+authYn+" </span></em></dt>";
										}else if(arrKey[1] != '' ){
											str+="<dl><dt><em><span>- 관청/관서 : "+arrKey[3]+"</span><strong>- 현장임장번호 : "+arrKey[1]+"</strong><span>- "+columnNm+" : "+docs_entry[column[c]]+"</span><span>- 사건공개여부 : "+authYn+" </span></em></dt>";
										}
									}else if(column[c] != "CRIMEOUTLINE" && column[c] != "CRIMENAME"){
										str+="<dl><dt><em>"+columnNm+" : "+"</em></dt>";
									}
									// 사건명						
									if(column[c] == "CRIMENAME" ){	
											if(entry[column[c]] != undefined){
												str+="<dd>- "+columnNm+" : "+entry[column[c]]+"<br>";
											}else if(docs_entry[column[c]] != undefined){
												str+="<dd>- "+columnNm+" : "+docs_entry[column[c]]+"<br>";
											}else{
												str+="<dd>- "+columnNm+" : "+"<br>";
											}
									}
									// 사건개요
									if(column[c] == "CRIMEOUTLINE"){
											if(entry[column[c]] != undefined){
												str+= "- "+ columnNm+" : "+entry[column[c]]+"</dd>";
											}else if(docs_entry[column[c]] != undefined){
												str+= "- "+ columnNm+" : "+docs_entry[column[c]]+"</dd>";
											}else{
												str+= "- "+ columnNm+" : "+"</dd>";
											}
										if(arrKey[0] != ''){
											str+="<input type='hidden' id='"+arrKey[0]+"' value='"+authYn+"' /></dl></div>";
										}else if(arrKey[1] != ''){
											str+="<input type='hidden' id='"+arrKey[1]+"' value='"+authYn+"' /></dl></div>";
										}
									}
								}
							});
						});
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작 
			pagingCntInit(info_pageCnt, info_pageSize, info_cnt, info_startPage, info_endPage, info_lastPage);
			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}


/* 보고서 조회결과 */
function getReportAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){
	
	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {
							
						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";
						
						// arrKey[0]:FILEID, arrKey[1]:FILENO, arrKey[2]:RECEIPTNO, arrKey[3]:CASE_ID, arrKey[4]:DEPTCODE
						authYn = accessAuthChk(arrKey[2], arrKey[3], arrKey[4]);	// 권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";
						
						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									
									if(entry[column[c]] != undefined ){
										
										if(column[c] == "FILE_NM"){	
											str+="<li><figure>";
											str+="<p id='rp_"+arrKey[0]+arrKey[1]+"' class='reportP' onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/IEMS/scenefile/imageLoader.do?fileId="+arrKey[0]+"&fileNo="+arrKey[1]+"' /></p>";
											str+="<figcaption><dl><dt><strong>"+entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										if(column[c] == "FILE_CN"){	
											str+="<div id='rd_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+entry[column[c]]+"</span></div></li>";
										}
										
									}else if(docs_entry[column[c]] != undefined){
										
										if(column[c] == "FILE_NM"){
											str+="<li><figure>";
											str+="<p id='rp_"+arrKey[0]+arrKey[1]+"' class='reportP' onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/IEMS/scenefile/imageLoader.do?fileId="+arrKey[0]+"&fileNo="+arrKey[1]+"' /></p>";
											str+="<figcaption><dl><dt><strong>"+docs_entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										
										if(column[c] == "FILE_CN"){
											str+="<div id='rd_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+docs_entry[column[c]]+"</span></div></li>";
										}
									}else{
										//str+="<td>"+columnNm+" : "+"</td>";
										
									}
								}
							});
						});	
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작 
			pagingCntInit(report_pageCnt, report_pageSize, report_cnt, report_startPage, report_endPage, report_lastPage);
			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}


/* 이미지증거물 조회결과 */
function getImageAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){
	
	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {
							
						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";
						
						authYn = accessAuthChk(arrKey[2], arrKey[3], arrKey[4]);	//권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";
						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									
									if(entry[column[c]] != undefined){
										if(column[c] == "FILE_NM"){
											str+="<li><figure>";
											str+="<p id='ip_"+arrKey[0]+arrKey[1]+"' class='imageP' onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/IEMS/scenefile/imageLoader.do?fileId="+arrKey[0]+"&fileNo="+arrKey[1]+"' /></p>";
											str+="<figcaption><dl><dt><strong>"+entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										if(column[c] == "FILE_CN"){
											str+="<div id='id_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+entry[column[c]]+"</span></div></li>";
										}
									}else if(docs_entry[column[c]] != undefined){
										if(column[c] == "FILE_NM"){
											str+="<li><figure>";
											str+="<p id='ip_"+arrKey[0]+arrKey[1]+"' class='imageP' onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/IEMS/scenefile/imageLoader.do?fileId="+arrKey[0]+"&fileNo="+arrKey[1]+"' /></p>";
											str+="<figcaption><dl><dt><strong>"+docs_entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										if(column[c] == "FILE_CN"){
											str+="<div id='id_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+docs_entry[column[c]]+"</span></div></li>";
										}
									}else{

										//alert("aaaa");
										
									}	
								}				
							});							
						});
						
						
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작 
			pagingCntInit(image_pageCnt, image_pageSize, image_cnt, image_startPage, image_endPage, image_lastPage);
			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}


/* 동영상증거물 조회결과 */
function getVideoAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){

	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {

						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";

						authYn = accessAuthChk(arrKey[2], arrKey[3], arrKey[4]);	// 권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";

						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									if(entry[column[c]] != undefined){
										if(column[c] == "FILE_NM"){
											str+="<li><figure>";
											str+="<p id='vp_"+arrKey[0]+arrKey[1]+"' class='videoP' onclick='fnOpen(\""+arrKey[0]+"\", \""+arrKey[1]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/cmm/getThumbnail/?file_id="+arrKey[0]+"&file_no="+arrKey[1]+"&thumb_no=' /></p>";
											str+="<figcaption><dl><dt><strong>"+entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										if(column[c] == "FILE_CN"){
											str+="<div id='vd_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+entry[column[c]]+"</span></div></li>";
										}
									}else if(docs_entry[column[c]] != undefined){
										if(column[c] == "FILE_NM"){
											str+="<li><figure>";
											str+="<p id='vp_"+arrKey[0]+arrKey[1]+"' class='videoP' onclick='fnOpen(\""+arrKey[0]+"\", \""+arrKey[1]+"\")'; style='cursor:pointer;'>";
											str+="<img src='/cmm/getThumbnail/?file_id="+arrKey[0]+"&file_no="+arrKey[1]+"&thumb_no=' /></p>";
											str+="<figcaption><dl><dt><strong>"+docs_entry[column[c]]+"</strong></dt></dl></figcaption></figure>";
										}
										if(column[c] == "FILE_CN"){
											str+="<div id='vd_"+arrKey[0]+arrKey[1]+"' class='balloon'><span id='content'>"+docs_entry[column[c]]+"</span></div></li>";
										}
									}else{
										//str+="<td>"+columnNm+" : "+"</td>";
									}	
								}
							});								
						});
						
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작 
			pagingCntInit(video_pageCnt, video_pageSize, video_cnt, video_startPage, video_endPage, video_lastPage);
			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}


/* 오디오증거물 조회결과 */
function getAudioAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){
	
	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {
							
						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";
						
						authYn = accessAuthChk(arrKey[2], arrKey[3], arrKey[4]);	//권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";
						
						str+="<div onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
						str+="<li><article class='total_search'><div><dl>";
						
						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									switch (column[c]) {
									case "FILE_ID":
										columnNm = "파일번호";
										break;
									case "CRIMENAME":
										columnNm = "사건명";
										break;
									case "FILE_NM":
										columnNm = "파일명";
										break;
									case "FILE_CN":
										columnNm = "파일주석";
										break;
									default:
										columnNm = "";
										break;
									}								
									
									if(entry[column[c]] != undefined && column[c] != "FILE_ID"){
										
										if(column[c] == "CRIMENAME"){
											str+="<dt>"+ columnNm + " : "+entry[column[c]]+"</dt>";
										}else if(column[c] == "FILE_NM"){
											str+="<dd>"+ columnNm + " : "+entry[column[c]]+"</dd>";
										}else{
											str+="<dd>"+ columnNm + " : "+entry[column[c]]+"</dd>";
										}	
									}else if(docs_entry[column[c]] != undefined && column[c] != "FILE_ID"){
								
										if(column[c] == "CRIMENAME"){
											str+="<dt>"+ columnNm + " : "+docs_entry[column[c]]+"</dt>";
										}else if(column[c] == "FILE_NM"){
											str+="<dd>"+ columnNm + " : "+docs_entry[column[c]]+"</dd>";
										}else{
											str+="<dd>"+ columnNm + " : "+docs_entry[column[c]]+"</dd>";
										}
										
									}						
								}
							});
						});
						
						str+="</dl></div></article></li></div>";
						
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작
			pagingCntInit(audio_pageCnt, audio_pageSize, audio_cnt, audio_startPage, audio_endPage, audio_lastPage);
			
			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}

/* 문서증거물 조회결과 */
function getDocAjax(url, url2, rows, data, key, column, flag, pageNo, pageFlag){
	
	var str="";
	var total="";
	
	$.ajax({
		url : url+url2,
		type : "post",
		data: data,
		async : false,
		dataType : "jsonp",
		jsonp : "json.wrf",
		success : function(data) {
			
			$(data).each(function(data_index, data_entry) {	
				$(data_entry["response"]).each(function(response_index, response_entry) {
					
					total=response_entry["numFound"];
					$(response_entry["docs"]).each(function(index, docs_entry) {
							
						var k=docs_entry[key];
						var arrKey = k.split('|'); 
						var columnNm = "";
						var authYn = "";
						
						authYn = accessAuthChk(arrKey[2], arrKey[3], arrKey[4]);	//권한체크
						authYn = (authYn == '\"Y\"')?"Y":"N";
						
						str+="<div onclick='goPage(\""+flag+"\",\""+authYn+"\",\""+arrKey[2]+"\", \""+arrKey[3]+"\",\""+arrKey[4]+"\",\""+arrKey[5]+"\")'; style='cursor:pointer;'>";
						str+="<li><article class='total_search'><div><dl>";
						
						$(data_entry["highlighting"]).each(function(highlighting_index, highlighting_entry) {
							$(highlighting_entry[k]).each(function(index, entry) {
								
								for(var c in column){
									switch (column[c]) {
									case "FILE_ID":
										columnNm = "파일번호";
										break;
									case "CRIMENAME":
										columnNm = "사건명";
										break;
									case "FILE_NM":
										columnNm = "파일명";
										break;

									default:
										columnNm = "";
										break;
									}								
									
									if(entry[column[c]] != undefined && column[c] != "FILE_ID"){
										
										if(column[c] == "CRIMENAME"){
											str+="<dt>"+ columnNm + " : "+entry[column[c]]+"</dt>";
										}else if(column[c] == "FILE_NM"){
											str+="<dd>"+ columnNm + " : "+entry[column[c]]+"</dd>";
										}	
									}else if(docs_entry[column[c]] != undefined && column[c] != "FILE_ID"){
								
										if(column[c] == "CRIMENAME"){
											str+="<dt>"+ columnNm + " : "+docs_entry[column[c]]+"</dt>";
										}else if(column[c] == "FILE_NM"){
											str+="<dd>"+ columnNm + " : "+docs_entry[column[c]]+"</dd>";
										}
										
									}						
								}
							});
						});
						
						str+="</dl></div></article></li></div>";
						
						
					});
				});
			});
			
			$("#"+ flag + "Tbl").html(str);
			$("#firstIndex").val(pageNo * rows);	// 페이징 index
			
			resultDisplay(total, flag);	// 조회결과 영역 display
			
			// 페이징 시작
			pagingCntInit(doc_pageCnt, doc_pageSize, doc_cnt, doc_startPage, doc_endPage, doc_lastPage);

			pagingHtml(pageCnt, pageSize, cnt, startPage, endPage, lastPage, rows, pageNo, total, pageFlag, flag);
			// 페이징 끝 
			
			balloonDisplay();	// 파일주석 display
			
		},
		error:function(request,status,error){
			alert("code:"+request.status+"\n"+"message:"+request.responseText+"\n"+"error:"+error);
		}
	});
	
}


function pagingCntInit(_pageCnt, _pageSize, _cnt, _startPage, _endPage, _lastPage){
	
	pageCnt = _pageCnt;	
	pageSize = _pageSize;	
	cnt = _cnt;	
	startPage = _startPage;	
	endPage = _endPage;	
	lastPage = _lastPage;
	
}

function pagingCntSet(_pageCnt, _pageSize, _cnt, _startPage, _endPage, _lastPage, _flag){
	
	if(_flag == "info"){
		
		info_pageCnt = _pageCnt;	
		info_pageSize = _pageSize;	
		info_cnt = _cnt;	
		info_startPage = _startPage;	
		info_endPage = _endPage;	
		info_lastPage = _lastPage;
		
	}else if(_flag == "report"){
		
		report_pageCnt = _pageCnt;	
		report_pageSize = _pageSize;	
		report_cnt = _cnt;	
		report_startPage = _startPage;	
		report_endPage = _endPage;	
		report_lastPage = _lastPage;
	
	}else if(_flag == "image"){
		
		image_pageCnt = _pageCnt;	
		image_pageSize = _pageSize;	
		image_cnt = _cnt;	
		image_startPage = _startPage;	
		image_endPage = _endPage;	
		image_lastPage = _lastPage;
	
	}else if(_flag == "video"){
		
		video_pageCnt = _pageCnt;	
		video_pageSize = _pageSize;	
		video_cnt = _cnt;	
		video_startPage = _startPage;	
		video_endPage = _endPage;	
		video_lastPage = _lastPage;
	
	}else if(_flag == "audio"){
		
		audio_pageCnt = _pageCnt;	
		audio_pageSize = _pageSize;	
		audio_cnt = _cnt;	
		audio_startPage = _startPage;	
		audio_endPage = _endPage;	
		audio_lastPage = _lastPage;
	
	}else if(_flag == "doc"){
		
		doc_pageCnt = _pageCnt;	
		doc_pageSize = _pageSize;	
		doc_cnt = _cnt;	
		doc_startPage = _startPage;	
		doc_endPage = _endPage;	
		doc_lastPage = _lastPage;
	
	}
	
}


/* 페이징 */
function pagingHtml(_pageCnt, _pageSize, _cnt, _startPage, _endPage, _lastPage, _rows, _pageNo, _total, _pageFlag, _flag){
	
	var strPage="";

	_pageSize = _rows;
	_pageCnt = parseInt(((_total-1)/_rows) +1);	// 총페이지 수
	//_lastPage = ((parseInt((parseInt(_total / _pageSize)+1)/_pageSize)+1)*5)-4;
	_lastPage = Math.ceil(_total / _pageSize)+1;

	// 페이징 갯수 세팅 (_pageSize == _rows)
	if(_pageCnt < _pageSize){	// 총페이지 갯수가 _pageSize 보다 작음  5<5
		_cnt = _pageCnt;
		_startPage = 1;
		_endPage = _pageCnt +1;
	}else{	// 총페이지 갯수가 _pageSize 보다 큼 => 페이지 시작/종료 값 세팅
		
		_cnt = _pageSize * _pageNo;

		if(_pageFlag =='first'){
			_startPage = 1;
			_endPage = _pageSize +1;
		}
		else if(_pageFlag =='prev'){
			_startPage = _pageNo;
			_endPage = _pageNo + _pageSize;
		}
		else if(_pageFlag =='next'){
			_startPage = (_endPage == _pageCnt+1)?_startPage:_pageNo;
			_endPage = ((_pageNo + _pageSize)>_pageCnt)?_pageCnt+1:_pageNo + _pageSize;
			
			if(_startPage == _lastPage && _endPage == _lastPage){
				_startPage = _startPage-_pageSize;
			}
			if(_endPage == _lastPage){
				_startPage = _startPage;
			}
			if(_startPage > _endPage){
				_startPage = _startPage-_pageSize;
			}
		}
		else if(_pageFlag =='last'){
			_startPage = ((parseInt((parseInt(_total / _pageSize)+1)/_pageSize)+1)*5)-4;
			_endPage = _pageCnt+1;
			
			if(_startPage == _lastPage && _endPage == _lastPage){
				_startPage = _startPage-_pageSize;
			}
			if(_startPage > _endPage){
				_startPage = _startPage-_pageSize;
			}
		}else{
			
			if(_pageNo <= _endPage-1){
				_startPage = (_pageNo==1)?1:_startPage;
				
				if(_startPage == _lastPage){
					_endPage = _pageCnt+1;	
				}else if (_endPage < _lastPage){
					_endPage = (_total<_cnt)?_pageCnt+1:_startPage+_pageSize;
				}
				
			}else{
				_startPage = (_pageNo==1)?1:_endPage;
				_endPage = (_total<_cnt)?_pageCnt+1:_startPage+_pageSize;
			}
		}
	}
	
	// 페이징 html
	if(_pageCnt > _pageSize){
		
		strPage+="<a onclick='linkPage(1, \"first\", \""+_flag+"\");' href='#;'><p class='pprev'></p></a>&nbsp;" ;
		
		if(_startPage-_pageSize == 1 || _startPage == 1){
			strPage+="<a onclick='linkPage(1, \"prev\", \""+_flag+"\");' href='#;' ><p class='prev'></p></a>&nbsp;" ;
		}else{
			strPage+="<a onclick='linkPage("+String(_startPage-_pageSize)+", \"prev\", \""+_flag+"\");' href='#;'><p class='prev'></p></a>&nbsp;" ;
		}
			
		for(var i=_startPage; i<_endPage; i++){
			if(i == 1){
				strPage+= "<span><a class='on' onclick='linkPage("+String(i)+", \"\", \""+_flag+"\");' id='"+_flag+"_"+String(i)+"' href='#;' ><p>"+String(i)+"</p></a></span>&nbsp;";
			}else{
				strPage+= "<span><a onclick='linkPage("+String(i)+", \"\", \""+_flag+"\");' id='"+_flag+"_"+String(i)+"' href='#;' ><p>"+String(i)+"</p></a></span>&nbsp;";
			}
		}
		
		if((_pageNo == _pageCnt) || (_endPage == _lastPage)){
			strPage+= "<a onclick='linkPage("+String(_endPage-1)+", \"next\", \""+_flag+"\");' href='#;'><p class='next'></p></a>&nbsp;" ;
		}else{
			strPage+= "<a onclick='linkPage("+String(_endPage)+", \"next\", \""+_flag+"\");' href='#;'><p class='next'></p></a>&nbsp;" ;
		}
		
		strPage+= "<a onclick='linkPage("+_pageCnt+", \"last\", \""+_flag+"\");' href='#;'><p class='nnext'></p></a>&nbsp;";
	}else{	//전체페이지가 5 이하

		for(var i=0; i<_endPage-1; i++){

			if(i+1 == 1){
				strPage+= "<span><a class='on' onclick='linkPage("+String(i+1)+", \"\", \""+_flag+"\");' id='"+_flag+"_"+String(i+1)+"' href='#;' ><p>"+String(i+1)+"</p></a></span>&nbsp;";
			}else{
				strPage+= "<span><a onclick='linkPage("+String(i+1)+", \"\", \""+_flag+"\");' id='"+_flag+"_"+String(i+1)+"' href='#;' ><p>"+String(i+1)+"</p></a></span>&nbsp;";
			}
		}

	}
	
	pagingCntSet(_pageCnt, _pageSize, _cnt, _startPage, _endPage, _lastPage, _flag);

	$("#page_"+_flag).html(strPage);
	$('#page_'+_flag).find('a').removeClass('on'); // 페이징 초기화
	$('#'+_flag+'_'+_pageNo).addClass('on');
	
}



/* 연관검색어 조회 */
function relatedSearch(txt, mFlag){
	/* 20170406 - shkim
	var url = (mFlag == "M")?"search/relatedSearch.do":"relatedSearch.do";	
	var queryString = "txt="+txt;
	var processAfterGet = function(data) {

		var relatedArr = data;
		var strHtml = '';
		var relatedSel = '';
		
		for(var i=0; i<relatedArr.length; i++){
			strHtml+="<li><input type='text' id='relatedSearch_" + i + "' name='relatedSearch' class='input2' onclick='doSelectClick("+i+")' ></li>";	
		}
		strHtml+="<input type='hidden' id='relatedSearchCnt' name='relatedSearchCnt' value='"+relatedArr.length+"'>";	
		
		$("#relatedSearchList").html(strHtml);
		
		for(var i=0; i<relatedArr.length; i++){
			relatedSel = trim(relatedArr[i]);
			$("#relatedSearch_"+i).val(trim(relatedSel));
		}		
	};
	Ajax.getJson(url, queryString, processAfterGet);
*/
}

/* 연관검색어 등록 */
function relatedInsert(txt, txtOld, mFlag){
	/* 20170406 - shkim
	var url = (mFlag == "M")?"search/relatedInsert.do":"relatedInsert.do";	
	var queryString = "txt="+txt+"&txtOld="+txtOld;
	
	var processAfterGet = function(data) {

		//var strHtml = '';
	};
	Ajax.getJson(url, queryString, processAfterGet);
*/
}


/* 연관검색어 영역 숨김 */
function doSelectClick(_id){
	
	$("#solrTxt").val(trim($("#relatedSearch_"+_id).val()));
	$('#relatedSearchList').hide();
}


/* 사건 열람 권한 체크 */
function accessAuthChk(_val1, _val2, _val3){
	
	//alert(_val1 + _val2 + _val3);
	
	/* 20170406 - shkim
	alert(_val1);
	var queryString ="";
	var url = "accessAuthChkAjax.do";	
	var result = "";
	
	if(_val1 != ''){
		queryString = "txt1="+_val1+"&txt2="+_val3;
	}else if(_val2 != ''){
		queryString = "txt1="+_val2+"&txt2="+_val3;
	}
	
	var processAfterGet = function(data) {

		result = JSON.stringify(data);
		
	};
	Ajax.getJson(url, queryString, processAfterGet);
	return result;
	*/
	
	return '\"Y\"';
}


/* 공백/특수문자 제거 */
function trim(str) {
	return str.replace(/^\s*|\s$/g, "");
}


/* 조회결과 display */
function resultDisplay(_total, _flag){
	
	if(_total != 0){
		$("#"+ _flag + "Init").hide();
		$("#"+ _flag + "List").show();
		$("#"+ _flag + "Tbl").show();
		
	}else{
		$("#"+ _flag + "Init").show();
		$("#"+ _flag + "List").hide();
		$("#"+ _flag + "Tbl").hide();
		
	}
}


/*파일주석 말풍선 display*/
function balloonDisplay(){
	
	$('.reportP').mouseover(function(e){
		var selDiv = $(this).attr('id');
		$('#rd_'+selDiv.substring(3)).css({top:$(this).position().top+75, left:$(this).position().left+20, opacity: 0.8}).show();		
	});
		
	$('.reportP').mouseout(function(e){
		var selDiv = $(this).attr('id');
		$('#rd_'+selDiv.substring(3)).hide();
	});
	
	$('.imageP').mouseover(function(e){
		var selDiv = $(this).attr('id');
		$('#id_'+selDiv.substring(3)).css({top:$(this).position().top+75, left:$(this).position().left+20, opacity: 0.8}).show();		
	});
		
	$('.imageP').mouseout(function(e){
		var selDiv = $(this).attr('id');
		$('#id_'+selDiv.substring(3)).hide();
	});
	
	$('.videoP').mouseover(function(e){
		var selDiv = $(this).attr('id');
		$('#vd_'+selDiv.substring(3)).css({top:$(this).position().top+75, left:$(this).position().left+20, opacity: 0.8}).show();		
	});
		
	$('.videoP').mouseout(function(e){
		var selDiv = $(this).attr('id');
		$('#vd_'+selDiv.substring(3)).hide();
	});
}
