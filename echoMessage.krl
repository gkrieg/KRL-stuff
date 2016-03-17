ruleset echo {
    meta {
        name "echo stuff"
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

    rule hello {
      select when echo hello
      pre{
        name = event:attr("name").klog("our passed in Name: ");
      }
      {
        send_directive("say") with
          something = "Hello #{name}";
      }
      always {
          log ("LOG says Hello " + name);
      }
    }

    rule message {
      select when echo message
      pre{
        input = event:attr("input").klog("our passed in input: ");
      }
      {
        send_directive("say") with
          something = "{input}";
      }
    }
}
