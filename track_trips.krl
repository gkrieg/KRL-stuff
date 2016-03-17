ruleset track_trips {
    meta {
        name "Track Trips 2"
        description <<
        a second ruleset for tracking trips
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
      select when car new_trip
      pre{
        mileage = event:attr("mileage").klog("our passed in input: ");
      }
      {
        raise explicit event 'trip_processed'
            attibutes event:attrs()
      }
    }
}
