Ext.define('UserInfo', {
	extend: 'Ext.data.Model',
	fields: ['ESNTL_ID', 'USER_ID', 'USER_NM', 'PASSWORD', 'AUTHOR_CL', 'MOBLPHON_NO', 'CRTFC_AT', 'EMAIL_RECPTN_AT', 'USE_AT', 'WRITNG_DT', 'UPDT_DT']
});

var comboAuthorCl = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-author-cl',
	name: 'AUTHOR_CL',	
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
		    ['', '전체'],
			['A', '관리자'],
			['M', '현지관리자']
		]
	}),
	fieldLabel: '권한분류',
	labelAlign: 'right',
	labelWidth: 70,
	width: 180,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var comboCrtfcAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-crtfc-at',
	name: 'CRTFC_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
		    ['', '전체'],
			['Y', '인증'],
			['N', '미인증']
		]
	}),
	fieldLabel: '인증여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var comboRecptnAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-email-recptn-at',
	name: 'EMAIL_RECPTN_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
			['', '전체'],
			['Y', '수신'],
			['N', '미수신']
		]
	}),
	fieldLabel: '수신여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var comboUseAt = new Ext.create('Ext.form.ComboBox', {
	id: 'sch-use-at',
	name: 'USE_AT',
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data:[
			['', '전체'],
			['Y', '사용'],
			['N', '사용안함']
		]
	}),
	fieldLabel: '사용여부',
	labelAlign: 'right',
	labelWidth: 70,
	width: 170,
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	editable: false,
	lazyRender: true
});

var frCond = Ext.create('Ext.form.Panel', {
	id: 'form-sch',
	region: 'north',
	height: 75,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [/*{
				xtype: 'textfield',
				id: 'sch-user-nm',
				name: 'USER_NM',
				fieldLabel: '이름',
				fieldStyle: {'ime-mode':'active'},
				labelWidth: 50,
				labelAlign: 'right',
				border: false,
				width: 150,
				enableKeyEvents: true,
				listeners: {
					specialkey: function(tf, e){
						if (e.getKey() == e.ENTER) {
							Ext.getCmp('btn-search').fireEvent('click');
						}
					}
				}
			}, {
				xtype: 'textfield',
				id: 'sch-user-id',
				name: 'USER_ID',
				fieldLabel: '아이디',
				fieldStyle: {'ime-mode':'disabled'},
				labelWidth: 70,
				labelAlign: 'right',
				border: false,
				width: 200,
				enableKeyEvents: true,
				listeners: {
					specialkey: function(tf, e){
						if (e.getKey() == e.ENTER) {
							Ext.getCmp('btn-search').fireEvent('click');
						}
					}
				}
			},*/ comboAuthorCl, comboUseAt, {
				xtype: 'hiddenfield', id: 'sch-author-cl-not', name: 'AUTHOR_CL_NOT', value: 'G'
			}, {
				xtype: 'button',
				id: 'btn-search',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						stUser.proxy.extraParams = Ext.getCmp('form-sch').getForm().getValues();
						stUser.loadPage(1);
					}
				}
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					frCond.getForm().reset();
					stUser.removeAll();
				}
			}]
		}]
	}]
});

var stUser = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	pageSize: 20,
	model: 'UserInfo',
	proxy: {
		type: 'ajax',
		url: '../selectUserList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grUser = Ext.create('Ext.grid.Panel', {
	title: '관리자목록',
	region:'center',
	store: stUser,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '순번',
    	xtype: 'rownumberer',
    	align: 'center',
    	width: 50
	},{
		text: '고유번호',
		width: 200,
		align: 'center',
		dataIndex: 'ESNTL_ID'
	},{
		text: '이름',
		width: 100,
		align: 'center',
		dataIndex: 'USER_NM'
	},{
		text: '아이디',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'USER_ID'
	},{
		text: '권한분류',
		width: 100,
		align: 'center',
		dataIndex: 'AUTHOR_CL',
		renderer: Ext.ux.comboBoxRenderer(comboAuthorCl)		
	},{
		text: '휴대폰번호',
		width: 150,
		align: 'center',
		dataIndex: 'MOBLPHON_NO'
	},{
		text: '인증여부',
		width: 100,
		align: 'center',
		dataIndex: 'CRTFC_AT',
		renderer: Ext.ux.comboBoxRenderer(comboCrtfcAt)
	},{
		text: 'E-mail수신여부',
		width: 120,
		align: 'center',
		dataIndex: 'EMAIL_RECPTN_AT',
		renderer: Ext.ux.comboBoxRenderer(comboRecptnAt)
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboUseAt)
	},{
		text: '가입일시',
		width: 150,
		align: 'center',
		dataIndex: 'WRITNG_DT'
	},{
		text: '수정일시',
		width: 150,
		align: 'center',
		dataIndex: 'UPDT_DT'
	}],
	bbar: Ext.create('Ext.PagingToolbar', {
		store: stUser,
		displayInfo: true,
		displayMsg: '전체 {2}건 중 {0} - {1}',
		emptyMsg: "조회된 자료가 없습니다."
	}),
	listeners: {
		itemdblclick: function(grid, record, item, index, e, eOpts) {
			Ext.getCmp('form-info').getForm().loadRecord(record);
			winUser.show();
		}
	}
});

