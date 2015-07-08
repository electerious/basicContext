let overflow = null

const dom = function(elem = '') {

	return document.querySelector('.basicContext ' + elem)

}

const valid = function(data = {}) {

	if (data.class==null)     data.class    = ''
	if (data.type==null)      data.type     = 'item'
	if (data.visible!==false) data.visible  = true
	if (data.icon==null)      data.icon     = null
	if (data.title==null)     data.title    = 'Undefined'

	// Add disabled class when item disabled
	if (data.disabled!==true) data.disabled = false
	if (data.disabled===true) data.class += ' basicContext__item--disabled'

	// Item requires a function when
	// it's not a separator and not disabled
	if (data.fn==null && data.type!=='separator' && data.disabled===false) {

		console.warn(`Missing fn for item '${ data.title }'`)
		return false

	}

	return true

}

const build = function(data) {

	let num     = 0,
	    context = '',
	    item

	item = function(row) {

		let html = '',
		    span = ''

		// Parse and validate data
		if (valid(row)===false) return ''

		// Skip when invisible
		if (row.visible===false) return ''

		// Give item a unique number
		row.num = num++

		// Generate span/icon-element
		if (row.icon!==null) span = `<span class='basicContext__icon ${ row.icon }'></span>`

		// Generate item
		if (row.type==='item') {

			html = `
			       <tr class='basicContext__item ${ row.class }'>
			           <td class='basicContext__data' data-num='${ row.num }'>${ span }${ row.title }</td>
			       </tr>
			       `

		} else if (row.type==='separator') {

			html = `
			       <tr class='basicContext__item basicContext__item--separator'></tr>
			       `

		}

		return html

	}

	context += `
	           <div class='basicContextContainer'>
	               <div class='basicContext'>
	                   <table>
	                       <tbody>
	           `

	for (let i = 0; i < data.length; ++i) context += item(data[i])

	context += `
	                       </tbody>
	                   </table>
	               </div>
	           </div>
	           `

	return context

}

const getNormalizedEvent = function(e = {}) {

	let pos = {
		x: e.clientX,
		y: e.clientY
	}

	if (e.type==='touchend' && (pos.x==null || pos.y==null)) {

		// We need to capture clientX and clientY from original event
		// when the event 'touchend' does not return the touch position

		let touches = e.changedTouches

		if (touches!=null&&touches.length>0) {
			pos.x = touches[0].clientX
			pos.y = touches[0].clientY
		}

	}

	// Position unknown
	if (pos.x==null || pos.x < 0) pos.x = 0
	if (pos.y==null || pos.y < 0) pos.y = 0

	return pos

}

const getPosition = function(e) {

	// Get the click position
	let {x, y} = getNormalizedEvent(e)

	// Get size of browser
	let browser = {
		width     : window.innerWidth,
		height    : window.innerHeight
	}

	// Get size of context
	let context = {
		width  : dom().offsetWidth,
		height : dom().offsetHeight
	}

	// Never leave the screen
	if (x > browser.width)  x = browser.width
	if (y > browser.height) y = browser.height

	// Fix position based on context
	if ((x + context.width) > browser.width)   x = x - ((x + context.width) - browser.width)
	if ((y + context.height) > browser.height) y = y - ((y + context.height) - browser.height)

	// Make context scrollable and start at the top of the browser
	// when context is higher than the browser
	if (context.height > browser.height) {
		y = 0
		dom().classList.add('basicContext--scrollable')
	}

	return {x, y}

}

const bind = function(row) {

	if (row.fn==null)        return false
	if (row.visible===false) return false
	if (row.disabled===true) return false

	dom(`td[data-num='${ row.num }']`).onclick       = row.fn
	dom(`td[data-num='${ row.num }']`).oncontextmenu = row.fn

	return true

}

const show = function(data, e, fnClose, fnCallback) {

	// Build context
	let html = build(data)
	document.body.insertAdjacentHTML('beforeend', html)

	// Save current overflow and block scrolling of site
	if (overflow==null) {
		overflow = document.body.style.overflow
		document.body.style.overflow = 'hidden'
	}

	// Calculate position
	let position = getPosition(e)

	// Cache the context
	let context = dom()

	// Set position
	context.style.left    = `${ position.x }px`
	context.style.top     = `${ position.y }px`
	context.style.opacity = 1

	// Close fn fallback
	if (fnClose==null) fnClose = () => {
		close()
		return false
	}

	// Bind click on background
	context.parentElement.onclick       = fnClose
	context.parentElement.oncontextmenu = fnClose

	// Bind click on items
	for (let i = 0; i < data.length; ++i) bind(data[i])

	// Call callback when available
	if (fnCallback!=null) fnCallback()

	// Do not trigger default event
	if (typeof e.preventDefault === 'function') e.preventDefault()

	return true

}

const visible = function() {

	let elem = dom()

	if (elem==null || elem.length===0) return false
	else                               return true

}

const close = function() {

	if (visible()===false) return false

	dom().parentElement.remove()

	// Reset overflow to its original value
	if (overflow!=null) {
		document.body.style.overflow = overflow
		overflow = null
	}

	return true

}

return {
	show,
	visible,
	close
}