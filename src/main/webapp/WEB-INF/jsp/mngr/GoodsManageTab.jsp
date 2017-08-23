<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<title>여행상품관리</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<link rel="stylesheet" type="text/css" href="<c:url value='/css/extjs/resources/ext-theme-neptune/ext-theme-neptune-all.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/common-extjs.css' />">
<link rel="stylesheet" type="text/css" href="<c:url value='/css/button-extjs.css' />">
<script type="text/javascript" src="<c:url value='/js/extjs/ext-all.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/extjs/locale/ext-lang-ko.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/extjs/ext-theme-neptune.js' />"></script>
<script type="text/javascript" src="<c:url value='/js/Common.js' />"></script>
<script type="text/javascript">
Ext.onReady(function() {
	var getContextPath = "${pageContext.request.contextPath}";
	var getBasicUrl = 'http://' + '${pageContext.request.serverName}' + ':' + '${pageContext.request.serverPort}';
	getBasicUrl += getContextPath;
	
	Ext.create('Ext.Viewport', {
		layout : 'border',
		items : [
		  	Ext.create('Ext.tab.Panel', {
		  		id : 'tab-goods-panel',
				region : 'center',
				items : [{
					xtype: 'component',
					id: 'tab-goods-manage',
					title : '여행상품조회',
					autoEl : {
						tag : 'iframe',
						style : 'height: 100%; width: 100%; border: none',
						src : getContextPath + '/mngr/GoodsManage/'
					}
				},{
					xtype: 'component',
					id: 'tab-goods-regist',
					title : '여행상품등록',
					autoEl : {
						tag : 'iframe',
						style : 'height: 100%; width: 100%; border: none',
						src : getContextPath + '/mngr/GoodsRegist/'
					}
				}],
				listeners : {
					tabchange : function(tabPanel, newCard, oldCard, eOpts) {
						/* var task1 = new Ext.util.DelayedTask(function(){
							if (!Ext.isIE && !Ext.isChrome) {
								window.frames['tab-dsp-input-manager'].contentWindow.Ext.getCmp('form-cond-ihidnum').focus();
							} else {
								window.frames['tab-dsp-input-manager'].Ext.getCmp('form-cond-ihidnum').focus();
							}
						});

						var task2 = new Ext.util.DelayedTask(function(){
							if (!Ext.isIE && !Ext.isChrome) {
								window.frames['tab-dsp-input-statistics'].contentWindow.Ext.getCmp('form-cond-ihidnum-1').focus();
							} else {
								window.frames['tab-dsp-input-statistics'].Ext.getCmp('form-cond-ihidnum-1').focus();
							}
						});

						if(newCard.getId() == 'tab-dsp-input-manager') {
							task1.delay(200);
						} else if(newCard.getId() == 'tab-dsp-input-statistics') {
							task2.delay(200);
						} */
					}
				}
		  	})
		]
	});
});
</script>
</head>
<body>
<div id="center"></div>
</body>
</html>
