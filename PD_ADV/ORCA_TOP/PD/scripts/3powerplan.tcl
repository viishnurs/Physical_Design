

###code for powerplanning 
###### VISHNU RS########################
########################################

#open_lib ./outputs/work/ORCA_TOP_MAIN.nlib

#open_block floor_plan_main

remove_pg_strategies -all
remove_pg_patterns -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_strategy_via_rules -all
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect


source ./scripts/boundary_tap.tcl

connect_pg_net 


create_pg_ring_pattern VDD_VSS_RING -horizontal_layer M7 -horizontal_width 0.112 -vertical_layer M8 -vertical_width 0.112 -nets {VDD VSS}

set_pg_strategy VDD_VSS_RING_STARATEGY -pattern {{name: VDD_VSS_RING } {nets: VDD VSS} } -core

compile_pg -strategies {VDD_VSS_RING_STARATEGY}

## create_pg_mesh

create_pg_mesh_pattern VDD_VSS_MESH -layers {{{horizontal_layer: M7} {width : 0.112} {spacing: interleaving} {offset : {1.5 1.5}} {trim : true}} {{vertical_layer: M8} {width : 0.112} {spacing: interleaving} {offset : {1.5 1.5}} {trim : true}}}

set_pg_strategy VDD_VSS_MESH_STRATEGY -pattern {{name: VDD_VSS_MESH} {nets: VDD VSS}} -core


compile_pg -strategies VDD_VSS_MESH_STRATEGY


source ./scripts/powerfinal.tcl

save_block -as power_plan_main
