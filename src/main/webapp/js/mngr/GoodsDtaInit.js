var formSave = Ext.create('Ext.form.Panel', {});

Ext.define('DtaInitInfo', {
    extend: 'Ext.data.Model',
    fields: ['TABLE_NM', 'TABLE_DC', 'RECENT_INIT_DT', 'RECENT_INIT_NM']
});

var store = Ext.create('Ext.data.JsonStore', {
	autoLoad: true,
	//pageSize: 100,
	model: 'DtaInitInfo',
	proxy: {
		type: 'ajax',
		url: '../selectDtaInitList/',
		reader: {
			type: 'json',
			root: 'data',
			totalProperty: 'rows'
		}
	}
});

var grid = Ext.create('Ext.grid.Panel', {
//	title: '검색목록',
	region:'center',
	store: store,
	selModel: Ext.create('Ext.selection.CheckboxModel',{showHeaderCheckbox:true}),
	viewConfig: {
		emptyText: '등록된 자료가 없습니다.'
	},
	columns: [{
		text: '순번',
		width: 50,
		align: 'center',
		xtype: 'rownumberer'		
	},{
		text: '관련 테이블명',
		width: 200,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'TABLE_NM'
	},{
		text: '테이블 설명',
		width: 150,
		style: 'text-align:center',
		align: 'left',
		dataIndex: 'TABLE_DC'
	},{
		text: '최근 작업일시',
		width: 150,
		align: 'center',
		dataIndex: 'RECENT_INIT_DT'
	},{
		text: '작업자',
		width: 120,
		align: 'center',
		dataIndex: 'RECENT_INIT_NM'
	},{
		flex: 1
	}],
	/*bbar: Ext.create('Ext.PagingToolbar', {
		store: store,
		displayInfo: true,
		displayMsg: 'Displaying topics {0} - {1} of {2}',
		emptyMsg: "No topics to display"
	}),*/
	tbar: ['->', {
		text: '자료삭제',
		margin: '0 10 0 10',
		width: 80,
		handler: function() {
			if(confirm('상품 관련 자료를 삭제처리 하시겠습니까?')) {
				var selections = grid.getSelectionModel().getSelection();
				
				if(!selections.length) {
					alert('선택된 항목이 없습니다.');
					return;
				}

				var codes = '';
				
	            for(var i = 0; i < selections.length; i++){
            		codes += ''+selections[i].get('TABLE_NM') + ',';
	            }
	            
	            if(codes) {
	            	Ext.Ajax.request({
	            		url:'../initGoodsDta/',
	            		method:'POST',
	            		timeout:360000,
	            		params: {
	            			'TABLE_NM_LIST':codes
	            		},
	            		success:function(response){
	            			var json = Ext.decode(response.responseText);
	            			if(json.success){
	            				Ext.Msg.alert('확인', '삭제 처리하였습니다.', function(){
	            					store.load();	
	            				});
	            			}else{
	            				fn_failureMessage(response);
	            			}
	            		},
	            		failure: function(response){
	            			fn_failureMessage(response);  
	            		}       
	            	});
	            }
			}
		}
	}]
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