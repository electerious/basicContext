this.basicContext =

	_overflow: null

	_dom: (elem) ->

		if not elem? then return $('.basicContext')
		else return $('.basicContext').find("#{ elem }")

	_valid: (data) ->

		if data?

			###
			# Set defaults
			###

			if not data.class? then		data.class = ''
			if not data.type? then		data.type = 'item'
			if not data.icon? then		data.icon = ''
			if not data.title? then		data.title = 'Undefined'

			if	not data.fn? and
				data.type isnt 'separator'

					console.warn "Missing fn for item '#{ data.title }'"
					return false

			return true

		return false

	_build: (data) ->

		num = 0

		item = (row) ->

			return '' if not basicContext._valid row

			# Give item a unique number
			row.num = num++

			# Generate span/icon-element
			span = "<span class='#{ row.icon }'></span>"
			span = '' if row.icon is ''

			switch row.type

				when 'item' then		return "<tr class='#{ row.class }'><td data-num='#{ row.num }'>#{ span }#{ row.title }</td></tr>"
				when 'separator' then	return "<tr class='separator'></tr>"

		"""
		<div class='basicContextContainer'>
			<div class='basicContext'>
				<table>
					<tbody>
						#{ (item row for row in data).join '' }
					</tbody>
				</table>
			</div>
		</div>
		"""

	_normalizeEvent: (e) ->

		###
		# The event 'touchend' does not return the touch position.
		# We need to capture pageX and pageY from original event.
		###

		if	e? and
			e.type is 'touchend' and
			not (e.pageX? or e.pageY?)

				touches = e.originalEvent.changedTouches

				if touches.length > 0
					e.pageX = touches[0].pageX
					e.pageY = touches[0].pageY

		return e

	_getPosition: (e) ->

		e = basicContext._normalizeEvent e

		x = e.pageX
		y = e.pageY - $(document).scrollTop()

		browserSize =
			width:	$('html').width()
			height:	$('html').height()

		# Position unknown
		x = 0 if not x? or x < 0
		y = 0 if not y? or y < 0

		# Never leave the screen
		x = browserSize.width	if x > browserSize.width
		y = browserSize.height	if y > browserSize.height

		# Get size of context
		contextSize	=
			width:	basicContext._dom().outerWidth true
			height:	basicContext._dom().outerHeight true

		# Fixed position based on contextSize
		if (x + contextSize.width) > browserSize.width		then x -= contextSize.width
		if (y + contextSize.height) > browserSize.height	then y -= (y + contextSize.height) - browserSize.height

		# Make context scrollable and start at the top of the browser
		# when context is higher than the browser
		if contextSize.height > browserSize.height
			y = 0
			basicContext._dom().addClass 'basicContext--scrollable'

		return {
			x: x
			y: y
		}

	_bind: (row) ->

		basicContext._dom("td[data-num='#{ row.num }']").click row.fn

	show: (data, e, fnClose, fnCallback) ->

		# Build context
		$('body').append basicContext._build(data)

		# Save current overflow and block scrolling of site
		if not basicContext._overflow?
			basicContext._overflow = $('body').css 'overflow'
			$('body').css 'overflow', 'hidden'

		# Calculate position
		position = basicContext._getPosition(e)

		# Set position and show context
		basicContext._dom().css
			top:		"#{ position.y }px"
			left:		"#{ position.x }px"
			opacity:	1

		# Close fn fallback
		fnClose = basicContext.close if not fnClose?

		# Bind click on background
		basicContext._dom().parent().click fnClose

		# Bind click on items
		basicContext._bind row for row in data

		# Do not trigger the default action of the event
		e.preventDefault()

		# Call callback
		fnCallback() if fnCallback?

		return true

	visible: ->

		if basicContext._dom().length is 0 then return false
		return true

	close: ->

		# Remove context
		basicContext._dom().parent().remove()

		# Reset overflow to its original value
		if basicContext._overflow?
			$('body').css 'overflow', basicContext._overflow
			basicContext._overflow = null

		return true