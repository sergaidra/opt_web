var formSave = Ext.create('Ext.form.Panel', {});

function fn_search() {
	storeTree.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	storeTree.load();
	store.removeAll();
}

var storeTree = Ext.create('Ext.data.TreeStore', {
	autoLoad: false,
	autoSync: false,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}, 'url', 'use_at'],
	proxy: {
		type: 'ajax',
		url: '../selectUpperMenuTree/',
		reader: {
			type: 'json',
			root: 'data'
		}
	},
	listeners: {
		load: function(st, node, records, successful, eOpts ) {
			if(!successful) {
				alert('조회 오류');
			}
		}
	}
});

var tree = Ext.create('Ext.tree.Panel', {
	title: '상위메뉴코드',
	region: 'west',
	border: true,
	split : true,
	width: 200,
	collapsible : false,
	animCollapse : true,
	store: storeTree,
	collapseFirst: true,
	rootVisible: false,
	listeners: {
		itemclick: function(tree, record, item, index, e, eOpts ) {
			store.proxy.extraParams = {UPPER_MENU_CODE:record.data.id, USE_AT:Ext.getCmp('radio-gubun').getValue().USE_AT};
			store.load();
		},
		afterrender: function(tree, eOpts ) {
			/* first node click event (not work)
			var root = storeTree.getRootNode();
		    var selModel = tree.getSelectionModel();
			selModel.select(root.firstChild);
			tree.fireEvent('itemclick', root.firstChild);
			*/
		}
	}
});

Ext.define('MenuInfo', {
    extend: 'Ext.data.Model',
    fields: ['MENU_CODE', 'MENU_NM', 'MENU_URL', 'MENU_DC', 'UPPER_MENU_CODE', 'SORT_ORDR', 'USE_AT', 'REGIST_DT', 'UPDT_DT', 'CRUD']
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
		    			{ boxLabel: '사용', id:'radio-use-n', name: 'USE_AT', inputValue:'Y', checked: true }],
		    	listeners: {
		    		change : function(radio, newValue, oldValue, eOpts ) {
		    			Ext.getCmp('btn-search').fireEvent('click');
		    		}
		    	}
			}, {
				xtype: 'hidden',
				id: 'form-upper-cl-code',
				name: 'UPPER_MENU_CODE',
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
					storeTree.load({params:{USE_AT:'Y', node:'00000'}});
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'MenuInfo',
	proxy: {
		type: 'ajax',
		url: '../selectMenuList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
	title: '상세메뉴코드목록',
	region:'center',
	store: store,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '메뉴코드',
		width: 100,
		align: 'center',
		dataIndex: 'MENU_CODE'
	},{
		text: '메뉴명',
		width: 180,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 23, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'MENU_NM'
	},{
		text: '메뉴URL',  
		width: 250,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 50, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'MENU_URL'		
	},{
		text: '설명',
		width: 180,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 30, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'MENU_DC'					
	},{
		text: '정렬순서',
		width: 80,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 2, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/},
		dataIndex: 'SORT_ORDR'
	},{
		text: '사용여부',
		width: 90,
		align: 'center',
		editor: comboUseAt,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboUseAt)
	},{
		text: '등록일',  
		width: 90,
		align: 'center',
		dataIndex: 'REGIST_DT'		
	},{
		text: '수정일',  
		width: 90,
		align: 'center',
		dataIndex: 'UPDT_DT'					
	}],
	tbar: ['->', {
		text: '추가',
		width: 60,
		handler : function() {
			var treeItem = tree.getSelectionModel().getLastSelected();
			
			if (!treeItem){
				Ext.Msg.alert("알림", "상위메뉴를 선택하십시오.");
				return;
			}

			if(treeItem.get('delete_at') == 'Y') {
				Ext.Msg.alert("알림", "삭제된 상위메뉴에는 하위메뉴를 추가할 수 없습니다.");
				return;
			}

			var idx = store.getCount();
			var r = Ext.create('MenuInfo', {
				MENU_CODE : '',
				MENU_NM : '',
				MENU_URL : '', 
				MENU_DC : '',
				UPPER_MENU_CODE : treeItem.get('id'),
				SORT_ORDR : '',
				USE_AT : 'Y',
				REGIST_DT : '',
				UPDT_DT : '',
				CRUD : 'C'
			});
			store.insert(idx, r);
			cellEditing.startEditByPosition({row: idx, column: 1});
		}
	}, {
		text: '저장',
		width: 60,
		handler: function() {

			if(fn_chkGridAllowBlank(store, {MENU_NM:'메뉴명'})) return;
			if(fn_chkGridAllowBlank(store, {MENU_URL:'메뉴URL'})) return;

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
					url: '../saveMenuInfo/',
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
	fn_search();
});