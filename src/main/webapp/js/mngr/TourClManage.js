var formSave = Ext.create('Ext.form.Panel', {});

var storeTree = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}, 'stayng_fclty_at'],
    root: {text: '전체', id: '00000', leaf: false},
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
			store.proxy.extraParams = {UPPER_CL_CODE:record.data.id};
        	store.load();
    	},
    	afterrender: function(tree, eOpts ) {
    		// TODO LKH 첫번째 노드를 클릭하는 이벤트 추가
    		//store.proxy.extraParams = {BOX_SN:tree.getRootNode().getChildAt(0).data.id};
        	//store.load();
    	}
	}
});

Ext.define('TourClInfo', {
    extend: 'Ext.data.Model',
    fields: ['CL_CODE', 'CL_NM', 'UPPER_CL_CODE', 'STAYNG_FCLTY_AT', 'SORT_ORDR', 'DELETE_AT', 'CRUD']
});

var combo = new Ext.create('Ext.form.ComboBox', {
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

var comboStayng = new Ext.create('Ext.form.ComboBox', {
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
        editor: {xtype:'textfield', allowBlank: false, maxLength: 5, fieldStyle: {'ime-mode':'active'}},
        dataIndex: 'CL_CODE'
    },{
        text: '분류명',
        width: 200,
        style: 'text-align:center',
        align: 'left',
        editor: {xtype:'textfield', allowBlank: true, maxLength: 25, fieldStyle: {'ime-mode':'active'}},
        dataIndex: 'CL_NM'
    },{
        text: '숙박시설여부',
        width: 100,
        align: 'center',
        editor: combo,
        dataIndex: 'STAYNG_FCLTY_AT',
        renderer: Ext.ux.comboBoxRenderer(comboStayng)        	
    },{
        text: '정렬순서',
        width: 100,
        align: 'center',
        editor: {xtype:'textfield', allowBlank: true, maxLength: 2, fieldStyle: {'ime-mode':'disabled'}, maskRe: /[0-9]/},
        dataIndex: 'SORT_ORDR'     
    },{
        text: '사용여부',
        width: 100,
        align: 'center',
        editor: combo,
        dataIndex: 'DELETE_AT',
        renderer: Ext.ux.comboBoxRenderer(combo)
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
        text: '추가',
        handler : function() {
    		var treeItem = tree.getSelectionModel().getLastSelected();

    		if (!treeItem){
				Ext.Msg.alert("알림", "상위분류를 선택하십시오.");
				return;
    		}
        	
        	var idx = store.getCount();
            var r = Ext.create('TourClInfo', {
            	CL_CODE : '', 
            	CL_NM : '', 
            	UPPER_CL_CODE : treeItem.get('id'), 
            	STAYNG_FCLTY_AT : treeItem.get('stayng_fclty_at'), 
            	SORT_ORDR : '', 
            	DELETE_AT : 'N', 
            	CRUD : 'I'
            });
            store.insert(idx, r);
            cellEditing.startEditByPosition({row: idx, column: 0});
        }
    }, {
        text: '삭제',
        handler: function() {
            var sm = grid.getSelectionModel();
            if(sm.getSelection()[0].data.CF_ITEM_CNT != '0') {
            	Ext.MessageBox.confirm("확인", "해당 보관함에 컨텐츠가 존재합니다. 삭제하시겠습니까?", function(btn) {
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
            }
        }
    }, {
        text: '저장',
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
		padding:'0 0 0 0',
		style: {
			backgroundColor: '#FFFFFF'
		},
		items: [tree, grid]
	});
});