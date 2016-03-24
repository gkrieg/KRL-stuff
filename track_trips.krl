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
      {
      send_directive("trip") with
            trip_length = mileage;
      }
      fired {
      raise explicit event 'trip_processed'
          attributes event:attrs();
      }
    }

    rule find_long_trips{
      select when explicit trip_processed
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



    rule createWellKnown {
        select when wrangler init_events
        pre {
          attr = {}.put(["channel_name"],"Well_Known")
                          .put(["channel_type"],"Pico_Tutorial")
                          .put(["attributes"],"")
                          .put(["policy"],"")
                          ;
        }
        {
            event:send({"cid": meta:eci()}, "wrangler", "channel_creation_requested")
            with attrs = attr.klog("attributes: ");
        }
        always {
          log("created wellknown channel");
        }
      }


rule wellKnownCreated {
    select when wrangler channel_created where channel_name eq "Well_Known" && channel_type eq "Pico_Tutorial"
    pre {
        // find parent
        parent_results = wrangler_api:parent();
        parent = parent_results{'parent'};
        parent_eci = parent[0].klog("parent eci: ");
        well_known = wrangler_api:channel("Well_Known").klog("well known: ");
        well_known_eci = well_known{"cid"};
        init_attributes = event:attrs();
        attributes = init_attributes.put(["well_known"],well_known_eci);
    }
    {
        event:send({"cid":parent_eci.klog("parent_eci: ")}, "subscriptions", "child_well_known_created")
            with attrs = attributes.klog("event:send attrs: ");
    }
    always {
      log("parent notified of well known channel");
    }
  }
}
