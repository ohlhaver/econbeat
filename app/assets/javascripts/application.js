// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require jquery.purr
//= require best_in_place
//= require_tree .
jQuery( function($) {
    $('[rel=tooltip]').tooltip();
    $("a[rel=popover]")
            .tooltip({
                offset: 10,
                trigger: 'manual',
                animate: false,
                html: true,
                placement: 'right',
                template: '<div class="tooltip" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="tooltip-inner"><h3 class="tooltip-title"></h3><div class="tooltip-content"><p></p></div></div></div>'

            }).click(function(e) {
                
            }).mouseenter(function(e) {
                $(this).tooltip('show');
            });
});

