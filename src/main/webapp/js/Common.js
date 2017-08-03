
/**
 * jquery-ui datepicker 한글
 */
$.datepicker.setDefaults({
    dateFormat: 'yy-mm-dd',
    prevText: '이전 달',
    nextText: '다음 달',
    monthNames: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    monthNamesShort: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'],
    dayNames: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesShort: ['일', '월', '화', '수', '목', '금', '토'],
    dayNamesMin: ['일', '월', '화', '수', '목', '금', '토'],
    showMonthAfterYear: true,
    yearSuffix: '년',
    buttonImage: "button.png", 
    buttonImageOnly: true     
});

/*
 * loading indicator show/hide
 */
function showLoading() {
	$.blockUI({
		overlayCSS:{
			backgroundColor:'#ffe',
			opacity: .5
		},
		css:{
			border:'none',
			opacity: .5,
			width:'80px',
			left:'45%'
		},
		message:"<img src='/images/loading_white.gif' width='80px'>"
	});
}

function hideLoading() {
	$.unblockUI();
}

var timerChecker_01 = null;
var timerChecker_02 = null;

/**
 * 타이머 생성 01
 * @param iSecond
 * @param htmlID
 * @param showYn
 * @returns
 * @callback fnTimer_01_callback()
 */
function fnTimer_01(iSecond, htmlID, showYn){
	rMinute = parseInt(iSecond / 60);
	rSecond = iSecond % 60;
	if(iSecond > 0){
		//타이머 표시
		if(showYn=="Y")
			$("#"+htmlID).html(fnLpad(rMinute, 2)+":"+fnLpad(rSecond, 2));   	
		//카운트다운
		iSecond--;
		timerChecker_01 = setTimeout("fnTimer_01('"+iSecond+"','"+htmlID+"','"+showYn+"')", 1000); // 1초 간격으로 체크
	}else{
		//타이머 반복 종료
		clearTimeout(timerChecker_01);
		//타이머 종료 처리 콜백
		fnTimer_01_callback();
	}
}

/**
 * 타이머 생성 02
 * @param iSecond
 * @param htmlID
 * @param showYn
 * @returns
 * @callback fnTimer_02_callback()
 */
function fnTimer_02(iSecond, htmlID, showYn){
	rMinute = parseInt(iSecond / 60);
	rSecond = iSecond % 60;
	if(iSecond > 0){
		//타이머 표시
		if(showYn=="Y")
			$("#"+htmlID).html(fnLpad(rMinute, 2)+":"+fnLpad(rSecond, 2));
		//카운트다운
		iSecond--;
		timerChecker_02 = setTimeout("fnTimer_02('"+iSecond+"','"+htmlID+"','"+showYn+"')", 1000); // 1초 간격으로 체크
	}else{
		//타이머 반복 종료
		clearTimeout(timerChecker_02);
		//타이머 종료 처리 콜백
		fnTimer_02_callback();
	}
}


/**
 * 숫자 자릿수 맞춤
 * @param str
 * @param len
 * @returns
 */
function fnLpad(str, len){
	str = str + "";
	while(str.length < len){
		str = "0"+str;
	}
	return str;
}


function fnIsEmpty(inVal) {
	if (new String(inVal).valueOf() == "undefined")
		return true;
	if (inVal == null)
		return true;
	if (inVal == 'null')
		return true;

	var v_ChkStr = new String(inVal);

	if (v_ChkStr == null)
		return true;
	if (v_ChkStr.toString().length == 0)
		return true;
	return false;
}

function fnCalendarPopup(ctl, sDate, eDate) {		
	var id = $("#"+ctl).attr('id');

	$("#" + id).datepicker({});
	/*$("#" + id).datepicker({
		changeYear : true,
		changeMonth : false,
		showOtherMonths : true,
		selectOtherMonths : false,
		showOn : 'none'
	});*/

	if(sDate != "") $("#" + id).datepicker("option", "minDate", sDate);
	if(eDate != "") $("#" + id).datepicker("option", "maxDate", eDate);
	
	$("#" + id).datepicker('show');	
}


function fnCalendarReset(ctl) {
	var id = $("#"+ctl).attr('id');
	$("#" + id).val("");
}


/**
 * 숫자형식 검증
 */
