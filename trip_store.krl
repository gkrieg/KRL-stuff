ruleset trip_store {
    meta {
        name "Trip Store"
        description <<
        a second ruleset for storing trips
        >>
        author "Spencer Krieger"
        logging on
        sharing on
        provides trips, long_trips, short_trips
    }
    global {
        long_trip = 100;
        trips = function() {
          trips_arr = ent:trips;
          trips_arr
        }
        long_trips = function() {
          long_trips_arr = ent:long_trips;
          long_trips_arr
        }
        short_trips = function() {
          short_trips_arr = ent:trips.filter(function(x){x["mileage"] <= long_trip})
          short_trips_arr

        }
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
          trip_length = "50";
        }
        fired {
        clear ent:trips;
        clear ent:long_trips;
        }
      }
}
