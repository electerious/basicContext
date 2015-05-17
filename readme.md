# basicContext

Easy-to-use context-menu for your website or webapp. [Try it live on CodePen](http://codepen.io/electerious/pen/emaJxE).

![Context Screenshot](http://l.electerious.com/uploads/big/9f182a325203b158e59ad48aaebb13a2.png)

## Installation

	bower install basicContext
	
## Requirements

basicContext is written in Vanilla JS and has no dependencies.
	
## How to use

Simply include the following files in your HTML:

```html
<link type="text/css" rel="stylesheet" href="bower_components/basicContext/dist/basicContext.min.css">
<script async type="text/javascript" src="bower_components/basicContext/dist/basicContext.min.js"></script>
```

Show a context-menu by using the following command:

```js
var items = [
	{ type: 'item', title: 'Add Sites', icon: 'ion-plus-round', fn: function() {} },
	{ type: 'item', title: 'Reset Login', icon: 'ion-person', fn: function() {} },
	{ type: 'item', title: 'Help', icon: 'ion-help-buoy', fn: function() {} },
	{ type: 'separator' },
	{ type: 'item', title: 'Logout', icon: 'ion-log-out', fn: function() {} }
]

basicContext.show(items, e)
```