// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function show_level(id) {
  $('.level_holder').hide();
  $('.level_holder#'+id).show();
}

function init_level_grid(id) {
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
