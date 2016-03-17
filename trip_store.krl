ruleset trip_store {
    meta {
        name "Trip Store"
        description <<
        a second ruleset for storing trips
        >>
        author "Spencer Krieger"
        logging on
        sharing on
    }
    global {
        long_trip = 100
    }

    rule collect_trips {
      select when explicit trip_processed
      pre{
        trip = {"mileage": event:attr("mileage"), "date": event:attr("date")};
      }
      {
      send_directive("adding") with
            trip_length = trip{"mileage"};
      }
      fired {
      set ent:trips ent:trips.append(trip)
      }
    }

    rule collect_long_trips{
      select when explicit found_long_trip
      pre{
        mileage = event:attr("mileage").klog("our passed in input: ");
      }
      if (mileage > long_trip) then {
        send_directive("found_long_trip") with
          trip_length = mileage;
        }

      fired {
        raise explicit event 'found_long_trip'
          attributes event:attrs();
        }
      }
}
