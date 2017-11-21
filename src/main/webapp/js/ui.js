/* GNB */


$(window).on('load resize', function() {
	if ($(this).width() >= 1024) {
		$('body').removeClass().addClass('d_pcweb');
		$('#allmenu .bg').hide();
		$('#allmenu').css({'left' : ''});
		$('#gnb>ul>li').removeClass('on').children('dl').removeAttr('style');
	} else {
		$('body').removeClass().addClass('d_mobile');
		$('header').removeAttr('style');
	}
});

$(document).ready(function () {
	// 패밀리사이트
	$('.familysite button').on('mouseenter focus', function() {
		$('.familysite dd').show();
		var famTop = $('.familysite dd').outerHeight() - 1;
		$('.familysite dd').css({'top' : -1*famTop});
	});
	$('.familysite button').on('click', function() {
		$('.familysite dd').toggle();
		var famTop = $('.familysite dd').outerHeight() - 1;
		$('.familysite dd').css({'top' : -1*famTop});
	});
	$('.familysite').on('mouseleave', function() {
		$('.familysite dd').hide();
	});
	$('#policy a, #logo_btm a').on('focus', function() {
		$('.familysite dd').hide();
	});
	
	// 탭메뉴 균등분할
	$('.tap_border, .tap_cate_multi').each(function() {
		var col = $(this).children('li').length;
		if (col > 4) col = 4;
		$(this).addClass('col'+col);
	});

	// 메인 탭
	$('.latest dt a').click(function() {
		$(this).parent('dt').addClass('on').siblings('dt').removeClass('on');
		return false;
	});
	
});


// 레이어팝업
$(document).on("keydown", '.btn_layer_close', function(e){
	if (e.keyCode == 9 && !e.shiftKey) {	// tab
		e.preventDefault();
		$(this).siblings('.tit_layer').attr('tabindex', '0').focus();
	}
}).on("keydown", '.tit_layer', function(e){
	if (e.keyCode == 9 && e.shiftKey) {		// shift + tab
		e.preventDefault();
		$(this).siblings('.btn_layer_close').focus();
	}
}).on('click', '.layer_popup .bg', function() {
	closeLayer();
	alertClose();
});

$(window).keydown(function(e) {
	if ($('.layer_popup').is(':visible') && e.keyCode == 27) {
		e.preventDefault();
		closeLayer();
		alertClose();
	}
}).on('load resize', function() {
	$('.layer_popup:visible').each(function() {
		if ($('.bg', this).is(':visible')) {
			var mt = -($(this).outerHeight()/2) + 'px';
			var ml = -($(this).outerWidth()/2) + 'px';
			$(this).css({'margin' : mt+' 0 0 '+ml});
		} else {
			$(this).css({'margin' : '0'});
		}
	})
});

var openModalBtn = null;
var layerObj = null;
function openLayer(obj, layer_id) {
	openModalBtn = $(obj);
	var layerType = $(obj).attr('class');

	if ($(obj).prop('tagName') == 'A') {
		layerObj = $(obj).attr('href');
	} else if ($(obj).prop('tagName') == 'FORM') {
		openModalBtn = $('*[type=submit]:eq(0)', obj);
		layerObj = $(obj).attr('action');
	} else {
		layerObj = layer_id;
	}

	$(layerType).hide();
	$(layerObj).show();

	$('.tit_layer', layerObj).attr('tabindex', '0').focus();
	if ($('.bg', layerObj).is(':visible')) {
		var mt = -($(layerObj).outerHeight()/2) + 'px';
		var ml = -($(layerObj).outerWidth()/2) + 'px';
		$(layerObj).css({'margin' : mt+' 0 0 '+ml});
	}
	$('html').addClass('no_scroll');

	// 콜백 함수
	if(typeof fnModal != "undefined"){
		fnModal(obj, a, b);
	}
}

function closeLayer(obj) {
	$('html').removeClass('no_scroll');
	var myContainer = $(obj).closest('div').parent('div');
	var layer;
	if ($(myContainer).attr('class') == 'alert') {
		layer = myContainer;
	} else if ($(myContainer).attr('class') == 'modal') {
		layer = $('.modal');
	} else {
		var openedLayer = $('.layer_popup:visible:last').attr('id');
		layer = $('.layer_popup:visible:last');
		$('a[href="#'+openedLayer+'"]:last').focus();
	}
	layer.css({'margin' : ''}).hide().children().children('.tit_layer').removeAttr('tabindex');
	
	if (openModalBtn != null) {
		$(openModalBtn).focus();
		openModalBtn = null;
	}
	layerObj = null;
}

// 레이어 얼럿
var alertOpener = null;
function alertLayer(obj, msg, title) {
	$('html').addClass('no_scroll');
	alertOpener = $(obj);
	var layerTit = '안내 메시지';
	if (title) 	var layerTit = title;
	$('body').append('<div class="layer_popup alert auto" style="display:block;"><div class="bg"></div><h2 class="tit_layer" tabindex="0">'+layerTit+'</h2><div class="layer_cont"><p>'+msg+'</p><div class="btn_area"><button type="button" class="btn" onclick="alertClose(this);">확인</button></div></div><button type="button" class="btn_layer_close" onclick="alertClose(this);">레이어닫기</button></div>');

	var alertWin = $('.alert.auto:visible');
	var mt = -(alertWin.outerHeight()/2) + 'px';
	var ml = -(alertWin.outerWidth()/2) + 'px';
	alertWin.css({'margin' : mt+' 0 0 '+ml});
	$('.tit_layer', alertWin).focus();
}
function alertClose(obj) {
	$('html').removeClass('no_scroll');
	if (alertOpener != null) {
		$(alertOpener).focus();
		alertOpener = null;
	}
	$(obj).closest('.layer_popup').remove();
}