$(window).load(function() {

    $('.donate').tooltip();

    $('.search-input').autocomplete({
        source: '/search_boardgames'
    });

    $('.search-form').submit(function() {

        var searchinput = $('.search-input');
        var errortext = $('.formtext');
        var ball = $(this).children('img');

        if (searchinput.val() == "") {
            errortext.show();
            return false;
        }

        errortext.hide();
        ball.show();
        $.ajax({
            url: '/single_search?term='+searchinput.val(),
            complete: function() {
                ball.hide();
            }
        }).done( function(data) {
            if ( data.id ) {
                window.location = "/boardgame/"+data.id;
            }
            else {
                errortext.show();
            }
        });

        return false;
    });

    $('.facebook').click(function() {
        window.open($(this).attr('data-url'),'mywindow','width=600,height=300');
    });
});