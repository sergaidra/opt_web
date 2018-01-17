var formSave = Ext.create('Ext.form.Panel', {});

function fn_search() {
	store.proxy.extraParams = Ext.getCmp('form-cond').getForm().getValues();
	store.load();
}

function fn_getByteLength(s) {
	var b, i, c;
	for(b=i=0;c=s.charCodeAt(i++);b+=c>>11?2:c>>7?2:1); return b;
}

//sDiv I:신규, U:수정
function fn_save(sDiv) {
	var sUrl = '../insertHotdeal/';
	if(sDiv == 'U') sUrl = '../updateHotdeal/';

	if(!Ext.getCmp('form-reg-kwrd').getValue()) {
		Ext.Msg.alert('알림', '키워드는 필수입력입니다.', function(){Ext.getCmp('form-reg-kwrd').focus();});
		return;
	}
	
	if(fn_getByteLength(Ext.getCmp('form-reg-kwrd').getValue()) > 100) {
		Ext.Msg.alert('알림', '입력 글자수(한글기준 50자)를 초과하였습니다.', function(){Ext.getCmp('form-reg-kwrd').focus();});
		return;
	}
	
	if(sDiv == 'I') {
		if(!Ext.getCmp('form-reg-attach-flie-l').getValue()) {
			Ext.Msg.alert('알림', '업로드할 파일(png,jpg)을 선택하십시오.', function(){Ext.getCmp('form-reg-attach-flie-l').focus();});
			return;
		}
		if(!Ext.getCmp('form-reg-attach-flie-s').getValue()) {
			Ext.Msg.alert('알림', '업로드할 파일(png,jpg)을 선택하십시오.', function(){Ext.getCmp('form-reg-attach-flie-s').focus();});
			return;
		}
	}
	
	Ext.Msg.show({
		title:'확인',
		msg: '저장하시겠습니까?',
		buttons: Ext.Msg.YESNO,
		icon: Ext.Msg.QUESTION,
		fn: function(btn){
			if(btn == 'yes'){
				frReg.getForm().submit({
					waitMsg: '저장중입니다...',
					url: sUrl,
					success: function(form, action) {
						Ext.Msg.alert('알림', action.result.message, function(){
							store.reload();
							istore.removeAll();
							frReg.getForm().reset();
						});
					},
					failure: function(form, action) {
						if(action.result.message) {
							Ext.Msg.alert('알림', action.result.message);
						} else {
							Ext.Msg.alert('알림', '저장 중 오류가 발생하였습니다. 다시 시도하여 주십시오.');
						}
					}
				});
			}
		 }
	});
}

Ext.define('HotInfo', {
	extend: 'Ext.data.Model',
	fields: ['HOTDEAL_SN', 'KWRD', 'SORT_ORDR', 'FILE_CODE_L', 'FILE_CODE_S', 'FILE_URL_L', 'FILE_URL_S', 'FILE_NM_L', 'FILE_NM_S', 'USE_AT', 'REGIST_DT', 'UPDT_DT']
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
	height: 50,
	items: [{
		xtype: 'fieldset',
		title: '검색조건',
		//padding: '10 20 10 10',
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
				margin: '0 0 0 7',
				text: '조회',
				width: 60,
				listeners: {
					click: function() {
						fn_search();
					}
				}
			}]
		}]
	}]
});

var store = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'HotInfo',
	proxy: {
		type: 'ajax',
		url: '../selectHotdealList/',
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
	hegiht: 220,
	padding: '5 0 0 0',
	style: {
		backgroundColor: '#FFFFFF'
	},
	store: store,
	columns: [{
		text: '순번',
    	xtype: 'rownumberer',
    	align: 'center',
    	width: 50
	}, {
		text: '키워드',
		width: 300,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 6, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'KWRD'
	},{
		text: '큰 이미지 ',
		width: 170,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: false, maxLength: 10, enforceMaxLength: true, fieldStyle: {'ime-mode':'active'}},
		dataIndex: 'FILE_NM_L'
	},{
		text: '작은 이미지',
		width: 170,
		style: 'text-align:center',
		align: 'left',
		editor: {xtype:'textfield', allowBlank: true, maxLength: 20, enforceMaxLength: true, fieldStyle: {'ime-mode':'disabled'}},
		dataIndex: 'FILE_NM_S'
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
	listeners: {
		itemdblclick: function(grid, record, item, index, e, eOpts ) {
			frReg.getForm().loadRecord(record);
			istore.load({params:{HOTDEAL_SN:record.data.HOTDEAL_SN}});
		}
	}
});

