ruleset track_trips {
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

    rule process_trip {
      select when echo message
      pre{
        mileage = event:attr("mileage").klog("our passed in input: ");
      }
      {
        send_directive("trip") with
          trip_length = "{mileage}";
      }
    }
}
