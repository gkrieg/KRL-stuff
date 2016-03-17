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
        long_trip = 100;
        trips_func = function(trips) {
        trips_return = trips;
        };
        long_trips_func = function(long_trips) {
          long_trips_return = long_trips;
        };

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
        long_trip = {"mileage": event:attr("mileage"), "date": event:attr("date")};
      }
      {
      send_directive("adding_long") with
            trip_length = trip{"mileage"};
      }

      fired {
        set ent:long_trips ent:long_trips.append(long_trip)
        }
      }

      rule clear_trips {
        select when explicit trip_processed
        {
        send_directive("erasing") with
              trip_length = trip{"mileage"};
        }
        fired {
        clear ent:trips
        clear ent:long_trips
        }
      }
}
