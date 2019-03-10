document.addEventListener('DOMContentLoaded', function() {
  var periods = document.querySelectorAll('.select-period a');
  var now_url = location.href;
  var selected_period;
  for (var i = 0; i < periods.length; i++) {
    var period = periods.item(i)
    period.class = '';
    if (period.href === now_url) {
      selected_period = period;
    }
  }
  selected_period.className = 'select';
})
