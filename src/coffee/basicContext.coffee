this.context =

	_valid: (data) ->

		if	data?.type? and
			data.type is 'separator'

				return true

		if	data?.type? and
			data.title? and
			data.icon? and
			data.fn?

				return true

		return false

	_build: (data) ->

		item = (row) ->

			return '' if not context._valid row

			switch row.type

				when 'item' then return "<tr><td data-name='#{ row.title }'><span class='#{ row.icon }'></span>#{ row.title }</td></tr>"
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

	_getPosition: (e) ->

		x		= e.pageX
		y		= e.pageY - $(document).scrollTop()
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

	show: (data, e, fnClose) ->

		onClick = (row) ->

			$(".contextContainer td[data-name='#{ row.title }']").click row.fn

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
		onClick row for row in data

		return true

	close: ->

		$('.contextContainer').remove()
		$('body').css 'overflow', 'scroll'
		return true