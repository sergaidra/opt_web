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
	// todo form 수 체크, input 외 다른 object 체크, 필수가 아닌 object 체크
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
