###code for powerplanning 
###### VISHNU RS########################
########################################

connect_pg_net 

create_pg_ring_pattern VDD_VSS_RING -hotizontal_layers M7 -horizontal_width 0.112 -vertical_layers M8 -vertical_width 0.112 -nets {VDD VSS}

set_pg_strategy VDD_VSS_RING_STARATEGY -pattern {{name: VDD_VSS_RING } {nets: VDD VSS} } -core

complie_pg_startegies {VDD_VSS_RING_STARATEGY}

source ./scripts/powerfinal.tcl
