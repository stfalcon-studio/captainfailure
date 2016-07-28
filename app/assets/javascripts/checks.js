// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(function() {
    function hide_all() {
        $('#check_via').hide();
        $('#enabled').hide();
        $('#icmp_count').hide();
        $('#tcp_port').hide();
        $('#http_code').hide();
        $('#http_vhost').hide();
        $('#http_uri').hide();
        $('#http_protocol').hide();
        $('#http_keyword').hide();
        $('#check_interval').hide();
        $('#days_left').hide();
        $('#timeout').hide();
        $('#form_submit').hide();
    }
    if($('#check_check_type').val() == 'icmp') {
        hide_all()
        $('#check_via').show();
        $('#enabled').show();
        $('#check_interval').show();
        $('#icmp_count').show();
        $('#form_submit').show();
    }
    if($('#check_check_type').val() == 'port_open') {
        hide_all()
        $('#check_via').show();
        $('#enabled').show();
        $('#tcp_port').show();
        $('#check_interval').show();
        $('#timeout').show();
        $('#form_submit').show();
    }
    if($('#check_check_type').val() == 'http_code') {
        hide_all()
        $('#check_via').show();
        $('#enabled').show();
        $('#tcp_port').show();
        $('#http_code').show();
        $('#http_vhost').show();
        $('#http_uri').show();
        $('#http_protocol').show();
        $('#check_interval').show();
        $('#timeout').show();
        $('#form_submit').show();
    }
    if($('#check_check_type').val() == 'http_keyword') {
        hide_all()
        $('#check_via').show();
        $('#enabled').show();
        $('#tcp_port').show();
        $('#http_code').show();
        $('#http_vhost').show();
        $('#http_uri').show();
        $('#http_protocol').show();
        $('#check_interval').show();
        $('#http_keyword').show();
        $('#timeout').show();
        $('#form_submit').show();
    }
    if($('#check_check_type').val() == 'cert_check') {
        hide_all()
        $('#check_via').show();
        $('#enabled').show();
        $('#tcp_port').show();
        $('#http_vhost').show();
        $('#http_uri').show();
        $('#http_protocol').show();
        $('#days_left').show();
        $('#check_interval').show();
        $('#form_submit').show();
    }
    if($('#check_check_type').val() == '') {
        hide_all()
    }
    $('#check_check_type').change(function(){
        if($('#check_check_type').val() == 'icmp') {
            hide_all()
            $('#check_via').show();
            $('#enabled').show();
            $('#check_interval').show();
            $('#icmp_count').show();
            $('#form_submit').show();
        }
        if($('#check_check_type').val() == 'port_open') {
            hide_all()
            $('#check_via').show();
            $('#enabled').show();
            $('#tcp_port').show();
            $('#check_interval').show();
            $('#timeout').show();
            $('#form_submit').show();
        }
        if($('#check_check_type').val() == 'http_code') {
            hide_all()
            $('#check_via').show();
            $('#enabled').show();
            $('#tcp_port').show();
            $('#http_code').show();
            $('#http_vhost').show();
            $('#http_uri').show();
            $('#http_protocol').show();
            $('#check_interval').show();
            $('#timeout').show();
            $('#form_submit').show();
        }
        if($('#check_check_type').val() == 'http_keyword') {
            hide_all()
            $('#check_via').show();
            $('#enabled').show();
            $('#tcp_port').show();
            $('#http_code').show();
            $('#http_vhost').show();
            $('#http_uri').show();
            $('#http_protocol').show();
            $('#check_interval').show();
            $('#http_keyword').show();
            $('#timeout').show();
            $('#form_submit').show();
        }
        if($('#check_check_type').val() == 'cert_check') {
            hide_all()
            $('#check_via').show();
            $('#enabled').show();
            $('#tcp_port').show();
            $('#http_vhost').show();
            $('#http_uri').show();
            $('#http_protocol').show();
            $('#days_left').show();
            $('#check_interval').show();
            $('#form_submit').show();
        }
        if($('#check_check_type').val() == '') {
            hide_all()
        }
    });
});
