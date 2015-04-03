$(document).ready(function() {

    for(i=0; i<composition_pictures.length; i++) {
        var id = '#cimg-del-' + composition_pictures[i].id;

        $(id).on('click', function(click){
            var $$ = $(this)
            // Split id name on '-', and take just final ID from it
            // We know structure will be 'cimg-del-' followed by the ID of the picture
            // We can now construct the check ID from these pieces
            var id = "#user_composition_picture_ids_" + click.currentTarget.id.split("-")[2]

            if(!$$.is('.checked')){
                $$.addClass('checked');
                $(id).prop('checked', true);
            } else {
                $$.removeClass('checked');
                $(id).prop('checked', false);
            }
        })
    };

    for(i=0; i<base_pictures.length; i++) {
        var id = '#bimg-del-' + base_pictures[i].id;

        $(id).on('click', function(click){
            var $$ = $(this)
            // Split id name on '-', and take just final ID from it
            // We know structure will be 'cimg-del-' followed by the ID of the picture
            // We can now construct the check ID from these pieces
            var id = "#user_base_picture_ids_" + click.currentTarget.id.split("-")[2]

            if(!$$.is('.checked')){
                $$.addClass('checked');
                $(id).prop('checked', true);
            } else {
                $$.removeClass('checked');
                $(id).prop('checked', false);
            }
        })
    };

    for(i=0; i<mosaics.length; i++) {
        var id = '#mimg-del-' + mosaics[i].id;

        $(id).on('click', function(click){
            var $$ = $(this)
            // Split id name on '-', and take just final ID from it
            // We know structure will be 'mimg-del-' followed by the ID of the picture
            // We can now construct the check ID from these pieces
            var id = "#user_mosaic_ids_" + click.currentTarget.id.split("-")[2]

            if(!$$.is('.checked')){
                $$.addClass('checked');
                $(id).prop('checked', true);
            } else {
                $$.removeClass('checked');
                $(id).prop('checked', false);
            }
        })
    };
    
});