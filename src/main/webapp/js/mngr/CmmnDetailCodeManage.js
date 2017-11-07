var formSave = Ext.create('Ext.form.Panel', {});

function fn_search() {
	storeTree.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	storeTree.load();
	store.removeAll();
}

var storeTree = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}],
	root: {text: '전체', id: '', leaf: false},
	proxy: {
		type: 'ajax',
		url: '../selectCmmnCodeTree/',
		reader: {
			type: 'json',
			root: 'data'
		}
	},
	listeners: {
		load: function(st, node, records, successful, eOpts ) {
			if(!successful) {
			}
		}
	}
});

var tree = Ext.create('Ext.tree.Panel', {
	title: '공통코드',
	region: 'west',
	border: true,
	split : true,
	width: 300,
	collapsible : false,
	animCollapse : true,
	store: storeTree,
	collapseFirst: true,
	rootVisible: false,
	listeners: {
		itemclick: function(tree, record, item, index, e, eOpts ) {
			store.proxy.extraParams = {CODE_ID:record.data.id, USE_AT:Ext.getCmp('radio-gubun').getValue().USE_AT};
			store.load();
		}
	}
});

Ext.define('CmmnDetailCodeInfo', {
    extend: 'Ext.data.Model',
    fields: ['CODE_ID', 'CODE', 'CODE_NM', 'CODE_NM_ENG', 'CODE_DC', 'SORT_ORDR', 'USE_AT', 'REGIST_DT', 'UPDT_DT', 'CRUD', 'PK_CODE']
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
	height: 75,
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
		    			{ boxLabel: '사용', id:'radio-use-y', name: 'USE_AT', inputValue:'Y', checked: true }],
		    	listeners: {
		    		change : function(radio, newValue, oldValue, eOpts ) {
		    			Ext.getCmp('btn-search').fireEvent('click');
		    		}
		    	}
			}, {
				xtype: 'hidden',
				id: 'form-upper-cl-code',
				name: 'UPPER_CL_CODE',
				value: '00000'
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
			},{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '초기화',
				width: 60,
				handler: function(){
					store.removeAll();					
					storeTree.load({params:{USE_AT:'Y'}});
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'CmmnDetailCodeInfo',
	proxy: {
		type: 'ajax',
		url: '../selectCmmnDetailCodeList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
	title: '공통상세코드',
	region:'center',
	store: store,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '공통상세코드',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 6, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CODE'
	},{
		text: '코드명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CODE_NM'
	},{
		text: '코드명(영문)',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 30, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'CODE_NM_ENG'		
	},{
		text: '설명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'CODE_DC'			
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
	},{
		flex: 1
	}],
	tbar: ['->', {
		text: '추가',
		width: 60,
		handler : function() {
			var treeItem = tree.getSelectionModel().getLastSelected();
			
			if (!treeItem){
				Ext.Msg.alert("알림", "공통코드를 선택하십시오.");
				return;
			}

			if(treeItem.get('delete_at') == 'Y') {
				Ext.Msg.alert("알림", "삭제된 공통코드에는 상세코드를 추가할 수 없습니다.");
				return;
			}

			var idx = store.getCount();
			var r = Ext.create('CmmnDetailCodeInfo', {
						CODE_ID: treeItem.get('id'),
						CODE: '',
						CODE_NM: '',
						CODE_NM_ENG: '',
						CODE_DC: '',
						SORT_ORDR: '',
						USE_AT: 'Y',
						REGIST_DT: '',
						UPDT_DT: '',
						CRUD: 'C',
						PK_CODE: ''
			});
			store.insert(idx, r);
			cellEditing.startEditByPosition({row: idx, column: 1});
		}
	}, {
		text: '삭제',
		width: 60,
		handler: function() {
			var sm = grid.getSelectionModel();
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
		text: '저장',
		width: 60,
		handler: function() {

			if(fn_chkGridAllowBlank(store, {CODE:'공통상세코드'})) return;
			if(fn_chkGridAllowBlank(store, {CODE_NM:'코드명'})) return;

			var datas = new Array();

			var inserted = store.getNewRecords();
			var modified = store.getUpdatedRecords();

			if (modified.length + inserted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);					
				}
				for (var i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveCmmnDetailCodeInfo/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							store.load();
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
	}],
	plugins: [cellEditing]
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [frCond, Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF',
			},
			items: [tree, grid]
		})]
	});
});