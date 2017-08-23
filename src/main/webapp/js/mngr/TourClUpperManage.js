var formSave = Ext.create('Ext.form.Panel', {});

var tourClCode = "";
var tourFileCode = "";

Ext.define('TourClInfo', {
    extend: 'Ext.data.Model',
    fields: ['CL_CODE', 'CL_NM', 'UPPER_CL_CODE', 'STAYNG_FCLTY_AT', 'FILE_CODE', 'FILE_NM', 'SORT_ORDR', 'DELETE_AT', 'DC', 'WRITNG_DE', 'UPDT_DE', 'CF_CNT', 'CRUD']
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

var winFileUpload = Ext.create('Ext.window.Window', {
	title: '첨부파일 업로드',
	height: 120,
	width: 500,
	layout: 'border',
	closable: true,
	closeAction: 'hide',
	modal: true,
	items: [{
		id: 'excel-file-upload',
		xtype: 'form',
		region: 'center',
		border: false,
		padding: 10,
		items: [{
			xtype: 'fieldset',
			layout: 'hbox',
			padding: '17 10 15 10',
			items: [{
				xtype: 'filefield',
				name: 'ATTACH_FLIE',
				regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
				regexText: '이지미 파일을 선택하세요.',
				buttonText: '찾기...',
				fieldLabel: '첨부파일',
				labelAlign: 'right',
				labelSeparator: ':',
				labelWidth: 70,
				allowBlank: false,
				width: 360
			},{
				id: 'excel-cl-code', xtype: 'hiddenfield', name: 'CL_CODE'
			},{
				id: 'excel-file-code', xtype: 'hiddenfield', name: 'FILE_CODE'
			},{
				xtype: 'button',
				text: '업로드',
				width: 60,
				margin: '0 0 0 5',
				listeners: {
					click: function (btn, e, opts) {
						Ext.getCmp('excel-cl-code').setValue(tourClCode);
						Ext.getCmp('excel-file-code').setValue(tourFileCode);
						var form = Ext.getCmp('excel-file-upload').getForm();

						if (form.isValid()) {

							form.submit({
								timeout: 30*60*1000,
								waitMsg: '잠시만 기다려주십시오...',
								url: '../uploadTourClFile/',
								method: 'POST',
								success: function(form, action) {
									Ext.Msg.alert('알림', '저장되었습니다.', function(){
										store.load();
										winFileUpload.hide();
									});
								},
								failure: function(form, action) {
									fn_failureMessage(action.response);
								}
							});
						} else {
							console.log('is not valid');
							Ext.Msg.alert('확인', '업로드할 파일(png,jpg)을 선택하십시오.');
						}
					}
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	//pageSize: 100,
	model: 'TourClInfo',
	proxy: {
		type: 'ajax',
		url: '../selectTourClUpperList/?UPPER_CL_CODE=00000',
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
		text: '분류코드',
		width: 100,
		align: 'center',
		//editor: {xtype:'textfield', allowBlank: true, maxLength: 5, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CL_CODE'
	},{
		text: '분류명',
		width: 170,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 23, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'CL_NM'
	},{
		text: '설명',
		width: 300,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 23, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'DC'
	},{
		text: '숙박시설여부',
		width: 100,
		align: 'center',
		editor: comboStayngAt,
		dataIndex: 'STAYNG_FCLTY_AT',
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
		text: '대표이미지',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		//editor: {xtype:'textfield', allowBlank: true, maxLength: 25, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'FILE_NM'
	},{
		xtype: 'actioncolumn',
		flex: 1,
		menuDisabled: true,
		items: [{
			icon: '/images/extjs/icons/fam/image_add.png',
			tooltip: '대표이미지등록',
			handler: function(grid, rowIndex, colIndex) {
				var rec = grid.getStore().getAt(rowIndex);
				tourClCode = rec.get('CL_CODE');
				tourFileCode = rec.get('FILE_CODE');

				if(!tourClCode) {
					Ext.MessageBox.alert('확인', '분류코드를 먼저 저장 후 이미지를 저장하세요.');
				} else {
					winFileUpload.on('show', function(win){});
					winFileUpload.show();
				}
			}
		}]
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
			var r = Ext.create('TourClInfo', {
				CL_CODE : '',
				CL_NM : '',
				UPPER_CL_CODE : '00000',
				STAYNG_FCLTY_AT : 'N',
				FILE_CODE : '',
				FILE_NM : '',
				SORT_ORDR : '',
				DELETE_AT : 'N',
				DC : '',
				WRITNG_DE : '',
				UPDT_DE : '',
				CF_CNT : '0',
				CRUD : 'I'
			});
			store.insert(idx, r);
			cellEditing.startEditByPosition({row: idx, column: 1});
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
			/*if(sm.getSelection()[0].data.CF_CNT != '0') {
				Ext.MessageBox.confirm("확인", "하위분류코드가 존재합니다. 삭제하시겠습니까?", function(btn) {
					if(btn == 'yes'){
						store.remove(sm.getSelection());
						if (store.getCount() > 0) {
							sm.select(0);
						}
					}
				});
			} else {
				store.remove(sm.getSelection());
				if (store.getCount() > 0) {
					sm.select(0);
				}
			}*/
		}
	}, {
		text: '저장',
		width: 60,
		handler: function() {
			if(fn_chkGridAllowBlank(store, {CL_NM:'분류명'})) return;
			if(fn_chkGridAllowBlank(store, {DC:'설명'})) return;

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