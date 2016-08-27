$(document).ready(function() {

  // Naivigation Menu
  var menuToggle = $('#js-mobile-menu').unbind();
  $('#js-navigation-menu').removeClass("show");

  menuToggle.on('click', function(e) {
    e.preventDefault();
    $('#js-navigation-menu').slideToggle(function(){
      if($('#js-navigation-menu').is(':hidden')) {
        $('#js-navigation-menu').removeAttr('style');
      }
    });
  });

  // Selectize
  var initSelectize = function(input_id) {
    $('#' + input_id).selectize({
      plugins: ['remove_button', 'restore_on_backspace'],
      delimiter: ',',
      persist: false,
      create: function(input) {
        return {
          text: input,
          value: input
        }
      }
    })
  }

  /*
  _.each($('#term-input-list li'), function(li, key) {
    var input_id = $(li).find('input[type="text"]').attr('id')
    console.log(key)
    console.log(li)
    console.log(input_id)
    initSelectize(input_id)
  })
  */

  // Dropdowns
  $(".dropdown-button").click(function() {
    var $button, $menu
    $button = $(this)
    $menu = $button.siblings(".dropdown-menu")
    $menu.toggleClass("show-menu")
    $menu.children("li").click(function() {
      $menu.removeClass("show-menu")
      $button.html($(this).html())
    })
  })

  // Add Fields
  $('#add-another-query').on('click', function(e) {
    e.preventDefault()

    // For new input #
      var input_number = $('#term-input-list li').length.toString()

    // Prepare HTML
    var inputs_template = $('#template-add-term-input').html()
    var template_name = inputs_template.replace(/\[template\]/g, '['+input_number+']')
    var template_fixed = template_name.replace('_template_', '_'+input_number+'_').trim()

    // Inject
    $('#term-input-list').append(template_fixed)
    // initSelectize()
  })

})
