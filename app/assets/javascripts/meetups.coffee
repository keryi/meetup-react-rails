DOM = React.DOM

DateHelper = {
  monthName: (monthNumberStartsFromZero) ->
    [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ][monthNumberStartsFromZero]
}

DateWithLabel = React.createClass
  getDefaultProps: ->
    date: new Date()

  onYearChange: (e) ->
    newDate = new Date(
      e.target.value,
      @props.date.getMonth(),
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onMonthChange: (e) ->
    newDate = new Date(
      @props.date.getFullYear(),
      e.target.value,
      @props.date.getDate()
    )
    @props.onChange(newDate)

  onDateChange: (e) ->
    newDate = newDate(
      @props.date.getFullYear(),
      @props.date.getMonth(),
      e.target.value
    )
    @props.onChange(newDate)

  dayName: (date) ->
    dayNameStartsFromZero = new Date(
      @props.date.getFullYear(),
      @props.date.getMonth(),
      date
    ).getDay()
    ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'][dayNameStartsFromZero]

  render: ->
    DOM.div
      className: 'form-group'
      DOM.label
        className: 'col-sm-2 control-label'
        'Date'
      DOM.div
        className: 'col-sm-3'
        DOM.select
          className: 'form-control'
          onChange: @onYearChange
          value: @props.date.getFullYear()
          DOM.option(value: year, key: year, year) for year in [2015..2020]
      DOM.div
        className: 'col-sm-3'
        DOM.select
          className: 'form-control'
          onChange: @onMonthChange
          value: @props.date.getMonth()
          DOM.option(value: month, key: month, "#{month + 1}-#{DateHelper.monthName(month)}") for month in [0..11]
      DOM.div
        className: 'col-sm-3'
        DOM.select
          className: 'form-control'
          value: @props.date.getDate()
          DOM.option(value: date, key: date, "#{date}-#{@dayName(date)}") for date in [1..31]

FormInputWithLabelAndReset = React.createClass
  displayName: 'FormInputWithLabelAndReset'
  render: ->
    DOM.div
      className: 'form-group'
      DOM.label
        htmlFor: @props.id
        className: 'col-sm-2 control-label'
        @props.labelText
      DOM.div
        className: 'col-sm-8'
        DOM.div
          className: 'input-group'
          DOM.input
            className: 'form-control'
            placeholder: @props.placeholder
            id: @props.id
            value: @props.value
            onChange: (e) =>
              @props.onChange(e.target.value)
          DOM.span
            className: 'input-group-btn'
            DOM.button
              onClick: () =>
                @props.onChange(null)
              className: 'btn btn-default'
              type: 'button'
              DOM.i
                className: 'fa fa-magic'
            DOM.button
              onClick: () =>
                @props.onChange('')
              className: 'btn btn-default'
              type: 'button'
              DOM.i
                className: 'fa fa-times-circle'

FormInputWithLabel = React.createClass
  displayName: 'FormInputWithLabel'

  getDefaultProps: ->
    elementType: 'input'
    inputType: 'text'

  render: ->
    DOM.div
      className: 'form-group'
      DOM.label
        htmlFor: @props.id,
        className: 'col-sm-2 control-label'
        @props.labelText
      DOM.div
        className: classNames('col-sm-10': true, 'has-warning': @props.warning)
        @warning()
        DOM[@props.elementType]
          className: 'form-control'
          placeholder: @props.placeholder
          id: @props.id
          type: @tagType()
          value: @props.value
          onChange: @props.onChange

  tagType: ->
    {
      'input': @props.inputType,
      'textarea': null
    }[@props.elementType]

  warning: ->
    return null unless @props.warning
    DOM.label
      className: 'control-label'
      htmlFor: @props.id
      @props.warning

NewMeetupForm = React.createClass
  displayName: 'NewMeetupForm'

  getInitialState: ->
    {
      meetup: {
        title: ''
        description: ''
        date: new Date()
        seoText: null
        warnings: {
          title: null
        }
      }
    }

  validateField: (fieldName, value) ->
    validator = {
      title: (text) ->
        if /\S/.test(text) then null else 'Cannot be blank'
    }[fieldName]
    return unless validator
    @state.meetup.warnings[fieldName] = validator(@state.meetup[fieldName])

  fieldChanged: (fieldName, e)->
    @state.meeup[fieldName] = e.target.value
    @validateField(fieldName)
    @forceUpdate()

  dateChanged: (newDate) ->
    @state.meetup.date = newDate
    @forceUpdate()

  seoChanged: (seoText) ->
    @state.meetup.seoText = seoText
    @forceUpdate()

  computeDefaultSeoText: () ->
    words = @state.meetup.title.toLowerCase().split(/\s+/)
    words.push(DateHelper.monthName(@state.meetup.date.getMonth()))
    words.push(@state.meetup.date.getFullYear().toString())
    words.filter((string) -> string.trim().length > 0).join('-').toLowerCase()

  validateAll: () ->
    newState = $.extend(true, {}, @state)
    for field in ['title']
      @validateField(field)

  formSubmitted: (e) ->
    e.preventDefault()

    @validateAll()
    @forceUpdate()
    for own key of @state.meetup
      return if @state.meetup.warnings[key]

    $.ajax
      url: '/meetups.json',
      type: 'post',
      dataType: 'JSON',
      contentType: 'application/json',
      processData: false,
      data: JSON.stringify({ meetup: {
          title: @state.meetup.title
          description: @state.meetup.description
          date: "#{@state.meetup.date.getFullYear()}-#{@state.meetup.date.getMonth()}-#{@state.meetup.date.getDate()}"
          seo: @state.meetup.seoText || @computeDefaultSeoText()
        }
      })

  render: ->
    DOM.form(
      className: 'form-horizontal'
      onSubmit: @formSubmitted
      formInputWithLabel
        id: 'title'
        value: @state.meetup.title
        onChange: @fieldChanged.bind(null, 'title')
        placeholder: 'Meetup title'
        labelText: 'Title'
        warning: @state.meetup.warnings.title

      formInputWithLabel
        id: 'description'
        value: @state.meetup.description
        onChange: @fieldChanged.bind(null, 'description')
        placeholder: 'Meetup description'
        labelText: 'Description'

      dateWithLabel
        date: @state.meetup.date
        onChange: @dateChanged

      formInputWithLabelAndReset
        id: 'seo'
        value: if @state.meetup.seoText? then @state.meetup.seoText else @computeDefaultSeoText()
        onChange: @seoChanged
        placeholder: 'SEO text'
        labelText: 'seo'

      DOM.div
        className: 'form-group'
        DOM.div
          className: 'col-sm-10 col-sm-offset-2'
          DOM.button
            type: 'submit'
            className: 'btn btn-primary'
            'Save'
    )

createNewMeetupForm = React.createFactory(NewMeetupForm)
formInputWithLabel = React.createFactory(FormInputWithLabel)
dateWithLabel = React.createFactory(DateWithLabel)
formInputWithLabelAndReset = React.createFactory(FormInputWithLabelAndReset)

$ ->
  React.render(
    createNewMeetupForm(),
    document.getElementById('CreateNewMeetup')
  )
