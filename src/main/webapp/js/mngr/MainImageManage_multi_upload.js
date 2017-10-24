var formSave = Ext.create('Ext.form.Panel', {});

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
	editable: false,
	emptyText: '선택'
});

/*
 * 이미지등록 form 화면
 */
var frFile = Ext.create('Ext.form.Panel', {
	//title: '상품정보입력',
	id: 'form-file',
	region: 'north',
	height: 80,
	//autoScroll: true,
	items: [{
		xtype: 'fieldcontainer',
		layout: 'hbox',
		items: [{
			xtype: 'fieldset',
			title: '<span style="font-weight:bold;">이미지 등록</span>',
			padding: '10 20 10 10',
			items: [{
				xtype: 'fieldcontainer',
				layout: 'hbox',
				items: [{
					xtype: 'filefield',
		    		name: 'ATTACH_FLIE',
		    		regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
		    		regexText: '이지미 파일을 선택하세요.',
		    		buttonText: '찾기...',
		    		fieldLabel: '파일선택',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 70,
		    		allowBlank: false,
		    		width: 500,
					listeners:{
						afterrender : function(ff, eOpts ){
							//파일태그옵션에 multiple이라는 옵션을 정의
							ff.fileInputEl.set({
								multiple:'multiple'
							});
						},
					}
				},{
					xtype: 'button',
					id: 'btn-upload-file',
					text: '업로드',
					width: 60,
					margin: '0 0 0 5',
					listeners: {
						click: function (btn, e, opts) {
							var form = Ext.getCmp('form-file').getForm();
							if (form.isValid()) {
								form.submit({
									timeout: 30*60*1000,
									waitMsg: '잠시만 기다려주십시오...',
									url: '../uploadMainImages/',
									method: 'POST',
									success: function(form, action) {
										Ext.Msg.alert('알림', '저장되었습니다.', function(){
											storeFile.load();
											frFile.down("filefield").fileInputEl.set({
												multiple:'multiple'
											});
										});
									},
									failure: function(form, action) {
										fn_failureMessage(action.response);
									}
								});
							} else {
								//console.log('is not valid');
								Ext.Msg.alert('확인', '업로드할 파일(png,jpg)을 선택하십시오.');
							}
						}
					}
				}]
			}]
		}]
	}]
});

/*
 * 이미지목록 grid
 */
Ext.define('GoodsFileInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'IMAGE_SN', type:'string'}
			, {name:'IMAGE_NM', type:'string'}
			, {name:'IMAGE_PATH', type:'string'}
			, {name:'IMAGE_SIZE', type:'string'}
			, {name:'SORT_ORDR', type:'string'}
			, {name:'BEGIN_DE', type:'string'}
			, {name:'END_DE', type:'string'}
			, {name:'USE_AT', type:'string'}
			, {name:'CRUD', type:'string'}]
});

var storeFile = Ext.create('Ext.data.JsonStore', {
	//autoLoad: true,
	//pageSize: 100,
	model: 'MainImageInfo',
	proxy: {
		type: 'ajax',
		url: '../selectMainImageList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	},
	listeners: {
		load : function(st, records, successful, eOpts ) {
			//alert(st.getCount());
		}
	}
});

var gridFile = Ext.create('Ext.grid.Panel', {
	//title: '이미지등록',
	id: 'grid-file',
	region:'center',
	store: storeFile,
	border: true,
	split : true,
	plugins: Ext.create('Ext.grid.plugin.CellEditing', {clicksToEdit: 1}),
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '이미지명',
		//width: 300,
		flex: 1,
		style: 'text-align:center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'IMAGE_NM'
	},{
		text: '시작일자',
		width: 150,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'BEGIN_DE'
	},{
		text: '종료일자',
		width: 150,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),    //, autoCreate		: { tag: 'input', type: 'text', maxLength: '10' },
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'END_DE'
	},{
		text: '사용여부',
		width: 100,
		align: 'center',
		editor: comboUseAt,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboUseAt)
	},{
		text: '정렬순서',
		width: 80,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		editor: {xtype:'textfield', allowBlank: false, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'SORT_ORDR'
	},{
		text: 'IMAGE_SN',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'IMAGE_SN'
	},{
		text: 'IMAGE_PATH',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'IMAGE_PATH'
	},{
		text: 'IMAGE_SIZE',
		hidden: true,
		width: 100,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'IMAGE_SIZE'
	}],
	tbar: [{
		text: '삭제',
		id: 'btn-del-file',
		width: 60,
		margin: '0 5 0 10',
		handler: function() {
			var sm = gridFile.getSelectionModel();
			storeFile.remove(sm.getSelection());
			/*if (storeFile.getCount() > 0) {
				sm.select(0);
			}*/
		}
	}, {
		text: '저장',
		id: 'btn-save-file',
		width: 60,
		handler: function() {
			var datas = new Array();

			var inserted = storeFile.getNewRecords();
			var modified = storeFile.getUpdatedRecords();
			var deleted = storeFile.getRemovedRecords();

			if (modified.length + inserted.length + deleted.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					datas.push(modified[i].data);
				}

				for (var i = 0; i < deleted.length; i++) {
					deleted[i].set('CRUD', 'D');
					datas.push(deleted[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveGoodsFile/',
					params: {'data': Ext.JSON.encode(datas)},
					success: function(form, action) {
						Ext.Msg.alert('알림', '저장되었습니다.', function(){
							storeFile.load();
						});
					},
					failure: function(form, action) {
						fn_failureMessage(action.response);
					}
				});
			} else {
				alert('변경된 자료가 없습니다.');
			}
		}
	}]
});

var imageTpl = new Ext.XTemplate(
	 '<div class="thumb-wrap" style="margin-bottom: 10px;">'
	,'<table width="97%">'
	,'<tpl for=".">'
	,'{[xindex % 5 == 1 ? "<tr height=100 valign=top>" : ""]}'
	,'<td width="20%"><img src="{FILE_URL}"/><br>{[xindex]}.{FILE_NM}</td>'
	,'{[xindex % 5 == 0 ? "</tr>" : ""]}'
	,'</tpl>'
	,'</table>'
	,'</div>'
);

var imageView = Ext.create('Ext.view.View', {
    store: storeFile,
    tpl: imageTpl,
    itemSelector: 'div.thumb-wrap',
    emptyText: '&nbsp;&nbsp;&nbsp;&nbsp;이미지가 없습니다.<br>&nbsp;&nbsp;&nbsp;'
});

var imagePanel = new Ext.create('Ext.panel.Panel', {
	id: 'panel-image',
	//region: 'west',
	//layout: 'fit',
	//autoScroll: true,
	//width: '100%',
	border: true,
	///// padding: '5 5 0 0',
	style: {
		backgroundColor: '#FFFFFF'
	},
	items: [imageView]
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
			region: 'west',
			layout: 'border',
			flex: 0.6,
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frFile, gridFile]
		}), Ext.create('Ext.panel.Panel', {
			title: '이미지 미리보기',
	    	region: 'center',
	    	autoScroll: true,
	    	flex: 0.4,
			//layout: 'border',
	    	padding : '5 5 5 5',
	    	style: {
				backgroundColor: '#FFFFFF'
			},
	    	items: [imagePanel]
	    })]
	});
	
	storeFile.load();
});

