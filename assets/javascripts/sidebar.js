$(document).ready(function(){
  // Show sidebar
  function showSidebar(){
      $('#sidebar').removeClass('hide-sidebar');
      $('#content').removeClass('hide2-sidebar');
      $('#sidebar-button-toggle').removeClass('sbt_l');
      $('#sidebar-button-toggle').addClass('sbt_r');
      $.cookie('sidebar-pref', 'show-sidebar', { path: '/redmine' });
  }
  // Hide sidebar
  function hideSidebar(){
      $('#sidebar').addClass('hide-sidebar');
      $('#content').addClass('hide2-sidebar');
      $('#sidebar-button-toggle').removeClass('sbt_r');
      $('#sidebar-button-toggle').addClass('sbt_l');
      $.cookie('sidebar-pref', 'hide-sidebar', { path: '/redmine' });
  }
  // Toggle sidebar
  $('#sidebar-button-toggle').click(function(){
      if ( $('#sidebar').hasClass('hide-sidebar') ){
          showSidebar();
      } else {
          hideSidebar();
      }
  });
  // Load preference
  if ( $.cookie('sidebar-pref') == 'hide-sidebar' ){
	  hideSidebar();
  }
});
