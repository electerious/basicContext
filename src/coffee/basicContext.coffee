this.context =

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

		item = (row) ->

			return '' if not context._valid row

			span = "<span class='#{ row.icon }'></span>"
			span = '' if row.icon is ''

			switch row.type

				when 'item' then return "<tr class='#{ row.class }'><td data-name='#{ encodeURI(row.title) }'>#{ span }#{ row.title }</td></tr>"
				when 'separator' then return "<tr class='separator'></tr>"

		"""
		<div class='contextContainer'>
			<div class='context'>
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

				e.preventDefault()

		return e

	_getPosition: (e) ->

		e = context._normalizeEvent e

		x = e.pageX
		y = e.pageY - $(document).scrollTop()

		browser =
			width:	$('html').width()
			height:	$('html').height()

		# Position unknown
		x = 0 if not x? or x < 0
		y = 0 if not y? or y < 0

		# Never leave the screen
		x = browser.width if x > browser.width
		y = browser.height if y > browser.height

		return {
			x: x
			y: y
		}

	_bind: (row) ->

		$(".contextContainer td[data-name='#{ encodeURI(row.title) }']").click row.fn

	show: (data, e, fnClose) ->

		# Build context
		$('body').append context._build(data)
		$('body').css	'overflow', 'hidden'

		# Get info to calculate position
		mousePosition	= context._getPosition(e)
		contextSize		=
			width:	$('.contextContainer .context').outerWidth true
			height:	$('.contextContainer .context').outerHeight true
		browserSize		=
			width:	$('html').width()
			height:	$('html').height()

		# Calculate position
		if (mousePosition.x + contextSize.width) > browserSize.width
			mousePosition.x -= contextSize.width
		if (mousePosition.y + contextSize.height) > browserSize.height
			mousePosition.y -= (mousePosition.y + contextSize.height) - browserSize.height

		# Set position
		$('.contextContainer .context').css
			top:		"#{ mousePosition.y }px"
			left:		"#{ mousePosition.x }px"
			opacity:	1

		# Close fallback
		fnClose = context.close if not fnClose?

		# Bind click on background
		$('.contextContainer').click fnClose if fnClose?
		$('.contextContainer').click context.close if not fnClose?

		# Bind click on items
		context._bind row for row in data

		# Call callback
		callback() if data.callback?

		return true

	close: ->

		$('.contextContainer').remove()
		$('body').css 'overflow', 'scroll'
		return true