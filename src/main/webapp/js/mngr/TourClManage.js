var formSave = Ext.create('Ext.form.Panel', {});

function fn_search() {
	storeTree.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	storeTree.load();
	store.removeAll();
}

var storeTree = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}, 'cl_se', 'delete_at'],
	root: {text: '전체', id: '', leaf: false},
	proxy: {
		type: 'ajax',
		url: '../selectTourClTree/',
		reader: {
			type: 'json',
			root: 'data'
		}
	},
	listeners: {
		load: function(st, node, records, successful, eOpts ) {
			if(!successful) {
				alert('상위분류코드 조회 오류');
			}
		}
	}
});

var tree = Ext.create('Ext.tree.Panel', {
	title: '상위분류코드',
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
			store.proxy.extraParams = {UPPER_CL_CODE:record.data.id, DELETE_AT:Ext.getCmp('radio-gubun').getValue().DELETE_AT};
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

Ext.define('TourClInfo', {
    extend: 'Ext.data.Model',
    fields: ['CL_CODE', 'CL_NM', 'CL_NM_ENG', 'UPPER_CL_CODE', 'CL_SE', 'SORT_ORDR', 'DELETE_AT', 'CF_GOODS_CNT', 'CRUD']
});

var comboDeleteAt = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
	        ['N', '사용'],
	        ['Y', '사용안함']
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

var comboStayngAt = new Ext.create('Ext.form.ComboBox', {
	store: new Ext.create('Ext.data.ArrayStore', {
		fields:['code', 'name'],
		data :[
	        ['N', '아니오'],
	        ['Y', '예']
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
		    	items: [{ boxLabel: '전체(사용안함 포함)', id:'radio-delete-all', name: 'DELETE_AT', inputValue:''},
		    			{ boxLabel: '사용', id:'radio-delete-n', name: 'DELETE_AT', inputValue:'N', checked: true }],
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
					storeTree.load({params:{DELETE_AT:'N', UPPER_CL_CODE:'00000'}});
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'TourClInfo',
	proxy: {
		type: 'ajax',
		url: '../selectTourClUpperList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
	title: '상세분류코드목록',
	region:'center',
	store: store,
	border: true,
	split : true,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '분류코드',
		width: 100,
		align: 'center',
		//editor: {xtype:'textfield', allowBlank: false, maxLength: 5, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CL_CODE'
	},{
		text: '분류명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 23, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CL_NM'
	},{
		text: '분류명(일어)',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 23, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}, maskRe: /^[a-zA-Z0-9]+$/},
		dataIndex: 'CL_NM_ENG'		
	},{
		text: '숙박시설여부',
		width: 100,
		align: 'center',
		//editor: comboStayngAt,
		dataIndex: 'CL_SE',
		hidden: true,
		renderer: Ext.ux.comboBoxRenderer(comboStayngAt)
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
		editor: comboDeleteAt,
		dataIndex: 'DELETE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboDeleteAt)
	},{
		text: 'CF_CL_CNT',
		hidden: true,
		dataIndex: 'CF_CL_CNT'
	},{
		text: 'CF_GOODS_CNT',
		hidden: true,
		dataIndex: 'CF_GOODS_CNT'
	},{
		flex: 1
	}],
	tbar: ['->', {
		text: '추가',
		width: 60,
		handler : function() {
			var treeItem = tree.getSelectionModel().getLastSelected();
			
			if (!treeItem){
				Ext.Msg.alert("알림", "상위분류를 선택하십시오.");
				return;
			}

			if(treeItem.get('delete_at') == 'Y') {
				Ext.Msg.alert("알림", "삭제된 상위분류에는 하위분류를 추가할 수 없습니다.");
				return;
			}

			var idx = store.getCount();
			var r = Ext.create('TourClInfo', {
				CL_CODE : '',
				CL_NM : '',
				UPPER_CL_CODE : treeItem.get('id'),
				CL_SE : treeItem.get('cl_se'),
				SORT_ORDR : '',
				DELETE_AT : 'N',
				CRUD : 'C'
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
				if(sm.getSelection()[0].data.DELETE_AT == 'Y') {
					Ext.Msg.alert('확인', '등록된 코드는 삭제 불가합니다.');	
				} else {
					Ext.Msg.alert('확인', '사용안함 처리를 하십시오.');
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

			if(fn_chkGridAllowBlank(store, {CL_NM:'분류명'})) return;

			var datas = new Array();

			var inserted = store.getNewRecords();
			var modified = store.getUpdatedRecords();
			var deleted = store.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					//modified[i].set('CRUD', 'U');
					//datas.push(modified[i].data);
					if(modified[i].data.DELETE_AT == 'Y') {
						if(modified[i].data.CF_GOODS_CNT != '0') {
							if(!confirm('분류 ['+modified[i].data.CL_NM + '] 에 등록된 상품이 모두 삭제처리됩니다. 계속하시겠습니까?')) {
								return;
							}
						}
						modified[i].set('CRUD', 'D');
						datas.push(modified[i].data);
					} else {
						modified[i].set('CRUD', 'U');
						datas.push(modified[i].data);
					}
				}

				for (var i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveTourClInfo/',
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
				Ext.Msg.alert('알림', '변경된 자료가 없습니다.');
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