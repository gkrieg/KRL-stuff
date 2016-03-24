ruleset manage_fleet {
    meta {
        name "Manage Fleet"
        description <<
        a ruleset for managing fleets
        >>
        author "Spencer Krieger"
        logging on
        sharing on

        use module  b507199x5 alias wranglerOS
        provides children
    }
    global {
      children = function() {
        results = wranglerOS:children();
        children = results{"children"};
        children
      }
    }

    rule create_vehicle {
      select when car new_vehicle
      pre{
      attributes = {}
      .put(["Prototype_rids"],"b507739x3.dev") // semicolon separated rulesets the child needs installed at creation
      .put(["name"],event:attr("name")) // name for child
                              ;
    }
    {
    send_directive("creating");
    event:send({"cid":meta:eci()}, "wrangler", "child_creation")  // wrangler os event.
      with attrs = attributes.klog("attributes: "); // needs a name attribute for child
    }

	}

  rule requestSubscription { // ruleset for parent
    select when subscriptions child_well_known_created well_known re#(.*)# setting (sibling_well_known_eci)
            and subscriptions child_well_known_created well_known re#(.*)# setting (child_well_known_eci)
   pre {
      attributes = {}.put(["name"],"brothers")
                      .put(["name_space"],"Tutorial_Subscriptions")
                      .put(["my_role"],"BrotherB")
                      .put(["your_role"],"BrotherA")
                      .put(["target_eci"],child_well_known_eci.klog("target Eci: "))
                      .put(["channel_type"],"Pico_Tutorial")
                      .put(["attrs"],"success")
                      ;
    }
    {
        send_directive("creating subscription");
        event:send({"cid":sibling_well_known_eci.klog("sibling_well_known_eci: ")}, "wrangler", "subscription")
            with attrs = attributes.klog("attributes for subscription: ");
    }
    always{

      log("send child well known " +sibling_well_known_eci+ "subscription event for child well known "+child_well_known_eci);
    }
}

}
