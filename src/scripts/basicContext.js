window.basicContext = {

	_overflow: null,

	_dom(elem = '') {

		return document.querySelector('.basicContext ' + elem)

	},

	_valid(data = {}) {

		if (data.class==null)	data.class = ''
		if (data.type==null)	data.type = 'item'
		if (data.icon==null)	data.icon = null
		if (data.title==null)	data.title = 'Undefined'

		if (data.fn==null && data.type!== 'separator') {

			console.warn(`Missing fn for item '${ data.title }'`)
			return false

		}

		return true

	},

	_build(data) {

		var num		= 0,
			context	= '',
			item

		item = function(row) {

			var html = '',
				span = ''

			// Parse and validate data
			if (basicContext._valid(row)===false) return ''

			// Give item a unique number
			row.num = num++

			// Generate span/icon-element
			if (row.icon!==null) span = `<span class='${ row.icon }'></span>`

			// Generate item
			if (row.type==='item') {

				html =	`
						<tr class='${ row.class }'>
							<td data-num='${ row.num }'>${ span }${ row.title }</td>
						</tr>
						`

			} else if (row.type==='separator') {

				html =	`
						<tr class='separator'></tr>
						`

			}

			return html

		}

		context +=	`
					<div class='basicContextContainer'>
						<div class='basicContext'>
							<table>
								<tbody>
					`

		for (let i = 0; i < data.length; ++i) context += item(data[i])

		context +=	`
								</tbody>
							</table>
						</div>
					</div>
					`

		return context

	},

	_normalizeEvent(e) {

		// The event 'touchend' does not return the touch position.
		// We need to capture pageX and pageY from original event.

		if ((e!=null && e.type==='touchend') &&
			(e.pageX==null || e.pageY==null)) {

				var touches = e.changedTouches

				if (touches.length>0) {
					e.pageX = touches[0].pageX
					e.pageY = touches[0].pageY
				}

		}

		return e

	},

	_getPosition(e) {

		e = basicContext._normalizeEvent(e)

		var browser = {
			scrollTop:	document.body.scrollTop,
			width:		window.innerWidth,
			height:		window.innerHeight
		}

		var x = e.pageX,
			y = e.pageY - browser.scrollTop

		// Position unknown
		if (x==null || x < 0) x = 0
		if (y==null || y < 0) y = 0

			// Get size of context
		var context = {
			width:	basicContext._dom().offsetWidth,
			height:	basicContext._dom().offsetHeight
		}

		// Never leave the screen
		if (x > browser.width)	x = browser.width
		if (y > browser.height)	y = browser.height

		// Fix position based on context
		if ((x + context.width) > browser.width)	x = x - ((x + context.width) - browser.width)
		if ((y + context.height) > browser.height)	y = y - ((y + context.height) - browser.height)

		// Make context scrollable and start at the top of the browser
		// when context is higher than the browser
		if (context.height > browser.height) {
			y = 0
			basicContext._dom().classList.add('basicContext--scrollable')
		}

		return {x, y}

	},

	_bind(row) {

		if (row.fn!=null) basicContext._dom(`td[data-num='${ row.num }']`).onclick = row.fn

	},

	show(data, e, fnClose, fnCallback) {

		// Build context
		var html = basicContext._build(data)
		document.body.insertAdjacentHTML('beforeend', html)

		// Save current overflow and block scrolling of site
		if (basicContext._overflow==null) {
			basicContext._overflow = document.body.style.overflow
			document.body.style.overflow = 'hidden'
		}

		// Calculate position
		var position = basicContext._getPosition(e)

		// Set position
		basicContext._dom().style.left		= `${ position.x }px`
		basicContext._dom().style.top		= `${ position.y }px`
		basicContext._dom().style.opacity	= 1

		// Close fn fallback
		if (fnClose==null) fnClose = basicContext.close

		// Bind click on background
		basicContext._dom().parentElement.onclick = fnClose

		// Bind click on items
		for (let i = 0; i < data.length; ++i) basicContext._bind(data[i])

		// Call callback when available
		if (fnCallback!=null) fnCallback()

		// Do not trigger default event
		if (typeof e.preventDefault === 'function') e.preventDefault()

		return true

	},

	visible() {

		var elem = basicContext._dom()

		if (elem==null||elem.length===0)	return false
		else								return true

	},

	close() {

		basicContext._dom().parentElement.remove()

		// Reset overflow to its original value
		if (basicContext._overflow!=null) {
			document.body.style.overflow = basicContext._overflow
			basicContext._overflow = null
		}

		return true

	}

}