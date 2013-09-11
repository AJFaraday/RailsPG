// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function show_level(id) {
  $('.level_holder').hide();
  $('.level_holder#'+id).show();
}

function init_level_grid(id) {
  $('td.movable').off();
  // TODO set valid cells to 'movable' class
  $('td.movable').on('click',function()
    {
      //alert('['+(this.cellIndex+1)+','+(this.parentNode.rowIndex+1)+']');
      $.get(
        '/games/'+id+'/move',
        {coord: '['+(this.cellIndex+1)+','+(this.parentNode.rowIndex+1)+']'},
        function(data){
        }
      ).fail(function(object,status,error)
        {
          alert("call failed: " + error)
        });
    }
  );
};

function move(element_selector,coord){
  var element = $(element_selector);
  var table = element.closest('table');
  var target_cell = table[0].rows[coord[1] - 1].cells[coord[0] - 1]
  element.appendTo(target_cell)
}

function show_message(message){
  $('#play_messages').prepend(message+"<br/>")
}

function reset_movable(level,column,row,distance) {
  show_level(level);
  $("td.movable").removeClass('movable')
  if (arguments.length == 4){
    //$("table.level_grid#lvl_"+level)[0].rows[row].cells[column]
    $("table.level_grid#lvl_"+level+" tr").each(function(row_index){
      $(this).children('td').each(function(column_index){
        var x_dist = Math.abs(row - row_index);
        var y_dist = Math.abs(column - column_index);
        var dist = x_dist + y_dist;
        if(dist <= distance &&
            Math.abs(dist) > 0 &&
            $(this).children('.character').length == 0 &&
            $(this).children('.obstacle').length == 0) {
          $(this).addClass('movable');
        }
      });
    });
  }
  init_level_grid(level);
};

function set_health(character,percent){
  var full_height = 66 //health bar class height
  var target_height = (full_height / 100) * percent;
  var top_offset = (full_height / 100) * (100 - percent)

  var character = $("#character_"+character);
  var bar = character.children('.health_bar');

  bar.animate(
    {
      height: target_height,
      top: top_offset
    },
    1000
  )
};


function set_skill(character,percent){
  var full_height = 66 //skill bar class height
  var target_height = (full_height / 100) * percent;
  var top_offset = (full_height / 100) * (100 - percent)

  var character = $("#character_"+character);
  var bar = character.children('.skill_bar');

  bar.animate(
    {
      height: target_height,
      top: top_offset
    },
    1000
  )
};




