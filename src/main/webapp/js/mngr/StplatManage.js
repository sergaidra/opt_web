
Ext.define('StplatInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'STPLAT_CODE', type:'string'}
			, {name:'STPLAT_SJ', type:'string'}
			, {name:'STPLAT_CN', type:'string'}
			]
});

var stUse = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	model: 'StplatInfo',
	proxy: {
		type: 'ajax',
		url: '../selectStplat/?STPLAT_CODE=000001',
		reader: {
			type: 'json',
			root: 'data',
		}
	},
	listeners: {
		'beforeload': function( store, operation, eOpts ){
			Ext.getBody().mask('조회 중 입니다. 잠시만 기다려주세요...');
		},
		'load': function(store, records, successful, eOpts) {
			if(store.getCount()) {
				frReg.getForm().loadRecord(store.getAt(0));
			}
			Ext.getBody().unmask();
		}
	}
});

var stUse2 = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	model: 'StplatInfo',
	proxy: {
		type: 'ajax',
		url: '../selectStplat/?STPLAT_CODE=000002',
		reader: {
			type: 'json',
			root: 'data',
		}
	},
	listeners: {
		'beforeload': function( store, operation, eOpts ){
			Ext.getBody().mask('조회 중 입니다. 잠시만 기다려주세요...');
		},
		'load': function(store, records, successful, eOpts) {
			if(store.getCount()) {
				frReg2.getForm().loadRecord(store.getAt(0));
			}
			Ext.getBody().unmask();
		}
	}
});


var stUse3 = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	model: 'StplatInfo',
	proxy: {
		type: 'ajax',
		url: '../selectStplat/?STPLAT_CODE=000003',
		reader: {
			type: 'json',
			root: 'data',
		}
	},
	listeners: {
		'beforeload': function( store, operation, eOpts ){
			Ext.getBody().mask('조회 중 입니다. 잠시만 기다려주세요...');
		},
		'load': function(store, records, successful, eOpts) {
			if(store.getCount()) {
				frReg3.getForm().loadRecord(store.getAt(0));
			}
			Ext.getBody().unmask();
		}
	}
});

var stUse4 = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	model: 'StplatInfo',
	proxy: {
		type: 'ajax',
		url: '../selectStplat/?STPLAT_CODE=000004',
		reader: {
			type: 'json',
			root: 'data',
		}
	},
	listeners: {
		'beforeload': function( store, operation, eOpts ){
			Ext.getBody().mask('조회 중 입니다. 잠시만 기다려주세요...');
		},
		'load': function(store, records, successful, eOpts) {
			if(store.getCount()) {
				frReg4.getForm().loadRecord(store.getAt(0));
			}
			Ext.getBody().unmask();
		}
	}
});

var frReg = Ext.create('Ext.form.Panel', {
	title: '이용약관',
	id: 'form-reg',
	region: 'center',
	autoScroll: true,
	margin: '0 5 0 10',
	width: 900,
	tbar: ['<font color="red">※ &lt;em&gt; 태그는 삭제하지 마세요.</font>', {
		xtype: 'button',
		id: 'btn-save1',
		text: '저장',
		margin: '0 0 0 5',
		width: 60,
		handler: function() {
			Ext.Msg.show({
				title:'확인',
				msg: '저장하시겠습니까?',
				buttons: Ext.Msg.YESNO,
				icon: Ext.Msg.QUESTION,
				fn: function(btn){
					if(btn == 'yes'){
						frReg.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../updateStplat/',
							success: function(form, action) {
								Ext.Msg.alert('알림', action.result.message);
							},
							failure: function(form, action) {
								if(action.result.message) {
									Ext.Msg.alert('알림', action.result.message);
								} else {
									Ext.Msg.alert('알림', sMsg+' 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
								}
							}
						});
					}
				 }
			});
		}
	}, {
		xtype: 'button',
		text: '미리보기',
		margin: '0 0 0 5',
		width: 80,
		handler: function() {
			fn_openPopup('/cs/usetext', 'winUsetext', 1200, 700, 'yes');
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">이용약관</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'vbox',
			items: [{
				xtype: 'hiddenfield',
				id: 'form-stplat-code',
				name: 'STPLAT_CODE',
				fieldLabel: '코드',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				readOnly: true,
				value: '000001'
			},{
				xtype: 'textfield',
				id: 'form-stplat-sj',
				name: 'STPLAT_SJ',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				fieldLabel: '제목'
			},{
				xtype: 'textareafield',
				id: 'form-stplat-cn',
				name: 'STPLAT_CN',
				fieldLabel: '내용',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				grow      : true,
				anchor    : '100%',
				isFocus: false,
				height: 600,
				width: 800,
				allowBlank: false,
				enableKeyEvents: true
			}]
		}]
	}]
});

