<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="ui" uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<head>

<link rel="stylesheet" href="/jq/daumeditor/css/editor.css" type="text/css" charset="utf-8"/>
<script src="/jq/daumeditor/js/editor_loader.js" type="text/javascript" charset="utf-8"></script>

<!-- 날짜선택 -->	
<script src="/jq/time/build/jquery.datetimepicker.full.js"></script> 


<script type="text/javascript">

$(function(){
	$.datetimepicker.setLocale('en');

	$('.some_class').datetimepicker( {
		format:'Y-m-d',
		timepicker:false
	});

});

function write() {
	Editor.save(); // 이 함수를 호출하여 글을 등록하면 된다.
}

function validForm(editor) {
	// Place your validation logic here
	if($.trim($("#subject").val()) == "") {
		alert("제목을 입력해주세요.");
		$("#subject").focus();
		return false ;
	}
	// sample : validate that content exists
	var validator = new Trex.Validator();
	var content = editor.getContent();
	if (!validator.exists(content)) {
		alert('내용을 입력하세요');
		return false;
	}

	return true;
}

function setForm(editor) {
    var content = editor.getContent();
    
	var url = "<c:url value='/cs/saveNotice'/>";
	var param = {};
	param.subject = $.trim($("#subject").val());
	param.contents = content;
	param.bbs_sn = $.trim($("#bbs_sn").val());
	if($("#popup_at").is(":checked")) {
		param.popup_at = "Y";
	} else {
		param.popup_at = "N";
	}
	param.startdt = $("#start_dt").val().replace(/[\-]/g, "");
	param.enddt = $("#end_dt").val().replace(/[\-]/g, "");

	console.log(param);
	
	if(!confirm("저장하겠습니까?"))
		return;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("저장되었습니다.");
				go_07_04_01();
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

function modifyNotice() {
	var frm = $("#frmBbs");
	$(frm).attr("action", "/cs/modifyNotice");
	$(frm).submit();
}

function deleteNotice() {
	
	var url = "<c:url value='/bbs/deleteaction'/>";
	var param = {};
	param.bbs_sn = $("#bbs_sn").val();
	console.log(param);
	
	if(!confirm("삭제하겠습니까?"))
		return;
		
	$.ajax({
        url : url,
        type: "post",
        dataType : "json",
        async: "true",
        contentType: "application/json; charset=utf-8",
        data : JSON.stringify( param ),
        success : function(data,status,request){
			if(data.result == "0") {
				alert("삭제되었습니다.");
				go_07_04_01();
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

</script>


</head>

<body>
<form id="frmBbs" method="post">
	<input type="hidden" id="category" name="category" value="${category}">
	<input type="hidden" id="bbs_sn" name="bbs_sn" value="${view.BBS_SN}">
</form>

<!-- 본문 -->
<section>
     
<div id="container">
	   <div class="sp_50"></div>
  <div class="inner2">
  	<div class="order_list">
	   <div class="com_stitle">공지사항</div>
        <div class="review_wr_box">
            <table  class="review_wr">
                <col width="15%" />
                <col width="" />
                <col width="15%" />
                <col width="" />
                <tbody>
				<c:if test="${mode == 'write' or mode == 'modify' }" >
                   <tr>
                    <th>작성자</th>
                    <td>${view.USER_NM }</td>
                    <th>팝업여부</th>
                    <td class="end">
                    	<input type="checkbox" id="popup_at" name="popup_at" <c:if test="${view.POPUP_AT == 'Y' }">checked</c:if>>
                    </td>
                  </tr>
                   <tr>
                    <th>작성일</th>
                    <td>${view.WRITNG_DT }</td>
                    <th>공지기간</th>
                    <td class="end">
                    	<input type="text" class="some_class" value="${view.STARTDT}" id="start_dt"/> ~ <input type="text" class="some_class" value="${view.ENDDT}" id="end_dt"/>
          			</td>
                  </tr>
                  <tr>
                    <th>제목</th>
                    <td colspan="3" class="end">
                    	<input type="text" id="subject" name="subject" class="input_st01" style="width:100%" value="${view.SUBJECT}">
                    </td>
                  </tr>
                  <tr>
                    <th>내용</th>
                    <td colspan="3" class="end">
                    	<c:import url="noticeeditor.jsp"></c:import>
                    </td>
                  </tr>
				</c:if>
				<c:if test="${mode == 'view' }" >
                   <tr>
                    <th>작성자</th>
                    <td>${view.USER_NM }</td>
                    <th>작성일</th>
                    <td class="end">${view.WRITNG_DT }</td>
                  </tr>
                  <tr>
                    <th>제목</th>
                    <td>
                    	${view.SUBJECT }
                    </td>
                    <th>조회수</th>
                    <td class="end">
                    	${view.VIEWCNT } 
                    </td>
                  </tr>
                  <tr>
                    <th>내용</th>
                    <td colspan="3" class="end">
                    	${view.CONTENTS }
                    </td>
                  </tr>
				</c:if>
                </tbody>                	
              </table>
		</div>
        
         <!--하단버튼/ 페이징 -->
         
         <div class="bbs_bottom">
 			<c:if test="${mode == 'view' and view.WRITNG_ID == esntl_id }" >
                  <div class="left_btn">
                  	<a href="javascript:modifyNotice();" class="button_m2 mr_m1">수정</a>
                  	<a href="javascript:deleteNotice();" class="button_m2">삭제 </a>
                  </div>
            </c:if> 
			       <div class="right_btn"> 
					<c:if test="${mode == 'write' }" >
                  		<a href="javascript:write();" class="button_m1 mr_2">저장</a>
                  	</c:if>
					<c:if test="${mode == 'modify' }" >
                  		<a href="javascript:write();" class="button_m1 mr_2">수정</a>
                  	</c:if>
                  	<a href="javascript:go_07_04_01();" class="button_m2">목록</a> 
			       	</div>
       
      </div>
   
      <!--//하단버튼/ 페이징 -->
      </div></div>
	   <div class="sp_50"></div>
</div>

<!-- Sample: Loading Contents -->
<textarea id="sample_contents_source" style="display:none;">
${view.CONTENTS }
</textarea>     

</section>
<!-- //본문 -->

<script type="text/javascript">
	var config = {
		txHost: '', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) http://xxx.xxx.com */
		txPath: '/jq/daumeditor/', /* 런타임 시 리소스들을 로딩할 때 필요한 부분으로, 경로가 변경되면 이 부분 수정이 필요. ex) /xxx/xxx/ */
		txService: 'sample', /* 수정필요없음. */
		txProject: 'sample', /* 수정필요없음. 프로젝트가 여러개일 경우만 수정한다. */
		initializedId: "", /* 대부분의 경우에 빈문자열 */
		wrapper: "tx_trex_container", /* 에디터를 둘러싸고 있는 레이어 이름(에디터 컨테이너) */
		form: 'tx_editor_form'+"", /* 등록하기 위한 Form 이름 */
		txIconPath: "/jq/daumeditor/images/icon/editor/", /*에디터에 사용되는 이미지 디렉터리, 필요에 따라 수정한다. */
		txDecoPath: "/jq/daumeditor/images/deco/contents/", /*본문에 사용되는 이미지 디렉터리, 서비스에서 사용할 때는 완성된 컨텐츠로 배포되기 위해 절대경로로 수정한다. */
		canvas: {
            exitEditor:{
                /*
                desc:'빠져 나오시려면 shift+b를 누르세요.',
                hotKey: {
                    shiftKey:true,
                    keyCode:66
                },
                nextElement: document.getElementsByTagName('button')[0]
                */
            },
			styles: {
				color: "#123456", /* 기본 글자색 */
				fontFamily: "굴림", /* 기본 글자체 */
				fontSize: "10pt", /* 기본 글자크기 */
				backgroundColor: "#fff", /*기본 배경색 */
				lineHeight: "1.5", /*기본 줄간격 */
				padding: "8px" /* 위지윅 영역의 여백 */
			},
			showGuideArea: false
		},
		events: {
			preventUnload: false
		},
		sidebar: {
			attachbox: {
				show: true,
				confirmForDeleteAll: true
			}
		},
		size: {
			//contentWidth: 700 /* 지정된 본문영역의 넓이가 있을 경우에 설정 */
		}
	};

	EditorJSLoader.ready(function(Editor) {
		var editor = new Editor(config);
	});

	/* 저장된 컨텐츠를 불러오기 위한 함수 호출 */
	Editor.modify({
		"content": document.getElementById("sample_contents_source") /* 내용 문자열, 주어진 필드(textarea) 엘리먼트 */
	});

</script>
</body>
