$(function() {
  var $revealButton = $('button.reveal');
  $revealButton.on('click', function() {
    var confirmationMessage = 'Your Stellar Public and Secret Key will be revealed and cannot be viewed again. Are you sure you want to reveal it now?'
    if (confirm(confirmationMessage)) {
      $.ajax({
        url: window.location.href,
        method: 'DELETE',
        success: function(html) {
          $revealButton.replaceWith(html);
        }
      });  
    }
  });
});