var frReg2 = Ext.create('Ext.form.Panel', {
	title: '여행자약관',
	id: 'form-reg-2',
	region: 'center',
	autoScroll: true,
	margin: '0 5 0 10',
	tbar: ['<font color="red">※ &lt;em&gt; 태그는 삭제하지 마세요.</font>', {
		xtype: 'button',
		id: 'btn-save2',
		text: '저장',
		margin: '0 0 0 5',
		width: 60,
		handler: function() {
			Ext.Msg.show({
				title:'확인',
				msg: '저장하시겠습니까?',
				buttons: Ext.Msg.YESNO,
				icon: Ext.Msg.QUESTION,
				fn: function(btn){
					if(btn == 'yes'){
						frReg2.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../updateStplat/',
							success: function(form, action) {
								Ext.Msg.alert('알림', action.result.message);
							},
							failure: function(form, action) {
								if(action.result.message) {
									Ext.Msg.alert('알림', action.result.message);
								} else {
									Ext.Msg.alert('알림', sMsg+' 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
								}
							}
						});
					}
				 }
			});
		}
	}, {
		xtype: 'button',
		text: '미리보기',
		margin: '0 0 0 5',
		width: 80,
		handler: function() {
			fn_openPopup('/cs/usetext2', 'winUsetext2', 1200, 700, 'yes');
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">사용자약관</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'vbox',
			items: [{
				xtype: 'hiddenfield',
				id: 'form2-stplat-code',
				name: 'STPLAT_CODE',
				fieldLabel: '코드',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				readOnly: true,
				value: '000002'
			},{
				xtype: 'textfield',
				id: 'form2-stplat-sj',
				name: 'STPLAT_SJ',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				fieldLabel: '제목'
			},{
				xtype: 'textareafield',
				id: 'form2-stplat-cn',
				name: 'STPLAT_CN',
				fieldLabel: '내용',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				grow      : true,
				anchor    : '100%',
				isFocus: false,
				height: 600,
				width: 800,
				allowBlank: false,
				enableKeyEvents: true
			}]
		}]
	}]
});

