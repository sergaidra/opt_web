var formSave = Ext.create('Ext.form.Panel', {});

function fn_search() {
	store.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	store.load();	
}

Ext.define('CmmnCodeInfo', {
    extend: 'Ext.data.Model',
    fields: ['CODE_ID', 'CODE_ID_NM', 'CODE_ID_NM_ENG', 'CODE_ID_DC', 'SORT_ORDR', 'USE_AT', 'REGIST_DT', 'UPDT_DT', 'CRUD', 'PK_CODE_ID']
});

var comboUseAt = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
	        ['Y', '사용'],
	        ['N', '사용안함']
	    ]
	}),
	displayField: 'name',
	valueField: 'code',
	mode: 'local',
	typeAhead: false,
	triggerAction: 'all',
	lazyRender: true,
	emptyText: '선택'
});

var frCond = Ext.create('Ext.form.Panel', {
	id: 'form-cond',
	region: 'north',
	height: 70,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		padding: '10 20 10 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
		    	xtype: 'radiogroup',
		    	id: 'radio-gubun',
		    	fieldLabel: '검색구분',
		    	labelWidth: 80,
		    	labelAlign: 'right',
		    	border: false,
		    	width: 400, 
		    	items: [{ boxLabel: '전체(사용안함 포함)', id:'radio-use-all', name: 'USE_AT', inputValue:''},
		    			{ boxLabel: '사용', id:'radio-use-n', name: 'USE_AT', inputValue:'Y', checked: true }],
		    	listeners: {
		    		change : function(radio, newValue, oldValue, eOpts ) {
		    			Ext.getCmp('btn-search').fireEvent('click');
		    		}
		    	}
			}, {
				xtype: 'button',
				id: 'btn-search',
				margin: '0 0 0 10',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						fn_search();
					}
				}
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '추가',
				width: 60,
				handler: function(){
					var idx = store.getCount();
					var r = Ext.create('CmmnCodeInfo', {
						CODE_ID : '', 
						CODE_ID_NM : '', 
						CODE_ID_NM_ENG : '', 
						CODE_ID_DC : '', 
						SORT_ORDR : '', 
						USE_AT : 'Y', 
						REGIST_DT : '', 
						UPDT_DT : '', 
						CRUD: 'C',
						PK_CODE_ID: ''
					});
					store.insert(idx, r);
					cellEditing.startEditByPosition({row: idx, column: 1});				
				}			
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '삭제',
				width: 60,
				handler: function(){
					var sm = grid.getSelectionModel();
					if(sm.getSelection().length == 0) return; 
					if(sm.getSelection()[0].data.CRUD == 'U') {
						if(sm.getSelection()[0].data.USE_AT == 'Y') {
							Ext.Msg.alert('확인', '사용안함 처리를 하십시오.');
						} else {
							Ext.Msg.alert('확인', '등록된 코드는 삭제 불가합니다.');							
						}
					} else {
						store.remove(sm.getSelection());
		                if (store.getCount() > 0) {
		                    sm.select(0);
		                }				
					} 
				}
			}, {
				xtype: 'button',
				margin: '0 0 0 10',
				text: '저장',
				width: 60,
				handler: function(){
					if(fn_chkGridAllowBlank(store, {CODE_ID:'공통코드'})) return;
					if(fn_chkGridAllowBlank(store, {CODE_ID_NM:'공통코드 명'})) return;

					var datas = new Array();

					var inserted = store.getNewRecords();
					var modified = store.getUpdatedRecords();

					if (modified.length + inserted.length > 0) {
						for (var i = 0; i < inserted.length; i++) {
							inserted[i].set('CRUD', 'C');
							datas.push(inserted[i].data);
						}
						for (var i = 0; i < modified.length; i++) {
							modified[i].set('CRUD', 'U');
							datas.push(modified[i].data);
						}

						formSave.getForm().submit({
							waitMsg: '저장중입니다...',
							url: '../saveCmmnCodeInfo/',
							params: {'data': Ext.JSON.encode(datas)},
							success: function(form, action) {
								Ext.Msg.alert('알림', '저장되었습니다.', function(){
									fn_search();
								});
							},
							failure: function(form, action) {
								f_failureMessage(action.response);
							}
						});
					} else {
						alert('변경된 자료가 없습니다.');
					}
				}						
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					store.removeAll();					
					Ext.getCmp('form-cond').getForm().reset();
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'CmmnCodeInfo',
	proxy: {
		type: 'ajax',
		url: '../selectCmmnCodeList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
	id: 'grid-cmmn-code',
	title: '분류목록',
	region:'center',
	border: true,
	padding: '10 0 0 0',
	style: {
		backgroundColor: '#FFFFFF'
	},
	store: store,
	columns: [{
		text: '공통코드',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 6, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CODE_ID'
	},{
		text: '공통코드명 ',
		width: 170,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CODE_ID_NM'
	},{
		text: '공통코드명(영문)',
		width: 170,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 20, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'CODE_ID_NM_ENG'			
	},{
		text: '설명',
		width: 300,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CODE_ID_DC'
	},{
		text: '정렬순서',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 2, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/},
		dataIndex: 'SORT_ORDR'
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: comboUseAt,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboUseAt)
	}],
	plugins: [cellEditing]		
});

/*
 * 화면 레이아웃을 구성한다.
 */
Ext.onReady(function(){    
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frCond, grid]
		})]
	});
	
	store.load({params:{USE_AT:'Y'}});
});