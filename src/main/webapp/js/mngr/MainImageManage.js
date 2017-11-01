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
	height: 110,
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
		    		buttonText: '파일찾기',
		    		fieldLabel: '파일선택',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 70,
		    		allowBlank: false,
		    		width: 465
				}]
			}, {
				xtype: 'fieldcontainer',
				layout: 'hbox',
				items: [{
					xtype: 'datefield',
					id: 'form-begin-de',
		    		name: 'BEGIN_DE',
		    		fieldLabel: '시작일자',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 70,
		    		allowBlank: false,
		    		width: 200,
		    		format: 'Y-m-d',
		    		altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
		    		autoCreate: { tag: 'input', type: 'text', maxLength: '10' },
		    		style: { 'ime-mode': 'disabled' },
		    		maskRe: /[0-9]/,
		    		maxLength: 10,
		    		enforceMaxLength: true,
		    		selectOnFocus: true,
					listeners:{
						'keyup': function(tf, e) {
							var dt = tf.getRawValue().replace(/-/gi,'');
							if(dt.length == 8){
								if(e.getKey() != 13 && e.getKey() != 39 && e.getKey() != 37 && e.getKey() != 8 && e.getKey() != e.TAB){
									tf.setValue(fn_renderDate(dt));
									Ext.getCmp('form-sch-to-date').focus();
								}
							}
						}						
					}
				},{					
					xtype: 'datefield',
		    		name: 'END_DE',
		    		id: 'form-end-de',
		    		fieldLabel: '종료일자',
		    		labelAlign: 'right',
		    		labelSeparator: ':',
		    		labelWidth: 65,
		    		allowBlank: false,
		    		width: 195,
		    		format: 'Y-m-d',
		    		altFormats: 'Y-m-d|Y.m.d|Y/m/d|Ymd',
		    		autoCreate: { tag: 'input', type: 'text', maxLength: '10' },
		    		style: { 'ime-mode': 'disabled' },
		    		maskRe: /[0-9]/,
		    		maxLength: 10,
		    		enforceMaxLength: true,
		    		selectOnFocus: true,
					listeners:{
						'keyup': function(tf, e) {
							var dt = tf.getRawValue().replace(/-/gi,'');
							if(dt.length == 8){
								if(e.getKey() != 13 && e.getKey() != 39 && e.getKey() != 37 && e.getKey() != 8 && e.getKey() != e.TAB){
									tf.setValue(fn_renderDate(dt));
								}
							}
						}						
					}
				},{
					xtype: 'button',
					id: 'btn-insert',
					text: '저장',
					width: 66,
					margin: '0 0 0 4',
					listeners: {
						click: function (btn, e, opts) {
							var form = Ext.getCmp('form-file').getForm();
							if (form.isValid()) {
								form.submit({
									timeout: 30*60*1000,
									waitMsg: '잠시만 기다려주십시오...',
									url: '../insertMainImage/',
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
Ext.define('MainImageInfo', {
	extend: 'Ext.data.Model',
	fields: [ {name:'IMAGE_SN', type:'string'}
			, {name:'IMAGE_NM', type:'string'}
			, {name:'IMAGE_NM_SHORT', type:'string'}
			, {name:'IMAGE_PATH', type:'string'}
			, {name:'IMAGE_SIZE', type:'string'}
			, {name:'SORT_ORDR', type:'string'}
			, {name:'BEGIN_DE', type:'string'}
			, {name:'END_DE', type:'string'}
			, {name:'IMAGE_URL', type:'string'}
			, {name:'USE_AT', type:'string'}
			, {name:'CF_ING', type:'string'}
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
    	text: '순번',
    	width: '50',
    	align: 'center',
    	xtype: 'rownumberer'
	},{
		text: '이미지명',
		flex: 1,
		minWidth: 170,		
		style: 'text-align:center',
		sortable: false,
		menuDisabled: true,
		dataIndex: 'IMAGE_NM'
	},{
		text: '시작일자',
		width: 110,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'BEGIN_DE'
	},{
		text: '종료일자',
		width: 110,
		align: 'center',
		sortable: false,
		menuDisabled: true,
		renderer: Ext.util.Format.dateRenderer('Y-m-d'),    //, autoCreate		: { tag: 'input', type: 'text', maxLength: '10' },
		editor: {xtype:'datefield', format: 'Y-m-d', maskRe: /[0-9]/, maxLength: 10, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/, enforceMaxLength: true},
		dataIndex: 'END_DE'
	},{
		text: '메인',
		width: 60,
		align: 'center',
		dataIndex: 'CF_ING',
		renderer: function(value, metaData, record) {
			if(record.data.USE_AT == 'Y') {
				if(value == 'A') return '<font color="red">노출중</font>'
				else if(value == 'B') return '<font color="blue">예정</font>'
				else if(value == 'C') return '지남'	
			} else {
				if(value == 'A') return '노출중'
				else if(value == 'B') return '예정'
				else if(value == 'C') return '지남'	
			}
			
		}
	},{
		text: '사용여부',
		width: 80,
		align: 'center',
		editor: comboUseAt,
		dataIndex: 'USE_AT',
		renderer: Ext.ux.comboBoxRenderer(comboUseAt)
	},{
		text: '순서',
		width: 60,
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
    	xtype: 'radiogroup',
    	id: 'use-at-file',
    	fieldLabel: '사용여부',
    	labelWidth: 60,
    	labelAlign: 'right',
    	border: false,
    	width: 180,
    	items: [{ boxLabel: '전체', id:'use-at-all', name: 'USE_AT', inputValue:''},
    			{ boxLabel: '사용', id:'use-at-y', name: 'USE_AT', inputValue:'Y', checked: true }],
    	listeners: {
    		change : function(radio, newValue, oldValue, eOpts ) {
    			Ext.getCmp('btn-sch-file').fireEvent('click');
    		}
    	}
	}, {
		text: '조회',
		id: 'btn-sch-file',
		width: 60,
		listeners: {
			click: function() {
				storeFile.load({params:{USE_AT:Ext.getCmp('use-at-file').getValue().USE_AT}});
			}
		}
	}, {
		text: '저장',
		id: 'btn-save-file',
		width: 60,
		handler: function() {
			var datas = new Array();

			var modified = storeFile.getUpdatedRecords();

			if (modified.length > 0) {
				for (var i = 0; i < modified.length; i++) {
					modified[i].set('CRUD', 'U');
					var str  = modified[i].data.BEGIN_DE;
					var str2 = modified[i].data.END_DE;
					var dt  = new Date(str);
					var dt2 = new Date(str2);

					modified[i].set('BEGIN_DE', Ext.Date.format(dt, 'Y-m-d'));
					modified[i].set('END_DE', Ext.Date.format(dt2, 'Y-m-d'));
					
					datas.push(modified[i].data);
				}

				formSave.getForm().submit({
					waitMsg: '저장중입니다...',
					url: '../saveMainImage/',
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
	,'<td width="20%"><img src="{IMAGE_URL}"/><br>'
	,'<tpl if="USE_AT == \'Y\'">'
	,'<tpl if="CF_ING == \'A\'">'
	,'<font color="red">{[xindex]}.{IMAGE_NM_SHORT}</font>'
	,'</tpl>'
	,'<tpl if="CF_ING == \'B\'">'
	,'<font color="blue">{[xindex]}.{IMAGE_NM_SHORT}</font>'
	,'</tpl>'
	,'<tpl if="CF_ING == \'C\'">'
	,'{[xindex]}.{IMAGE_NM_SHORT}'
	,'</tpl>'	
	,'</tpl>'	
	,'<tpl if="USE_AT == \'N\'">'
	,'{[xindex]}.{IMAGE_NM_SHORT}'
	,'</tpl>'
	, '</td>'
	,'{[xindex % 5 == 0 ? "</tr>" : ""]}'
	,'</tpl>'
	,'</table>'
	,'</div>'
);
//Ext.util.Format.substr(str,0,5)
/*
var imageTpl = new Ext.XTemplate(
	 '<div class="thumb-wrap" style="margin-bottom: 10px;">'
     ,'<tpl for=".">'
     ,'<img src="{IMAGE_URL}" title="{[xindex]}.{IMAGE_NM}"/>'
     ,'</tpl>'
	,'</div>'
);
*/
var imageView = Ext.create('Ext.view.View', {
    store: storeFile,
    tpl: imageTpl,
    itemSelector: 'div.thumb-wrap',
    emptyText: '&nbsp;&nbsp;&nbsp;&nbsp;이미지가 없습니다.<br>&nbsp;&nbsp;&nbsp;'
});

var imagePanel = new Ext.create('Ext.panel.Panel', {
	id: 'panel-image',
	//width: 600,
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
			//width: 580,
			flex: 1,
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frFile, gridFile]
		}), Ext.create('Ext.panel.Panel', {
			title: '이미지 미리보기',
	    	region: 'center',
	    	autoScroll: true,
	    	width: 550,
	    	//flex: 1,
			//layout: 'border',
	    	padding : '5 5 5 5',
	    	style: {
				backgroundColor: '#FFFFFF'
			},
	    	items: [imagePanel]
	    })]
	});
	
	Ext.getCmp('btn-sch-file').fireEvent('click');
});

