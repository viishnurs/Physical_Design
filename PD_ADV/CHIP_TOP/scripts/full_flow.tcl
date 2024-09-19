set search_path {/home/tools/14nm_Libraries/stdcell_hvt/ndm /home/tools/14nm_Libraries/stdcell_lvt/ndm /home/tools/14nm_Libraries/stdcell_rvt/ndm}
set ref_libs {/hdd2/home/ajayaz/.zeni/14_nm_main/HVT/ss/icc2_cell_lib/saed14_hvt_ss_normal.ndm /hdd2/home/ajayaz/.zeni/14_nm_main/LVT/ss/icc2_cell_lib/saed14_lvt_ss_normal.ndm /hdd2/home/ajayaz/.zeni/14_nm_main/RVT/ss/icc2_cell_lib/saed14_rvt_ss_normal.ndm }

#set tech_file /hdd2/home/ajayaz/saed14nm_1p9m_mw.tf
#set tech_file /home/tools/14nm_Libraries/tech/milkyway/saed14nm_1p9m_mw.tf
set tech_file /hdd2/home/ajayaz/14nm/inputs/saed14nm_1p9m_mw.tf
### Import_design
create_lib -ref_libs $ref_libs -technology $tech_file srams.nlib
derive_design_level_via_regions
read_verilog /hdd2/home/ajayaz/14nm/synthesis/bw_r_dcd.scan.v
set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction horizontal
set_attribute [get_layers {M2 M4 M6 M8 MRDL}] routing_direction vertical

### Timing Information
create_mode func
create_clock -name rclk -period 1 [get_ports rclk]
read_parasitic_tech -tlup /home/tools/14nm_Libraries/tech/star_rc/max/saed14nm_1p9m_Cmax.tluplus -layermap /home/tools/14nm_Libraries/tech/star_rc/saed14nm_tf_itf_tluplus.map -name Cmax
read_parasitic_tech -tlup /home/tools/14nm_Libraries/tech/star_rc/min/saed14nm_1p9m_Cmin.tluplus -layermap /home/tools/14nm_Libraries/tech/star_rc/saed14nm_tf_itf_tluplus.map -name Cmin
create_corner worst
create_corner best
current_corner worst
set_process_number 1.01
set_voltage 0.72
set_temperature 125
set_parasitic_parameters -early_spec Cmax -late_spec Cmax
set_timing_derate  -late 1.03 -cell_delay -net_delay
set_timing_derate  -early 0.95 -cell_delay -net_delay
current_corner best
set_process_number 0.99
set_voltage 0.6
set_temperature -40
set_parasitic_parameters -early_spec Cmin -late_spec Cmin
set_timing_derate  -late 1.05 -cell_delay -net_delay
set_timing_derate  -early 0.97 -cell_delay -net_delay
create_scenario -mode func -corner worst -name func_worst
create_scenario -mode func -corner best -name func_best
current_scenario func_worst
set_input_delay -clock rclk  0.3 [remove_from_collection [all_inputs] rclk]
set_output_delay -clock rclk 0.7 [all_outputs]
current_scenario func_best
set_input_delay -clock rclk  0.3 [remove_from_collection [all_inputs] rclk]
set_output_delay -clock rclk 0.7 [all_outputs]
set_scenario_status func_worst -hold false
set_scenario_status func_best -setup false
set_scenario_status  {func_worst func_best} -dynamic_power false -leakage_power false
set_scenario_status  {func_worst} -dynamic_power true -leakage_power true
save_block -as import_design

###FLOORPLAN
initialize_floorplan -core_utilization 0.7 -core_offset {10 15 10 15} -side_ratio {1 2}
place_pins -self

###set_target_library_subset [get_libs saed14_rvt_ss_normal] -only_here [get_lib_cells */]

###UPF INFORMATION
#create_power_domain PD_TOP -include_scope
#create_supply_net VSS -domain PD_TOP
#create_supply_net VDD -domain PD_TOP
#set_domain_supply_net PD_TOP -primary_power_net VDD -primary_ground_net VSS
#create_supply_port VDD -domain PD_TOP -direction in
#create_supply_port VSS -domain PD_TOP -direction in
#connect_supply_net VSS -ports VSS
#connect_supply_net VDD -ports VDD
#add_port_state VSS -state {always 0.000000}
#add_port_state VDD -state {V0p72 0.720000}
#add_port_state VDD -state {V0p60 0.600000}
#create_pst power_state -supplies [list VDD VSS]
#add_pst_state risc_high_worst -pst power_state -state {V0p72 always}
#add_pst_state risc_low_worst -pst power_state -state {V0p60 always}

