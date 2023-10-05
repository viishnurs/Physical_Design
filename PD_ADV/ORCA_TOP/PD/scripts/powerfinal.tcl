# PG pattern : Will describe the physical attributes of metal_layer ,spacing , width , direction .pitch 
# PG strategy : How to use PG pattern in design
# Via : Via is used to connect metal from one metal layer to another  

remove_pg_strategies -all
remove_pg_patterns -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_strategy_via_rules -all
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect

connect_pg_net


set_pg_via_master_rule pgvia_8x10 -via_array_dimension {8 10}


set all_macros [get_cells -hierarchical -filter "is_hard_macro"]
set hm(risc_core) [get_flat_cells -filter "is_hard_macro" I_RISC_CORE/*]
set hm(top) [remove_from_collection $all_macros $hm(risc_core)]

suppress PGR-599
#create_keepout_margin -outer {3 3 3 3}  $all_macros

################################################################################
# Build the main power mesh.  Consists of:
# * a coarse mesh on m7/m8
# * a finer mesh on M2 - vertical only - to connect to the std cell rails
#

# Create straps with hori layer M7- W - 1.104 , P - 13.376 ,   Offset - 0.856 
# Create straps with Veri layer M8 - W - 4.64 , P - 19.456 ,    Offset - 6.08  

create_pg_mesh_pattern P_top_two -layers { { {horizontal_layer: M7} {width: 1.104} {spacing: interleaving} {pitch: 13.376} {offset: 0.856} {trim : true} } { {vertical_layer: M8}   {width: 4.64 } {spacing: interleaving} {pitch: 19.456} {offset: 6.08}  {trim : true} } } -via_rule { {intersection: adjacent} {via_master : pgvia_8x10} }

# Lower mesh : Ver layer is M2, align to the track , Width is for 3 differnt straps  
create_pg_mesh_pattern P_m2_triple -layers { { {vertical_layer: M2}  {track_alignment : track} {width: 0.44 0.192 0.192} {spacing: 2.724 3.456} {pitch: 9.728} {offset: 1.216} {trim : true} } }

##==> PG Strategy for M7 and M8 straps 
	# Default Voltage area
set_pg_strategy S_default_vddvss -core -pattern   { {name: P_top_two} {nets:{VSS VDD}} {offset_start: {0 0}} } -blockage  { {{nets: VDD} {voltage_areas: PD_RISC_CORE}} } -extension { {{stop:design_boundary_and_generate_pin}} }
	# PD_RISC_CORE voltage area  
set_pg_strategy S_va_vddh -voltage_areas PD_RISC_CORE -pattern   { {name: P_top_two} {nets: {- VDDH}} {offset_start: {0 0}} } -extension { {{direction:TR} {stop:design_boundary_and_generate_pin}} }

##==> PG strategy for lower mesh - M2
	# Default Voltage area 
set_pg_strategy S_m2_vddvss -core -pattern   { {name: P_m2_triple} {nets: {VDD VSS VSS}} {offset_start: {0 0}} } -blockage  { {{nets: VDD} {voltage_areas: PD_RISC_CORE}} {macros_with_keepout: $all_macros} } -extension {{stop:keep_floating_wire_piecies} }
	# PD Risc core voltage are 
set_pg_strategy S_m2_vddh -voltage_areas PD_RISC_CORE -pattern   { {name: P_m2_triple} {nets: {VDDH - -}} {offset_start: {0 0}} } -blockage  { {macros_with_keepout: $hm(risc_core)} } -extension { {{direction:T} {stop:design_boundary_and_generate_pin} }}

# Via rules has been mentioned to connect M2 to M7
# set_pg_strategy_via_rule S_via_m2_m7 -via_rule { {{} {} } {{} {}} } 
set_pg_strategy_via_rule S_via_m2_m7 -via_rule { {  {{strategies: {S_m2_vddvss S_m2_vddh}}      {layers: { M2 }} {nets: {VDD VDDH}} }    {{strategies: {S_default_vddvss S_va_vddh}} {layers: { M7 }} }  {via_master: {default}} } {  {{strategies: {S_m2_vddvss S_m2_vddh}}      {layers: { M2 }} {nets: {VSS}} }    {{strategies: {S_default_vddvss S_va_vddh}} {layers: { M7 }} } {via_master: {default}} } }

compile_pg -strategies {S_va_vddh S_m2_vddh}
compile_pg -strategies {S_default_vddvss S_m2_vddvss} -via_rule {S_via_m2_m7}


########################################## Macro rings #################################
create_pg_ring_pattern MACRO_RING_PATTERN -horizontal_layer M5 -vertical_layer M6 -horizontal_width 0.52 -vertical_width 0.52

set_pg_strategy MACRO_RING_VDD_STRATEGY -pattern {{name: MACRO_RING_PATTERN} {nets: {VDD VSS}} {offset: {0.5 0.5}}} -macros $hm(top)

set_pg_strategy MACRO_RING_VDDH_STRATEGY -pattern {{name: MACRO_RING_PATTERN} {nets: {VDDH VSS}} {offset: {0.5 0.5}}} -macros $hm(risc_core)

set_pg_strategy_via_rule S_ring_vias -via_rule {\
			{{{strategies: {MACRO_RING_VDD_STRATEGY MACRO_RING_VDDH_STRATEGY}} {layers: {M5}}} {existing: {strap}} {via_master: {default}}} \
			{{{strategies: {MACRO_RING_VDD_STRATEGY MACRO_RING_VDDH_STRATEGY}} {layers: {M6}}} {existing: {strap}} {via_master: {default}}} \
	 }
compile_pg -strategies {MACRO_RING_VDD_STRATEGY MACRO_RING_VDDH_STRATEGY} -via_rule S_ring_vias

########### Macro pin connection ####################################
create_pg_macro_conn_pattern P_HM_pin -pin_conn_type scattered_pin  -layers {M5 M6}
set_pg_strategy S_HM_top_pins -macros $hm(top) -pattern { {pattern: P_HM_pin} {nets: {VSS VDD}} }
set_pg_strategy S_HM_risc_pins -macros $hm(risc_core) -pattern { {pattern: P_HM_pin} {nets: {VSS VDDH}} }

compile_pg -strategies {S_HM_top_pins S_HM_risc_pins }



################################################################################
# Build the standard cell rails

create_pg_std_cell_conn_pattern P_std_cell_rail

set_pg_strategy S_std_cell_rail_VSS_VDD -core -blockage  { {{nets: VDD} {voltage_areas: PD_RISC_CORE}} {macros_with_keepout: $all_macros} } -pattern {{pattern: P_std_cell_rail}{nets: {VSS VDD}}} 

set_pg_strategy S_std_cell_rail_VDDH -voltage_areas PD_RISC_CORE -blockage  {macros_with_keepout: $all_macros} -pattern {{pattern: P_std_cell_rail}{nets: {VDDH}}}

set_pg_strategy_via_rule S_via_stdcellrail -via_rule {{intersection: adjacent} {via_master: default}}

compile_pg -strategies {S_std_cell_rail_VSS_VDD S_std_cell_rail_VDDH} -via_rule {S_via_stdcellrail}

return

check_pg_missing_vias
check_pg_drc -ignore_std_cells
check_pg_connectivity -check_std_cell_pins none
