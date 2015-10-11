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

  fieldChanged: (fieldName, e)->
    stateUpdate = {}
    stateUpdate[fieldName] = e.target.value
    @setState(stateUpdate)

  render: ->
    DOM.form(
      className: 'form-horizontal'
      formInputWithLabel
        id: 'title'
        value: @state.title
        onChange: @fieldChanged.bind(null, 'title')
        placeholder: 'Meetup title'
        labelText: 'Title'

      formInputWithLabel
        id: 'description'
        value: @state.description
        onChange: @fieldChanged.bind(null, 'description')
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
