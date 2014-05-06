# basicContext

Easy-to-use context-menu for your website or webapp.

![Context Screenshot](http://l.electerious.com/uploads/big/9f182a325203b158e59ad48aaebb13a2.png)

## Installation

	bower install basicContext
	
## Requirements

basicContext requires jQuery >= 2.1.0
	
## How to use

Simply include the following files in your HTML:

```html
<link type="text/css" rel="stylesheet" href="bower_components/basicContext/dist/basicContext.min.css">
<script async type="text/javascript" src="bower_components/jQuery/dist/jquery.min.js"></script>
<script async type="text/javascript" src="bower_components/basicContext/dist/basicContext.min.js"></script>
```

Show a context-menu by using the following command:

```coffee
items: [
		{ type: 'item', title: 'Add Sites', icon: 'ion-plus-round', fn: -> settings.addSites() }
		{ type: 'item', title: 'Reset Login', icon: 'ion-person', fn: -> login.reset() }
		{ type: 'item', title: 'Help', icon: 'ion-help-buoy', fn: -> settings.help() }
		{ type: 'item', title: 'Logout', icon: 'ion-log-out', fn: -> ackee.logout() }
	]

context.show items, e
```