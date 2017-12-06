var formSave = Ext.create('Ext.form.Panel', {});

var tourClCode = ""; 
var tourFileCode = "";

Ext.define('ArprtInfo', {
    extend: 'Ext.data.Model',
    fields: ['ARPRT_CODE', 'ARPRT_NM', 'USE_AT', 'RM', 'SORT_ORDR', 'WRITNG_DE', 'UPDT_DE', 'CRUD']
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
	model: 'ArprtInfo',
	proxy: {
		type: 'ajax',
		url: '../selectArprtList/',
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
		text: '항공사 코드',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 3, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'ARPRT_CODE'
	},{
		text: '항공사 명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 20, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'ARPRT_NM'         
	},{
		text: '정렬순서',
		width: 100,
		align: 'center',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 3, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SORT_ORDR'		
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: combo,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(combo)
	},{
		text: '비고',
		//width: 200,
		flex: 1,
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 20, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'RM'
	}],
	/*bbar: Ext.create('Ext.PagingToolbar', {
		store: store,
		displayInfo: true,
		displayMsg: 'Displaying topics {0} - {1} of {2}',
		emptyMsg: "No topics to display"
	}),*/
	tbar: ['->', {
		text: '추가',
		width: 60,
		handler : function() {
			var idx = store.getCount();
			var r = Ext.create('ArprtInfo', {
				ARPRT_CODE : '', 
				ARPRT_NM : '', 
				USE_AT : 'Y', 
				RM : '', 
				SORT_ORDR : '', 
				WRITNG_DE : '', 
				UPDT_DE : '', 
				CRUD  : 'I'
			});
			store.insert(idx, r);
			cellEditing.startEditByPosition({row: idx, column: 0});
		}
	}, {
		text: '삭제',
		width: 60,
		handler: function() {
			var sm = grid.getSelectionModel();
			store.remove(sm.getSelection());
			/*if (store.getCount() > 0) {
				sm.select(0);
			}*/	
		}
	}, {
		text: '저장',
		width: 60,
		handler: function() {
			var datas = new Array();

			var inserted = store.getNewRecords();
			var modified = store.getUpdatedRecords();
			var deleted = store.getRemovedRecords();
			
			if (modified.length + inserted.length + deleted.length > 0) {
				for (i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (i = 0; i < inserted.length; i++) {
					inserted[i].set('CRUD', 'C');
					datas.push(inserted[i].data);
				}
				
				for (i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveArprtInfo/',
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
		//padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [grid]
	});
});