DOM = React.DOM

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
        className: 'col-lg-2 control-label'
        @props.labelText
      DOM.div
        className: 'col-lg-10'
        DOM[@props.elementType]
          className: 'form-control'
          placeholder: @props.placeholder,
          id: @props.id,
          type: @tagType(),
          value: @props.value
          onChange: @props.onChanged

  tagType: ->
    {
      'input': @props.inputType,
      'textarea': null
    }[@props.elementType]

NewMeetupForm = React.createClass
  displayName: 'NewMeetupForm'

  getInitialState: ->
    {
      title: '',
      description: ''
    }

  titleChanged: (e) ->
    @setState(title: e.target.value)

  descriptionChanged: (e) ->
    @setState(description: e.target.value)

  render: ->
    DOM.form(
      className: 'form-horizontal'
      formInputWithLabel
        id: 'title'
        value: @state.title
        onChange: @titleChanged
        placeholder: 'Meetup title'
        labelText: 'Title'

      formInputWithLabel
        id: 'description'
        value: @state.description
        onChange: @descriptionChanged
        placeholder: 'Meetup description'
        labelText: 'Description'
    )

createNewMeetupForm = React.createFactory(NewMeetupForm)
formInputWithLabel = React.createFactory(FormInputWithLabel)

$ ->
  React.render(
    createNewMeetupForm(),
    document.getElementById('CreateNewMeetup')
  )
