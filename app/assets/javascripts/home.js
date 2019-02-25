document.addEventListener('DOMContentLoaded', function() {
  var periods = document.querySelectorAll('.select-period a');
  var now_url = location.href;
  for (var i = 0; i < periods.length; i++) {
    var period = periods.item(i)
    if (period.href === now_url) {
      period.className = 'select';
      break;
    }
  }
})
