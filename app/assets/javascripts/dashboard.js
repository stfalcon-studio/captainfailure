// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function check_details(check_id) {
    $.getJSON('/check_details?check_id=' + check_id, function(data) {
        if (data.length > 0) {
            $.each(data, function(key, val) {
                if (val['result'] == true) {
                    var status_icon = '<span class="glyphicon glyphicon-ok-sign" aria-hidden="true" style="color: green" title="passed"></span>';
                } else {
                    var status_icon = '<span class="glyphicon glyphicon-remove-sign" aria-hidden="true" style="color: red" title="failed"></span>'
                }
                $('#' + check_id).find('.label-default').before('<p>' + val['name'] + ': ' + status_icon + '</p>');
            });
        } else {
            $('#' + check_id).find('.label-default').before('<p style="color: red">No any data from satellite has been reported</p>');
        }
    });
}