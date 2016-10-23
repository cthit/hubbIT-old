App.cable.subscriptions.create { channel: "SessionChannel" },
    received: (data) ->
        end_time = data.end_time
        user_id = data.user_id
        console.log end_time, user_id
        $elem = $('[data-cid="' + user_id + '"]')
        $elem.addClass('animate')
        setTimeout ->
            $elem.removeClass('animate')
        , 500