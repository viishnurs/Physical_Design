remove_pg_patterns -all
remove_pg_strategies -all
remove_pg_patterns -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_strategy_via_rules -all
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect
remove_shapes [get_shapes -hierarchical -filter "shape_use == follow_pin" ] -force


#This  command removes the specified power ground strategy. Use the -all option to remove all power ground strategies.#
#  
connect_pg_net
 
 
################################ M7 ###########################
#min_width : 0.06 
#m7 metal width : 8 * min_width 
create_pg_mesh_pattern m7_patternPD -layers {{{horizontal_layer : M7} {width : 0.48} {spacing : interleaving 5} {track_alignment : track} {pitch :9.6} {offset : 0.36}}}
set_pg_strategy m7_stgPD -pattern {{name : m7_patternPD} {nets : VDD VSS}} -core
compile_pg -strategies m7_stgPD

################################## Macro power connectivity  ##################
create_pg_macro_conn_pattern -pin_conn_type scattered_pin -nets {VDD VSS} macro_pin_connPD
set_pg_strategy -pattern {{pattern : macro_pin_connPD} {nets : {VDD VSS}}} macro_pin_strategyPD -core
compile_pg -strategies macro_pin_strategyPD

############################## M8 ########################
#min_width : 0.06
#m8_metal width : 10* min_width 
create_pg_mesh_pattern M8_pattern -layers {{vertical_layer : M8} {width :0.6} {spacing : 0.24} {pitch : 1.8} {track_alignment : track} {trim : false} {offset : 0.36}}
set_pg_strategy m8_stgPD -pattern {{name : M8_pattern} {nets : VDD VSS}} -core
 compile_pg -strategies m8_stgPD

###################### M9 #########################
#min_width : 0.06
#m8_metal width : 10* min_width 

create_pg_mesh_pattern M9_pattern -layers {{horizontal_layer : M9} {width :0.6} {spacing : 0.24} {pitch : 1.8} {track_alignment : track} {trim : false} {offset : 0.36}}
set_pg_strategy m9_stg -pattern {{name : M9_pattern} {nets : VDD VSS}} -core
compile_pg -strategies m9_stg


set_app_options -name plan.pgroute.disable_via_creation -value true
############################# M4 #####################

 
set a [get_cells -hierarchical -filter "is_hard_macro"]

create_pg_mesh_pattern -layers {{vertical_layer : M4} {width : 0.12} {spacing : 0.08} {pitch : 3.5} {track_alignment : track} {trim : false}} m4_mesh_vol
set_pg_strategy -core -pattern {{pattern : m4_mesh_vol} {nets : VDD VSS}} -blockage {{macros_with_keepout : $a}}  m4_mesh_vol_str
compile_pg -strategies m4_mesh_vol_str -tag m4_mesh_vol


#################### Via creation from M4 to M7 ###################
set_pg_via_master_rule -via_array_dimension {1 2} via4567
create_pg_vias -from_layers M7 -to_layers M4 -via_masters via4567 -nets {VDD VSS}


######################### M1  rails  ###############################
create_pg_std_cell_conn_pattern -layers M1 rails
puts $a
set_pg_strategy -core -pattern {{pattern : rails} {nets : VDD VSS}} -blockage {{macros_with_keepout : $a}} rails_strg
compile_pg -strategies rails_strg

######################## via creation from M1 -to M4 ###################
set_pg_via_master_rule -via_array_dimension {1 1} via1234
create_pg_vias -from_layers M4 -to_layers M1 -via_masters via1234 -nets {VDD VSS}
