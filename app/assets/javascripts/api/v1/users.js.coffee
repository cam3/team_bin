# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
bh_search = new Bloodhound(
  remote: '/api/v1/users/search?q=%QUERY'
)

engine.initialize()

$( '#user-search' ).typeahead({
  highlight: true,
},
{
  displayKey: username
  source: bh_search.ttAdapter()
}
)
