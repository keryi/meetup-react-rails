DOM = React.DOM

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
      DOM.div
        className: 'form-group'
        DOM.label
          htmlFor: 'title',
          className: 'col-lg-2 control-label'
          'Title'
        DOM.div
          className: 'col-lg-10'
          DOM.input
            className: 'form-control'
            placeholder: 'Meetup title',
            id: 'title',
            type: 'text',
            value: @state.title
            onChange: @titleChanged
      DOM.div
        className: 'form-group'
        DOM.label
          htmlFor: 'title',
          className: 'col-lg-2 control-label'
          'Title'
        DOM.div
          className: 'col-lg-10'
          DOM.input
            className: 'form-control'
            placeholder: 'Meetup description',
            id: 'description',
            type: 'text',
            value: @state.description
            onChange: @descriptionChanged
    )

createNewMeetupForm = React.createFactory(NewMeetupForm)

$ ->
  React.render(
    createNewMeetupForm(),
    document.getElementById('CreateNewMeetup')
  )
