ruleset hello_world {
    meta {
        name "Hello World"
        description <<
        a first ruleset for the Quickstart
        >>
        author "Spencer Krieger"
        logging on
        sharing on
        provides hello
    }
    global {
        hello = function(obj) {
            msg = "Hello " + obj
            msg
        };
    }
    rule hello_world {
        select when echo hello
        send_directive("say") with
            something = "Hello World"
    }
}