var winUser = Ext.create('Ext.window.Window', {
	title: '관리자 정보 수정',
	height: 400,
	width: 450,
	layout: 'border',
	closable: true,
	closeAction: 'hide',
	modal: true,
	items: [{
		id: 'form-info',
		xtype: 'form',
		region: 'center',
		border: false,
		padding: 10,
		items: [{
			xtype: 'fieldset',
			title: '관리자 정보',
			layout: 'vbox',
			padding: '17 10 15 10',
			items: [{
				xtype: 'textfield',
				id: 'info-esntl-id',
				name: 'ESNTL_ID',
				labelAlign: 'right',
				fieldLabel: '고유번호',
				fieldStyle: {'ime-mode':'active'},
				labelWidth: 120,
				width: 320,
				maxLength: 25,
				readOnly: true,
				selectOnFocus: true,
				allowBlank: false,
				enableKeyEvents: true,
				listeners: {
				}
			},{
				xtype: 'textfield',
				id: 'info-user-nm',
				name: 'USER_NM',
				labelAlign: 'right',
				fieldLabel: '이름',
				fieldStyle: {'ime-mode':'active'},
				labelWidth: 120,
				width: 320,
				maxLength: 25,
				selectOnFocus: true,
				allowBlank: false,				
				enableKeyEvents: true,
				listeners: {
				}
			},{
				xtype: 'textfield',
				id: 'info-user-id',
				name: 'USER_ID',
				labelAlign: 'right',
				fieldLabel: '아이디',
				fieldStyle: {'ime-mode':'disabled'},
				labelWidth: 120,
				width: 320,
				maxLength: 20,
				readOnly: true,
				selectOnFocus: true,
				allowBlank: false,
				enableKeyEvents: true,
				listeners: {

				}
			},{
				xtype: 'combo',
				id: 'info-author-cl',
				name: 'AUTHOR_CL',	
				store: new Ext.create('Ext.data.ArrayStore', {
					fields:['code', 'name'],
					data:[
						['A', '관리자'],
						['M', '현지관리자']
					]
				}),
				fieldLabel: '권한분류',
				labelAlign: 'right',
				labelWidth: 120,
				width: 320,
				displayField: 'name',
				valueField: 'code',
				mode: 'local',
				typeAhead: false,
				triggerAction: 'all',
				editable: false,
				lazyRender: true
			},{
				xtype: 'textfield',
				id: 'info-moblphon-no',
				name: 'MOBLPHON_NO',
				labelAlign: 'right',
				fieldLabel: '휴대폰번호',
				fieldStyle: {'ime-mode':'disabled'},
				labelWidth: 120,
				width: 320,
				maxLength: 20,
				selectOnFocus: true,
				allowBlank: false,
				enableKeyEvents: true,
				listeners: {
				}
			},{
				xtype: 'radiogroup',
				id: 'info-crtfc-at',
				fieldLabel: '휴대폰 인증여부',
				labelWidth: 120,
				labelAlign: 'right',
				width: 320,
				border: false,
				items: [{ boxLabel: '미인증', id:'info-crtfc-at-n', name: 'CRTFC_AT', inputValue:'N'},
						{ boxLabel: '인증', id:'info-crtfc-at-y', name: 'CRTFC_AT', inputValue:'Y'}]
			},{
				xtype: 'radiogroup',
				id: 'info-email-recptn-at',
				fieldLabel: 'E-mail 수신여부',
				labelWidth: 120,
				labelAlign: 'right',
				width: 320,
				border: false,
				items: [{ boxLabel: '미수신', id:'info-email-recptn-at-n', name: 'EMAIL_RECPTN_AT', inputValue:'N'},
						{ boxLabel: '수신', id:'info-email-recptn-at-y', name: 'EMAIL_RECPTN_AT', inputValue:'Y'}]
			},{
				xtype: 'radiogroup',
				id: 'info-use-at',
				fieldLabel: '사용여부',
				labelWidth: 120,
				labelAlign: 'right',
				width: 320,
				border: false,
				items: [{ boxLabel: '사용안함', id:'info-use-at-n', name: 'USE_AT', inputValue:'N'},
						{ boxLabel: '사용', id:'info-use-at-y', name: 'USE_AT', inputValue:'Y'}]
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items:[{
				id: 'form-btn-add',
				xtype: 'button',
				width: 60,
				margin: '0 0 0 295',
				text: '저장',
				listeners: {
					click: function (btn, e, opts) {
						Ext.Msg.show({
							 title:'확인',
							 msg: '저장하시겠습니까?',
							 buttons: Ext.Msg.YESNO,
							 icon: Ext.Msg.QUESTION,
							 fn: function(btn){
								if(btn == 'yes'){
									Ext.getCmp('form-info').getForm().submit({
										waitMsg: '저장중입니다...',
										url: '../updateUser/',
										//params: {'data': Ext.encode(Ext.getCmp('form-info').getValues())},
										success: function(form, action) {
											Ext.MessageBox.alert('알림', action.result.message, function(){
												winUser.hide();
												stUser.reload();
											});
										},
										failure: function(form, action) {
											if(action.result.message) {
												Ext.MessageBox.alert('알림', action.result.message);
											} else {
												Ext.MessageBox.alert('알림', '저장 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
											}
										}
									});
								}
							 }
						});
					}
				}
			},{
				xtype: 'button',
				width: 60,
				margin: '0 0 0 5',
				text: '닫기',
				listeners: {
					click: function (btn, e, opts) {
						btn.up('.window').close();
					}
				}
			}]
		}]
	}]
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frCond, grUser]
	});
});