function fnNumberCheck(event){
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( (keyID >= 48 && keyID <= 57) || (keyID >= 96 && keyID <= 105) || keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		return false;
}

/**
 * 숫자외에 삭제
 */
function fnRemoveChar(event) {
	event = event || window.event;
	var keyID = (event.which) ? event.which : event.keyCode;
	if ( keyID == 8 || keyID == 46 || keyID == 37 || keyID == 39 ) 
		return;
	else
		event.target.value = event.target.value.replace(/[^0-9]/g, "");
}

/**
 * 바이트 문자 입력가능 문자수 체크
 * 
 * @param id : tag id 
 * @param title : tag title
 * @param maxLength : 최대 입력가능 수 (byte)
 * @returns {Boolean}
 */
function fnCheckMaxLength(id, title, maxLength){
     var obj = $("#"+id);
     if(maxLength == null) {
         maxLength = obj.attr("maxLength") != null ? obj.attr("maxLength") : 1000;
     }
     
     if(Number(fnCheckByte(obj)) > Number(maxLength)) {
         alert(title + "이(가) 입력가능문자수를 초과하였습니다("+Number(fnCheckByte(obj))+").\n(영문, 숫자, 일반 특수문자 : " + maxLength + " / 한글, 한자, 기타 특수문자 : " + parseInt(maxLength/2, 10) + ")");
         obj.focus();
         return false;
     } else {
         return true;
    }
}
 
/**
 * 바이트수 반환  
 * 
 * @param el : tag jquery object
 * @returns {Number}
 */
function fnCheckByte(el){
    var codeByte = 0;
    for (var idx = 0; idx < el.val().length; idx++) {
        var oneChar = escape(el.val().charAt(idx));
        if ( oneChar.length == 1 ) {
            codeByte ++;
        } else if (oneChar.indexOf("%u") != -1) {
            codeByte += 2;
        } else if (oneChar.indexOf("%") != -1) {
            codeByte ++;
        }
    }
    return codeByte;
}

/**
 * input object 입력여부 체크  
 * 
 * @returns {Boolean}
 */
function fnCheckRequired() {
	// TODO form 수 체크, input 외 다른 object 체크, 필수가 아닌 object 체크
	var inputObjs = $("form input");
	var bEmpty = true;
	var focus;
	
	inputObjs.each(function(index){
		if($(this).val() == '') {
			focus = $(this);
			bEmpty = false;
			
			alert($(this).attr('title') + "은(는) 필수입력항목입니다.");
			focus.focus();
			
			return false;
		}
	});
	
	if(!bEmpty) return;
}

/**
 * 이미지파일 확장자 체크
 * @param obj : 파일 object
 * @param ext : 확장자문자열 예)jpg,bmp
 * @returns {Boolean}
 */
function fnCheckImg(obj, ext){
	if(!$(obj).val()) {
		return false;
	}
	
	var check = false;	
	var extName = $(obj).val().substring($(obj).val().lastIndexOf(".")+1).toUpperCase();
	var str = ext.split(",");
	for (var i=0;i<str.length;i++) {
		if ( extName == $.trim(str[i]) ) {
			check = true; break;
		} else
			check = false;
	}
	if(!check){
		alert("확장자가 "+ext+"인 파일을 업로드 하세요.");
	}
	return check;
}

/**
 * 첨부파일 용량 체크
 * @param obj : 파일 object
 * @param size : 첨부 최대크기
 * @returns {Boolean}
 */
function fnCheckImgSize(obj, size) {
	var check = false;

	if(window.ActiveXObject) {//IE용인데 IE8이하는 안됨...
		var fso = new ActiveXObject("Scripting.FileSystemObject");
		//var filepath = document.getElementById(obj).value;
		var filepath = obj[0].value;
		var thefile = fso.getFile(filepath);
		sizeinbytes = thefile.size;
	} else {//IE 외
		//sizeinbytes = document.getElementById(obj).files[0].size;
		sizeinbytes = obj[0].files[0].size;
	}

	var fSExt = new Array('Bytes', 'KB', 'MB', 'GB');
	var i = 0;
	var checkSize = size;

	while(checkSize>900) {
		checkSize/=1024;
		i++;
	}

	checkSize = (Math.round(checkSize*100)/100)+' '+fSExt[i]; 

	var fSize = sizeinbytes;
	if(fSize > size) {
		alert("첨부파일은 "+ checkSize + " 이하로 등록가능합니다.");
		check = false;
	} else {
		check = true;
	}

	return check;
}

/**
 * 화면 중앙에 window.open
 * @param sUrl : 오픈할 url
 * @param sName : 팝업 이름
 * @param iWidth  : 팝업 가로 크기
 * @param iHeigth : 팝업 세로 크기
 */
function fnOpenPopup(sUrl, sName, iWidth, iHeigth){
    var sw = screen.width;
    var sh = screen.height;
    var x = (sw-iWidth)/2;
    var y = (sh-iHeigth)/2;
    var opts = "width="+iWidth+", height="+iHeigth+", left="+x+", top="+y+", scrollbars=yes, menubar=no, location=no";
    window.open(sUrl, sName, opts).focus();
}


