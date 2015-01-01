# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$('#user-search').autocomplete(
  source: '/api/v1/users/search'
  autoFocus: true
  minLength: 2
)