var frReg = Ext.create('Ext.form.Panel', {
	title: '등록정보',
	id: 'form-reg',
	width: 600,
	border: true,
	//region: 'south',
	autoScroll: true,
	padding: '5 0 0 0',
	tbar: ['->', {
		xtype: 'button',
		id: 'btn-new',
		text: '신규',
		width: 60,
		handler: function() {
			istore.removeAll();
			Ext.getCmp('form-reg').getForm().reset();
		}
	}, {
		xtype: 'button',
		id: 'btn-save',
		text: '저장',
		width: 60,
		handler: function() {
			if(Ext.getCmp('form-reg-hotdeal-sn').getValue()) {
				fn_save('U');
			} else {
				fn_save('I');
			}
		}
	}],
	items: [{
		xtype: 'fieldset',
		border: false,
		//title: '<span style="font-weight:bold;">상품 기타 정보</span>',
		padding: '5 0 0 10',
		items: [{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'textfield',
				id: 'form-reg-kwrd',
				name: 'KWRD',
				fieldLabel: '키워드',
				fieldStyle: {'ime-mode':'active'},
				labelSeparator: ':',
				labelWidth: 80,
				labelAlign: 'right',
				width: 550,
				maxLength: 100,
				enforceMaxLength: true,
				allowBlank: false,
				enableKeyEvents: true,
				emptyText: '쉼표(,)로 구분하여 입력하세요.'
			}, {
				xtype: 'hiddenfield',
				id: 'form-reg-hotdeal-sn',
				name: 'HOTDEAL_SN'
			}, {
				xtype: 'hiddenfield',
				id: 'form-reg-file-code-l',
				name: 'FILE_CODE_L'
			}, {
				xtype: 'hiddenfield',
				id: 'form-reg-file-code-s',
				name: 'FILE_CODE_S'					
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'filefield',
				id: 'form-reg-attach-flie-l',
				name: 'ATTACH_FLIE_L',
				regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
				regexText: '이지미 파일을 선택하세요.',
				buttonText: '파일찾기',
				fieldLabel: '큰이미지',
				labelAlign: 'right',
				labelSeparator: ':',
				labelWidth: 80,
				allowBlank: true,
				emptyText : '파일크기 592 * 308',
				width: 550
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'filefield',
				id: 'form-reg-attach-flie-s',
				name: 'ATTACH_FLIE_S',
				regex: /^.*\.(BMP|GIF|JPG|JPEG|PNG|bmp|gif|jpg|jpeg|png)$/,
				regexText: '이지미 파일을 선택하세요.',
				buttonText: '파일찾기',
				fieldLabel: '작은이미지',
				labelAlign: 'right',
				labelSeparator: ':',
				labelWidth: 80,
				emptyText : '파일크기 287 * 308',
				allowBlank: true,
				width: 550
			}]
		},{
			xtype: 'fieldcontainer',
			layout: 'hbox',
			items: [{
				xtype: 'radiogroup',
				id: 'form-reg-use-at',
				fieldLabel: '사용여부',
				labelWidth: 80,
				labelAlign: 'right',
				border: false,
				width: 250,
				items: [{ boxLabel: '사용', id:'radio-use-at-y', name: 'USE_AT', inputValue:'Y', checked: true },
						{ boxLabel: '사용안함', id:'radio-use-at-n', name: 'USE_AT', inputValue:'N'}]
			}, {
				xtype: 'numberfield',
				id: 'form-reg-sort-ordr',
				name: 'SORT_ORDR',
				fieldLabel: '메인순서',
				labelWidth: 80,
				labelAlign: 'right',
				width: 250,
				value: 1,
				step: 1,
				minValue: 1,
				maxValue: 99
			}]
		}]
	}]
});

var istore = Ext.create('Ext.data.JsonStore', {
	autoLoad: false,
	model: 'HotInfo',
	proxy: {
		type: 'ajax',
		url: '../selectHotdealInfo/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	} 
});

var imageTpl = new Ext.XTemplate(
	 '<div class="thumb-wrap">'
	,'<table>'
	,'<tpl for=".">'	
	,'<tr>'
	,'<td>큰이미지<br><img src="{FILE_URL_L}" width="414" height="215"/></td>'
	,'<td>작은이미지<br><img src="{FILE_URL_S}" width="201" height="215"/></td>'
	,'</tr>'
	,'</tpl>'	
	,'</table>'
	,'</div>'
);

var imageView = Ext.create('Ext.view.View', {
    store: istore,
    tpl: imageTpl,
    height: 250,
    itemSelector: 'div.thumb-wrap',
    emptyText: '&nbsp;&nbsp;&nbsp;&nbsp;이미지가 없습니다.<br>&nbsp;&nbsp;&nbsp;'
});

var imagePanel = Ext.create('Ext.panel.Panel', {
	title: '이미지 미리보기',
	//region: 'center',
	autoScroll: true,
	flex: 1,
	//height: 300,
	border: true,
	//flex: 1,
	//layout: 'border',
	padding : '5 0 0 5',
	style: {
		backgroundColor: '#FFFFFF'
	},
	items: [imageView]
})

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'north',
			height: 265,
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frCond, grid]
		}), Ext.create('Ext.panel.Panel',{
			layout: 'hbox',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF'
			},
			items: [frReg, imagePanel]
		})]
	});

	store.load({params:{USE_AT:'Y'}});
});