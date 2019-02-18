document.addEventListener('DOMContentLoaded', function() {
  const want_ids = ['t-profile', 't-password', 't-destroy'];

  document.addEventListener('click', function(e) {
    var active_tab = document.getElementById('active-tab');
    var target = e.target;
    var classes = active_tab.className.split(' ');
    var f = document.getElementsByClassName('f');

    if (want_ids.indexOf(target.id) >= 0) {
      var profile;
      var password;
      var destroy;

      for (var i = 0; i < f.length; i++) {
        var f_class = f.item(i).className.split(' ');
        var active_idx = f_class.indexOf('active');
        if ( active_idx >= 0 ) {
          f_class.splice(active_idx, 1);
          f.item(i).className = f_class.join(' ');
        }
        switch (f.item(i).id) {
          case 'profile':
            profile = f.item(i);
            break;
          case 'password':
            password = f.item(i);
            break;
          case 'destroy':
            destroy = f.item(i);
            break;
          default:
        }
      }

      function addActiveTo(elem) {
        const to_array = elem.className.split(' ');
        to_array.push('active');
        return elem.className = to_array.join(' ');
      }

      const location = ['right', 'center', 'left'];
      for (var i = location.length - 1; i >= 0; i--) {
        var idx = classes.indexOf(location[i]);
        if (idx >= 0) {
          classes.splice(idx, 1);
          break;
        }
      }
      switch (target.id) {
        case 't-profile':
          classes.push('left');
          active_tab.className = classes.join(' ');
          addActiveTo(profile);
          break;
        case 't-password':
          classes.push('center');
          active_tab.className = classes.join(' ');
          addActiveTo(password);
          break;
        case 't-destroy':
          classes.push('right');
          active_tab.className = classes.join(' ');
          addActiveTo(destroy);
          break;
        default:
      }
    }
  })
});
