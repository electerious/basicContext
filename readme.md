# basicContext

Easy-to-use context-menu for your website or web-app.

![Context Screenshot](http://l.electerious.com/uploads/big/9f182a325203b158e59ad48aaebb13a2.png)

## Demos

| Name | Description | Link |
|:-----------|:------------|:------------|
| Basic demo | basicContext works with all kind of events | [Try it on CodePen](http://codepen.io/electerious/pen/emaJxE) |
| Position demo | basicContext never leaves the visible screen-area | [Try it on CodePen](http://codepen.io/electerious/pen/GJqrZN) |
| Scroll demo | basicContext is scrollable when the context height is bigger than the browser height | [Try it on CodePen](http://codepen.io/electerious/pen/aOZpZr) |
| Custom close function demo | basicContext lets you define a custom close function | [Try it on CodePen](http://codepen.io/electerious/pen/MwpVdE) |
| Custom position demo | basicContext accepts an object with custom coordinates | [Try it on CodePen](http://codepen.io/electerious/pen/PqjMrN) |
| jQuery demo | Use basicContext with the jQuery [Event Object](http://api.jquery.com/category/events/event-object/) | [Demo](demos/jQuery.html) |

## Features

- Works in all modern browsers
- Written in Vanilla JS
- CommonJS and AMD support
- Stays within the viewport and never opens outside the visible screen-area ([Demo](http://codepen.io/electerious/pen/GJqrZN))
- Scrollable, when the height of the context-menu is bigger than the height of the browser ([Demo](http://codepen.io/electerious/pen/aOZpZr))

## Requirements

basicContext is written in Vanilla JS and only dependents on the following browser APIs:

- [classList](http://caniuse.com/#feat=classlist)

All of these APIs are capable of being polyfilled in older browser. Check the linked resources above to determine if you must polyfill to achieve your desired level of browser support.

## Installation

We recommend to install basicContext using [Bower](http://bower.io/) or [npm](https://npmjs.com).

	bower install basicContext
	npm install basiccontext
	
## How to use

Include the CSS file in the `head` and the JS file at the end of your `body`:

```html
<link rel="stylesheet" href="dist/basicContext.min.css">
<script src="dist/basicContext.min.js"></script>
```

Show a context-menu by using the following command:

```js
document.querySelector('.btn').addEventListener('click', function(e) {

	var items = [
		{ type: 'item', title: 'Add Sites', icon: 'ion-plus-round', fn: function() {} },
		{ type: 'item', title: 'Reset Login', icon: 'ion-person', fn: function() {} },
		{ type: 'item', title: 'Help', icon: 'ion-help-buoy', fn: function() {} },
		{ type: 'separator' },
		{ type: 'item', title: 'Logout', icon: 'ion-log-out', fn: function() {} }
	]

	basicContext.show(items, e)

})
```

## How to use with jQuery

basicContext doesn't work properly with the normalized jQuery [Event Object](http://api.jquery.com/category/events/event-object/), but you can easily bypass this issue using `e.originalEvent`:

```js
$('.btn').on('click', function(e) {

	var items = [
		{ type: 'item', title: 'Add Sites', icon: 'ion-plus-round', fn: function() {} },
		{ type: 'item', title: 'Reset Login', icon: 'ion-person', fn: function() {} },
		{ type: 'item', title: 'Help', icon: 'ion-help-buoy', fn: function() {} },
		{ type: 'separator' },
		{ type: 'item', title: 'Logout', icon: 'ion-log-out', fn: function() {} }
	]

	basicContext.show(items, e.originalEvent)

})
```