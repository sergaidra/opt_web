var formSave = Ext.create('Ext.form.Panel', {});

function fnTreeCheck(node, checked) {
	node.eachChild(function(tNode) {
		if (tNode.isLeaf()) {
			tNode.set('checked', checked);
		} else {
			tNode.set('checked', checked);
			fnTreeCheck(tNode, checked);
		}
	});
}

function parentCheck(tree, node) {
	var path, parentKey, returnPlag = false;
	path = node.getPath();
	var key = path.split("/");
	if (key.length < 4)
		return;
	parentKey = key[key.length - 2];
	
	var parentNode = findNode(tree.getRootNode(), parentKey);
	parentNode.eachChild(function(eNode) {
		if (eNode.get('checked'))
			returnPlag = true;
	});
	
	parentNode.set('checked', returnPlag);
	parentCheck(tree, parentNode);
}

function findNode(node, nodeid) {
	var cs = node.childNodes, len = cs.length, i = 0, n;
	var res = '';
	for (; i < len; i++) {
		n = cs[i];
		if (n.get('id') == nodeid) {
			return n;
		} else {
			res = findNode(n, nodeid);
			if (res != '') {
				return res;
			}
		}
	}
	return res;
}
/*
var formCond = Ext.create('Ext.form.Panel', {
	id: 'form-cond',
	region: 'north',
	//height: 75,
	items: [{
		xtype: 'fieldset',
		//title: '검색조건',
		padding: '10 10 5 10',
		items: [{
			xtype: 'fieldcontainer',
			//layout: 'hbox',
			layout: {
			    type: 'hbox',
			    align: 'right'
			},
			items: [{
				xtype: 'button',
				margin: '0 0 0 5',
				text: '저장',
				width: 60,
				layout: {
					//type: 'hbox',
					align: 'right'
				},				
				handler: function(){
			    	var checkData = menuTree.getChecked();
			    	var treeItem = authTree.getSelectionModel().getLastSelected();

			        var jsonData = '[';
			        var menuNo;
			    	
			    	for(var i=0; i < checkData.length; i++){
			    		menuNo = checkData[i].get('id');
			    	    jsonData += '{"AUTHOR_CL":"' + treeItem.get('id') + '",' + '"MENU_CODE":"'+menuNo+'"},';
			    	}
			    	
			    	if(jsonData.length > 1){
			    		jsonData = jsonData.substring(0, jsonData.length-1)+ ']';	
			    	}else{
			    		jsonData = '[]';	
			    	}
			    	
			    	formSave.submit({
			          	waitMsg: '저장중입니다...',
			          	url: '../saveAuthorMenuInfo/',
			          	params: {'data': jsonData, 'AUTHOR_CL':treeItem.get('id')},
			    		success: function(form, action){
			                Ext.MessageBox.alert('저장', '저장 되었습니다.', function(){
			                	menuStore.load();
			                });
			          	},
			        	failure: function(form, action){
			    	    	Ext.MessageBox.alert('결과', '저장 중 오류가 발생하였습니다. 다시 시도 하여 주십시오.');
			        	}
			        });				
			    }
			}]
		}]
	}]
});
*/

var authStore = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}],
	proxy: {
		type: 'ajax',
		url: '../selectCmmnDetailCodeTree/?CODE_ID=COM001&USE_AT=Y',
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

var authTree = Ext.create('Ext.tree.Panel', {
	title: '권한분류',
	region: 'west',
	border: true,
	split : true,
	width: 250,
	//flex: 0.3,
	store: authStore,	
	collapsible: false,
	animCollapse: true,
	collapseFirst: true,
	rootVisible: false,
	listeners: {
		itemclick: function(tree, record, item, index, e, eOpts ) {
			menuStore.proxy.extraParams = {AUTHOR_CL:record.data.id};
			menuStore.load();
		}
	}
});

var menuStore = Ext.create('Ext.data.TreeStore', {
	autoLoad: false,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}, {name:'checked', type: 'boolean'}],
	root: {expanded: true, text: 'root', id: '00000'},
	proxy: {
        type: 'ajax',
        url: '../selectAuthorMenuTree/',
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

var menuTree = Ext.create('Ext.tree.Panel', {
	title: '메뉴목록',
	region: 'center',
	border: true,
	split: true,
	flex: 1,
	//width: 200,
    store: menuStore,	
	collapsible: false,
	animCollapse: true,
    collapseFirst: true,
    rootVisible: false,	
    dockedItems: [{
        xtype: 'toolbar',
        items: [{
            text: '메뉴펼치기',
            handler: function(){
            	menuTree.expandAll();
            }
        },{
            text: '메뉴접기',
            handler: function(){
            	menuTree.collapseAll();
            }
        }, '->',{ 
        	text : '권한메뉴저장', 
        	id : 'btn-save',
        	handler: function() {
		    	var checkData = menuTree.getChecked();
		    	var treeItem = authTree.getSelectionModel().getLastSelected();

		        var jsonData = '[';
		        var menuNo;
		    	
		    	for(var i=0; i < checkData.length; i++){
		    		menuNo = checkData[i].get('id');
		    	    jsonData += '{"AUTHOR_CL":"' + treeItem.get('id') + '",' + '"MENU_CODE":"'+menuNo+'"},';
		    	}
		    	
		    	if(jsonData.length > 1){
		    		jsonData = jsonData.substring(0, jsonData.length-1)+ ']';	
		    	}else{
		    		jsonData = '[]';	
		    	}
		    	
		    	formSave.submit({
		          	waitMsg: '저장중입니다...',
		          	url: '../saveAuthorMenuInfo/',
		          	params: {'data': jsonData, 'AUTHOR_CL':treeItem.get('id')},
		    		success: function(form, action){
		                Ext.MessageBox.alert('저장', '저장 되었습니다.', function(){
		                	menuStore.load();
		                });
		          	},
		        	failure: function(form, action){
		    	    	Ext.MessageBox.alert('결과', '저장 중 오류가 발생하였습니다. 다시 시도 하여 주십시오.');
		        	}
		        });	
        	}
        }]
    }],    
	listeners: {
    	checkchange: function(node, checked, eOpts ) {
 			if (!node.isLeaf()) {
 				fnTreeCheck(node, checked);
 			}else{
 				parentCheck(menuTree, node);
 			}
 		}
	}	
});

Ext.onReady(function(){
	Ext.create('Ext.Viewport', {
		layout: 'border',
		padding:'5 10 5 10',
		style: {
			backgroundColor: '#FFFFFF'
		},
		//items: [formCond, Ext.create('Ext.panel.Panel',{
		items: [Ext.create('Ext.panel.Panel',{
			layout: 'border',
			region: 'center',
			style: {
				backgroundColor: '#FFFFFF',
			},
			items: [authTree, menuTree]
		})]
	});
});