### POWER INFORMATION
remove_pg_strategies -all
remove_pg_patterns -all
remove_pg_regions -all
remove_pg_via_master_rules -all
remove_pg_strategy_via_rules -all
remove_routes -net_types {power ground} -ring -stripe -macro_pin_connect -lib_cell_pin_connect
connect_pg_net

### STRAPS
set_pg_via_master_rule pgvia_8x10 -via_array_dimension {15 8}
set_pg_via_master_rule pgvia_8x10 -via_array_dimension {15 8}
create_pg_mesh_pattern -layers {{ {horizontal_layer: M5} {width: 1.104} {spacing: interleaving} {pitch: 13.376} {offset: 0.856} {trim : true} } { {vertical_layer: M4}   {width: 4.64 } {spacing: interleaving} {pitch: 19.456} {offset: 6.08}  {trim : true} }} -via_rule {{intersection: adjacent} {via_master : pgvia_8x10}} P_top_two
set_pg_strategy S_default_vddvss -core -pattern   { {name: P_top_two} {nets:{VSS VDD}} {offset_start: {0 0}} } -extension { {{stop:design_boundary_and_generate_pin}} }
compile_pg -strategies {S_default_vddvss }

### Rails
create_pg_std_cell_conn_pattern P_std_cell_rail
set_pg_strategy S_std_cell_rail_VSS_VDD -core -pattern {{pattern: P_std_cell_rail}{nets: {VSS VDD}}} -extension {{stop: outermost_ring}{direction: L  R  }}
set_pg_strategy_via_rule S_via_stdcellrail -via_rule {{intersection: adjacent}{via_master: default}}
compile_pg -strategies {S_std_cell_rail_VSS_VDD} -via_rule {S_via_stdcellrail}
save_block -as powerplan

### PLACEMENT
set_app_options -name place.coarse.continue_on_missing_scandef -value true
set_app_options -name place.legalize.enable_advanced_legalizer -value true
set_app_options -name place.legalize.enable_allowable_orient -value true
#set_app_options -name place.legalize.half_row_offset_cell_legalization -value true
#set_app_options -name place_opt.flow.do_path_opt -value true
#set_app_options -name opt.common.max_net_length -value 100
#set_app_options -name opt.common.max_fanout -value 20
set_app_options -name opt.common.user_instance_name_prefix -value place_opt_data_
set_app_options -name cts.common.user_instance_name_prefix -value place_opt_clock_
set_ignored_layers -max_routing_layer M5
set_ignored_layers -min_routing_layer M2
place_opt
save_block -as place_opt

### CTS
connect_pg_net -verbose
set_lib_cell_purpose -exclude cts [get_lib_cells] 
set_lib_cell_purpose -include cts [get_lib_cells */*CK*]

set enable_recovery_removal_arcs true

remove_routing_rules -all 
create_routing_rule iccrm_clock_double_spacing -default_reference_rule -multiplier_spacing 2 
set_clock_routing_rules -net_type sink -rules iccrm_clock_double_spacing -min_routing_layer M2 -max_routing_layer M3
foreach_in_collection mode [all_modes] {
   current_mode $mode
   set_clock_balance_points \
      -consider_for_balancing true
}
set_lib_cell_purpose -include cts [get_lib_cells */*BUF*]
#set_lib_cell_purpose -include cts [get_lib_cells */*INV*]

set_app_options -name time.remove_clock_reconvergence_pessimism -value true

set_app_option -name opt.common.user_instance_name_prefix -value clock_opt_data_
set_app_option -name cts.common.user_instance_name_prefix -value clock_opt_clock_
clock_opt -to build_clock ; save_block -as cts_build_clock
save_block -as cts_build_clock
clock_opt -to route_clock ; save_block -as cts_route__clock
save_block -as cts_route_clock
route_auto -save_after_global_route true -save_after_track_assignment true  -save_after_detail_route true
clock_opt -to final_opto ; save_block -as cts_final_opto
set_app_options -name route.common.connect_floating_shapes -value true
set_app_options -name time.si_enable_analysis -value -true
route_auto 
save_block -as route
