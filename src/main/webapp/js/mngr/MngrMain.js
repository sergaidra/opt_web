function fn_open_menu(menuNo, menuNm, menuURL) {
	var dynamicPanelId = 'tab-iframe-' + menuNo;

	if (!menuURL)
		return;

	if(menuNo != '00201') {
		if (Ext.getCmp('center-panel').getComponent(dynamicPanelId) != null) {
			Ext.getCmp('center-panel').setActiveTab(dynamicPanelId);
			return;
		}
	} else {
		if (Ext.getCmp('center-panel').getComponent(dynamicPanelId) != null) {
			Ext.getCmp('center-panel').getComponent(dynamicPanelId).destroy();
		}
	}

	var dynamicPanel = new Ext.Component({
		id : dynamicPanelId,
		title : menuNm,
		closable : true,
		autoEl : {
			tag : 'iframe',
			style : 'height: 100%; width: 100%; border: none',
			src : menuURL
		},
		listeners: {
			beforedestroy: function (comp, opts) {
				Ext.get(comp.getId()).dom.src = 'about:blank';
			}
		}
	});
	
	Ext.getCmp('center-panel').add(dynamicPanel);
	Ext.getCmp('center-panel').setActiveTab(dynamicPanel.getId());
}

var storeTree = Ext.create('Ext.data.TreeStore', {
	autoLoad: true,
	fields: ['id', 'text', {name:'leaf', type: 'boolean'}, 'url'],
    root: {expanded: true, text: 'root', id: '00000'},
    proxy: {
        type: 'ajax',
        url: './selectMainMenuTree/?AUTHOR_CL='+ssAuthorCl,
        reader: {
            type: 'json',
            root: 'data'
        }
    }/*,
    listeners: {
    	load: function(store, records){
    		console.log(console.dir(store));
    	}
    }*/
});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));

	Ext.create('Ext.Viewport', {
		id : 'border-example',
		layout : 'border',
		style: {
			//backgroundColor: '#c6c6c6'
		},
		items : [{
			xtype: 'component',
			region : 'north',
			margins : '3 3 0 3',
			style: {
				//background: '#fff url(/images/main/body_bg.gif) repeat-x 0 0'
			},
			contentEl : 'north'
		},{
			xtype: 'treepanel',
			id: 'menu-panel',
			title: '메뉴',
		    region: 'west',
		    border: false,
		    split : true,
			margins : '0 0 3 3',
			minWidth : 175,
			maxWidth : 400,
			width: 250,
			collapsible : true,
			animCollapse : true,
		    store: storeTree,
		    collapseFirst  : true,
		    rootVisible: false,
		    listeners: {
		    	itemclick: function(tree, record, index, eOpts) {
					fn_open_menu(record.get('id'), record.get('text'), record.get('url'));
					console.log('['+record.get('id')+']['+record.get('text')+']['+record.get('url')+']');
		    	}
			}
		},{
			xtype: 'tabpanel',
			id : 'center-panel',
			region : 'center',
			deferredRender : false,
			activeTab : 0,
			margins : '0 3 3 0',
			tabPosition: 'top', //'bottom',
			items : [{
				id : 'tab-main-tab',
				contentEl : 'center',
				title : 'Home',
				border : false,
				autoScroll : true
			}]
		}]
	});

	Ext.getCmp('menu-panel').expandAll();
});