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
 * 
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
 * 
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
