# Routing 
# Global routing
set_app_options -name route.global.timing_driven -value true
set_app_options -name route.global.crosstalk_driven   -value true

# track assignment 
set_app_options -name route.track.timing_driven -value true
set_app_options -name route.track.crosstalk_driven -value true

# detail routing 
 set_app_options -name route.detail.timing_driven -value true

# Timing options 
set_app_options -name time.si_enable_analysis -value true
set_app_options -name time.enable_si_timing_windows -value true
set_app_options -name time.si_xtalk_composite_aggr_mode -value  statistical

# start routing 
route_auto -save_after_global_route true -save_after_track_assignment true -save_after_detail_route true 

# Post routing optimization 
route_opt

save_block -as route_opt_done 
