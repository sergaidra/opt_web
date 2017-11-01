var formSave = Ext.create('Ext.form.Panel', {});

Ext.define('GroupInfo', {
    extend: 'Ext.data.Model',
    fields: ['GROUP_CODE', 'GROUP_NM', 'GROUP_DC', 'USE_AT', 'WRITNG_DE', 'UPDT_DE', 'CRUD']
});

var combo = new Ext.create('Ext.form.ComboBox', {
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

var store = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	//pageSize: 100,
	model: 'GroupInfo',
	proxy: {
		type: 'ajax',
		url: '../selectGroupList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
//	title: '보관함 목록',
	region:'center',
	store: store,
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '그룹 코드',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: false, length: 6, maxLength: 6, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'GROUP_CODE'
	},{
		text: '그룹 명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'GROUP_NM'
	},{
		text: '설명',
		//width: 200,
		flex: 1,
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 25, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'GROUP_DC'
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: combo,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(combo)
	}],
	/*bbar: Ext.create('Ext.PagingToolbar', {
		store: store,
		displayInfo: true,
		displayMsg: 'Displaying topics {0} - {1} of {2}',
		emptyMsg: "No topics to display"
	}),*/
	tbar: [{
    	xtype: 'radiogroup',
    	id: 'use-at',
    	fieldLabel: '사용여부',
    	labelWidth: 60,
    	labelAlign: 'right',
    	border: false,
    	width: 180,
    	items: [{ boxLabel: '전체', id:'use-at-all', name: 'USE_AT', inputValue:''},
    			{ boxLabel: '사용', id:'use-at-y', name: 'USE_AT', inputValue:'Y', checked: true }],
    	listeners: {
    		change : function(radio, newValue, oldValue, eOpts ) {
    			Ext.getCmp('btn-sch').fireEvent('click');
    		}
    	}
	}, '->', {
		text: '조회',
		id: 'btn-sch',
		width: 60,
		listeners: {
			click: function() {
				store.load({params:{USE_AT:Ext.getCmp('use-at').getValue().USE_AT}});
			}
		}
	}, {
		text: '추가',
		width: 60,
		handler : function() {
			var idx = store.getCount();
			var r = Ext.create('GroupInfo', {
				GROUP_CODE : '', 
				GROUP_NM : '', 
				GROUP_DC : '', 
				USE_AT : 'Y', 
				WRITNG_DE : '', 
				UPDT_DE : '', 
				CRUD  : 'I'
			});
			store.insert(idx, r);
			cellEditing.startEditByPosition({row: idx, column: 0});
		}
	}, {
		text: '저장',
		width: 60,
		handler: function() {
			var datas = new Array();

			var inserted = store.getNewRecords();
			var modified = store.getUpdatedRecords();
			
			if (modified.length + inserted.length > 0) {
				for (i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGroupInfo/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							store.reload();
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
		//padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [grid]
	});
	Ext.getCmp('btn-sch').fireEvent('click');
});