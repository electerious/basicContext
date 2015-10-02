# basicContext

Easy-to-use context-menu for your website or web-app.

<img src="http://l.electerious.com/uploads/big/36cc8c250d72a11f92df380595260c37.png" width="257" />

## Contents

- [Demos](#demos)
- [Features](#features)
- [Requirements](#requirements)
- [Setup](#setup)
- [How to use](#how-to-use)
	- [Vanilla JS](#vanilla-js)
	- [jQuery](#jquery)
- [Themes](#themes)
- [Addons](#addons)

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
- Layout and theme are separated CSS-files. This makes it easy to style our own context.
- Stays within the viewport and never opens outside the visible screen-area ([Demo](http://codepen.io/electerious/pen/GJqrZN))
- Scrollable, when the height of the context-menu is bigger than the height of the browser ([Demo](http://codepen.io/electerious/pen/aOZpZr))

## Requirements

basicContext is written in Vanilla JS and only dependents on the following browser APIs:

- [classList](http://caniuse.com/#feat=classlist)

All of these APIs are capable of being polyfilled in older browser. Check the linked resources above to determine if you must polyfill to achieve your desired level of browser support.

## Setup

We recommend to install basicContext using [Bower](http://bower.io/) or [npm](https://npmjs.com).

```sh
bower install basicContext
```
```sh
npm install basiccontext
```

Include the CSS-files in the `head` and the JS-file at the end of your `body`:

```html
<link rel="stylesheet" href="dist/basicContext.min.css">
<link rel="stylesheet" href="dist/themes/default.min.css">
```
```html
<script src="dist/basicContext.min.js"></script>
```

Skip the JS-file if you want to use basicContext as module together with [Browserify](http://browserify.org):

```js
let basicContext = require('basiccontext')
```

## How to use

### Vanilla JS

Show a context-menu by using the following command:

```js
document.querySelector('.btn').addEventListener('click', function(e) {

	let items = [
		{ title: 'Add Sites', icon: 'ion-plus-round', fn: clicked },
		{ title: 'Reset Login', icon: 'ion-person', fn: clicked },
		{ title: 'Help', icon: 'ion-help-buoy', fn: clicked },
		{ title: 'Disabled', icon: 'ion-minus-circled', fn: clicked, disabled: true },
		{ title: 'Invisible', icon: 'ion-eye-disabled', fn: clicked, visible: false },
		{ },
		{ title: 'Logout', icon: 'ion-log-out', fn: clicked }
	]

	basicContext.show(items, e)

})
```

### jQuery

basicContext doesn't work properly with the normalized jQuery [Event Object](http://api.jquery.com/category/events/event-object/), but you can easily bypass this issue using `e.originalEvent`:

```js
$('.btn').on('click', function(e) {

	let items = [
		{ title: 'Add Sites', icon: 'ion-plus-round', fn: clicked },
		{ title: 'Reset Login', icon: 'ion-person', fn: clicked },
		{ title: 'Help', icon: 'ion-help-buoy', fn: clicked },
		{ title: 'Disabled', icon: 'ion-minus-circled', fn: clicked, disabled: true },
		{ title: 'Invisible', icon: 'ion-eye-disabled', fn: clicked, visible: false },
		{ },
		{ title: 'Logout', icon: 'ion-log-out', fn: clicked }
	]

	basicContext.show(items, e.originalEvent)

})
```

## Themes

Layout and theme are separated CSS-files. This makes it easy to style your own context or to choose from the included themes.

| Name | Preview | CSS-File | Demo |
|:-----------|:------------|:------------|:------------|
| Default theme | <img src="http://l.electerious.com/uploads/big/36cc8c250d72a11f92df380595260c37.png" width="257" /> | [CSS-File](dist/themes/default.min.css) | [Demo](demos/themes/default.html) |
| Bright theme | <img src="http://l.electerious.com/uploads/big/f337c41832ac37cd49c3bd6898b85d5e.png" width="257" /> | [CSS-File](dist/themes/bright.min.css) | [Demo](demos/themes/bright.html) |
| Dark theme | <img src="http://l.electerious.com/uploads/big/f0cc0ba23effc0443f367ca63dd1e72f.png" width="257" /> | [CSS-File](dist/themes/dark.min.css) | [Demo](demos/themes/dark.html) |

## Addons

Include the following CSS-files to enhance the look and functionality of your contexts.

| Name | Preview | CSS-File | Demo |
|:-----------|:------------|:------------|:------------|
| PopIn effect | <img src="http://l.electerious.com/uploads/big/c506f4fedb8a4df691d276d6abdb75f7.gif" width="257" /> | [CSS-File](dist/addons/popin.min.css) | [Demo](demos/addons/popIn.html) |
| FadeIn effect | <img src="http://l.electerious.com/uploads/big/1b98e17f1af051753a958c18953adbd5.gif" width="257" /> | [CSS-File](dist/addons/fadein.min.css) | [Demo](demos/addons/fadeIn.html) |
