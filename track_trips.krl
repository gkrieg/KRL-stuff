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
        long_trip = 100
    }

    rule process_trip {
      select when car new_trip
      pre{
        mileage = event:attr("mileage").klog("our passed in input: ");
      }

      always {
      raise explicit event trip_processed
          attributes {
          "hotcross": "buns"}
      }
    }

    rule find_long_trips{
      select when explicit trip_processed
      pre{
        mileage = event:attr("mileage").klog("our passed in other input: ");
      }
      send_directive("trip") with
            trip_length = mileage;

      fired {
        raise explicit event 'found_long_trip'
        }
      }
}
