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

    }
    global {

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
      with attrs = event:attr("name").klog("attributes: "); // needs a name attribute for child
    }

	}
}