var frReg3 = Ext.create('Ext.form.Panel', {
	title: '개인정보취급방침',
	id: 'form-reg-3',
	region: 'center',
	autoScroll: true,
	margin: '0 5 0 10',
	tbar: ['<font color="red">※ &lt;em&gt; 태그는 삭제하지 마세요.</font>', {
		xtype: 'button',
		id: 'btn-save3',
		text: '저장',
		margin: '0 0 0 5',
		width: 60,
		handler: function() {
			Ext.Msg.show({
				title:'확인',
				msg: '저장하시겠습니까?',
				buttons: Ext.Msg.YESNO,
				icon: Ext.Msg.QUESTION,
				fn: function(btn){
					if(btn == 'yes'){
						frReg3.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../updateStplat/',
							success: function(form, action) {
								Ext.Msg.alert('알림', action.result.message);
							},
							failure: function(form, action) {
								if(action.result.message) {
									Ext.Msg.alert('알림', action.result.message);
								} else {
									Ext.Msg.alert('알림', sMsg+' 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
								}
							}
						});
					}
				 }
			});
		}
	}, {
		xtype: 'button',
		text: '미리보기',
		margin: '0 0 0 5',
		width: 80,
		handler: function() {
			fn_openPopup('/cs/usetext3', 'winUsetext3', 1200, 700, 'yes');
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">개인정보 및 취급방침</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'vbox',
			items: [{
				xtype: 'hiddenfield',
				id: 'form3-stplat-code',
				name: 'STPLAT_CODE',
				fieldLabel: '코드',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				readOnly: true,
				value: '000003'
			},{
				xtype: 'textfield',
				id: 'form3-stplat-sj',
				name: 'STPLAT_SJ',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				fieldLabel: '제목'
			},{
				xtype: 'textareafield',
				id: 'form3-stplat-cn',
				name: 'STPLAT_CN',
				fieldLabel: '내용',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				grow      : true,
				anchor    : '100%',
				isFocus: false,
				height: 600,
				width: 800,
				allowBlank: false,
				enableKeyEvents: true
			}]
		}]
	}]
});

var frReg4 = Ext.create('Ext.form.Panel', {
	title: '취소 및 환불정책',
	id: 'form-reg-4',
	region: 'center',
	autoScroll: true,
	margin: '0 5 0 10',
	tbar: ['<font color="red">※ &lt;em&gt; 태그는 삭제하지 마세요.</font>', {
		xtype: 'button',
		id: 'btn-save4',
		text: '저장',
		margin: '0 0 0 5',
		width: 60,
		handler: function() {
			Ext.Msg.show({
				title:'확인',
				msg: '저장하시겠습니까?',
				buttons: Ext.Msg.YESNO,
				icon: Ext.Msg.QUESTION,
				fn: function(btn){
					if(btn == 'yes'){
						frReg4.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../updateStplat/',
							success: function(form, action) {
								Ext.Msg.alert('알림', action.result.message);
							},
							failure: function(form, action) {
								if(action.result.message) {
									Ext.Msg.alert('알림', action.result.message);
								} else {
									Ext.Msg.alert('알림', sMsg+' 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
								}
							}
						});
					}
				 }
			});
		}
	}, {
		xtype: 'button',
		text: '미리보기',
		margin: '0 0 0 5',
		width: 80,
		handler: function() {
			fn_openPopup('/cs/usetext4', 'winUsetext4', 1200, 700, 'yes');
		}
	}],
	items: [{
		xtype: 'fieldset',
		title: '<span style="font-weight:bold;">취소 및 환불정책</span>',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'vbox',
			items: [{
				xtype: 'hiddenfield',
				id: 'form4-stplat-code',
				name: 'STPLAT_CODE',
				fieldLabel: '코드',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				readOnly: true,
				value: '000004'
			},{
				xtype: 'textfield',
				id: 'form4-stplat-sj',
				name: 'STPLAT_SJ',
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				width: 800,
				fieldLabel: '제목'
			},{
				xtype: 'textareafield',
				id: 'form4-stplat-cn',
				name: 'STPLAT_CN',
				fieldLabel: '내용',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 60,
				labelAlign: 'right',
				grow      : true,
				anchor    : '100%',
				isFocus: false,
				height: 600,
				width: 800,
				allowBlank: false,
				enableKeyEvents: true
			}]
		}]
	}]
});

/*
 * 화면 레이아웃을 구성한다.
 */
Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		//padding:'5 5 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		//items: [frSearch, Ext.create('Ext.tab.Panel', {
		items: [Ext.create('Ext.tab.Panel', {
			id: 'reg-tabs',
			activeTab: 0,
			layout: 'border',
			region: 'center',
			//padding:'0 0 0 5',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frReg, frReg2, frReg3, frReg4]
		})]
	});
});

