# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'turbolinks:load', ->
  $('#custom-message-checkbox').off().change ->
    $('#recommendation_custom-message-input').prop 'disabled', !this.checked

  $('#rec-form').off().submit ->
    unless $('#custom-message-checkbox').is ":checked"
      $('#recommendation_custom-message-input').prop 'disabled', false
      $('#recommendation_custom-message-input').val('')
    return true
