$(function() {
  $('a:not(th a, .pagination a)').live('click', function() {
    $(this).attr('target', '_blank');
    return true;
  });
});
