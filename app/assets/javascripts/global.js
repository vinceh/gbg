$(window).load(function() {
    $('.search-input').autocomplete({
        source: '/search_boardgames'
    });

    $('.search-form').submit(function() {
        $.ajax({
            url: '/single_search?term='+$('.search-input').val()
        }).done( function(data) {
            if ( data.id ) {
                window.location = "/boardgame/"+data.id;
            }
        });

        return false;
    });
});