######################## Placement ########################### 
# Do sanity checks for each stage 
# get_cell_count
sizeof_collection [get_flat_cells -all ]

# get_utilization 
create_utilization_configuration -include all fp_uti
report_utilization -config fp_uti
report_utilization -config fp_uti -of_objects [get_voltage_areas PD_RISC_CORE ]
report_utilization -config fp_uti -of_objects [get_voltage_areas DEFAULT_VA]

# Check pg connectivity 
# read_mcmm
source ./inputs/sdc_constraints/mcmm_ORCA_TOP.tcl

#############################################placement options #################################
# Fix macros 
set_fixed_objects [get_flat_cells -filter "is_hard_macro"]


# read scandef 
read_def ./inputs/ORCA_TOP.scandef

# set TIE cell as dont touch and dont use 
## Tie cell attributes
set_attribute [get_lib_cells *TIE*] dont_touch false
set_attribute [get_lib_cells *TIE*] dont_use false
 
# Set app option for leagalize_placement 
set_app_options -name place.legalize.enable_advanced_legalizer -value true
set_app_options -name place.legalize.legalizer_search_and_repair -value true

# Mention constraints for placement 

# Set loacal cell density 
set_app_options -name place.coarse.max_density -value 0.7

# Set max fanout value 
set_app_options -name opt.common.max_fanout -value 30

# set layers used 
# M9 : full chip 
# M7 and M8 : power straps 
# M6 M5 M4 M3 M2 : used for routing 
# M1 : Used inside std_cell 
set_ignored_layers -max_routing_layer M6 -min_routing_layer M2
set_app_options -name route.common.global_max_layer_mode -value hard
set_app_options -name route.common.global_min_layer_mode -value allow_pin_connection

# Set clock path ideal 
set_ideal_network -no_propagate [all_fanout -clock_tree ]

# Disable ccd flow 
# set_app_options -name place_opt.flow.enable_ccd -value false

# Give prefix to cells added during placement stage 
set_app_option -name opt.common.user_instance_name_prefix -value "place_opt_"

# Disable zero interconnect delay 
reset_app_options time.delay_calculation_style

# Enable rde 
set_app_options -name opt.common.enable_rde -value true


#############################################################################################
# Perform  coarse placment 
create_placement

# Legalize placement  
legalize_placement

# Save block 
save_block -as coarse_placement_done

# Fly lines 
# net_connection : direct connection, we can enable connected load 
# Dataflow flylines : It allows tracing cells in between 

# Check congestion 
# Small region called as gcell 
# Congestion : Required_tracks - Available tracks 
	# Global routing : Estimation of detail routing 
	# Virtual routing : direct connection between 2 pins 
	report_congestion -rerun_global_router
	# Reason for congestion is 
		# a) No proper distribution of utilization to voltage areas  	
		# b) No blockages in macro channels  
		# c) No proper macro spacing 
	
	# a) reset placement 
		reset_placement 

	# Unfix macros 
		set_fixed_objects [get_flat_cells -filter "is_hard_macro"] -unfix

	# b) removing endcap and tap cells
		remove_cells [get_flat_cells -all *boundary*]
		remove_cells [get_flat_cells -all *tap*] 	
 
	# Remove voltage area
		remove_voltage_area *

	# c) Increase macro spacing 
		Done in gui
 
	# d) changing voltage 
		# go to script folder  	
		cp /home/deepaksn/PD_Adv_Aug23/ORCA_TOP/PD/scripts/va_new.tcl .
		source ./scripts/va_new.tcl

	# e) Source power plan and Check pg connectivity 
create_routing_blockage -layers M1 -boundary "{741.7940 10.0160} {746.7600 177.216}" -net_types power
		source ./scripts/powerfinal.tcl
		check_pg_connectivity -check_std_cell_pins none
		# Fix violations
	
	# f)  Add end cap cells and tap cells 
set_boundary_cell_rules -left_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -right_boundary_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -at_va_boundary 
compile_boundary_cells
check_boundary_cells

create_tap_cells -lib_cell saed32_hvt|saed32_hvt_std/DCAP_HVT -skip_fixed_cells -distance 30 -pattern stagger
check_legality

connect_pg_net  
check_pg_connectivity -check_std_cell_pins none
check_pg_drc 

# if pg is not clean 
source ./scripts/powerfinal.tcl
check_pg_connectivity -check_std_cell_pins none
check_pg_drc 

# Some basic checks 
check_pg_drc
check_pg_connectivity  
report_utilization -config fp_uti 
# : 0.85
report_utilization -config fp_uti -of_objects [get_voltage_areas PD_RISC_CORE ]  
# : 0.87
report_utilization -config fp_uti -of_objects [get_voltage_areas DEFAULT_VA] 
# : 0.85
check_legality 
# Fix macros 
set_fixed_objects [get_flat_cells -filter "is_hard_macro"]

# f) Apply partial blockage in macro channel 
	# Apply soft placement blockage in macro channel 
	derive_placement_blockages -force
 
	# h) create coarse placement and check congestion .
	create_placement
	legalize_placement
	 

#############################################################################################
# reset_placement 
#Unfix macros 
#remove tap and endcap cells 

# Do macro changes 
# source ./scripts/va_redone.tcl
# source ./scripts/blockage.tcl 
# source powerplan 
	# create_placement 
	# legalize_placement 
	# report_congestion -rerun_global_route 
	# If u have congestion less 0.5% goto next stage 
	# save_block 
	
# Fix power plan issues
	# reset_placement 
	# Unfix macros 	 	
	# remove_routing_blockages *
	create_routing_blockage -net_types power -boundary {{5 5} {9.95 177.2160}} -layers M1
	# remove_placement_blockages -all
	# Fix pg connectivity 
	# Fix pg drc
	# Add tap cells and boundary cells 
	# connect_pg_net
	# check_pg_connectivity and pg_drc 
	# source powerplan again 
	# fix macros 
	# source ./scripts/blockage.tcl 
	# create_placement 
	# legalize_placement 
	# report_congestion -rerun_global_route
save_block -as final_coarse_placement_done
	
# Restrict lvt cells usage 
set_attribute [get_lib_cells *lvt*/*] threshold_voltage_group LVT
set_threshold_voltage_group_type -type low_vt LVT
 set_multi_vth_constraint -low_vt_percentage 30 -cost cell_count

# 1)  reset_placement 
# 2) remove_placement_blockages 
# 3) unfix_macros 
# 4) remove tap cells and endcap cells 
# 5) change_floorplan 
# 6) source powerplan 
# 7) fix powerplan issues 
# 8) add tap cells and end cap cells 
# 9) connect_pg_net
# 10) source powerplan again 
# 11) check_pg_connectivity and pg_drc 
# 12) fix macros 
# 13) source ./scripts/blockage.tcl
# 14) remove uncessary blockage  
# source all required placement options 
# 15) create_placement 
# 16) legalize_placement 
# 17) report_congestion -rerun_global_route
# 18) if congestion is less 
place_opt -from  initial_drc
save_block -as place_opt_done_final 

# congestion report 
# max_cap and max_trans count 
route_global 
report_constraints -all_violators -max_capacitance 
report_constraints -all_violators -max_transition 
# place_opt steps 
	# Coarse placement
	# HFNS and fixing max_cap and max_trans  
	# data path optimization 
	# final coarse placement
	# final datapath optimization

########################################## checks after placement  #############################
# 1) Check congestion 
report_congestion -rerun_global_router 
		# Change floor to get better congestion results 
		# Apply bounds and control cell placement 
		# Apply keepout margin and spread cells 
		# Control cell placement in macro channel by applying partial or soft blockage 

# Check pg DRC
check_pg_drc
 
# Check PG connectivity 
remove_routes -global_route
check_pg_connectivity

# Logical/timing DRCs (max_transition , max_capacitance ) 
# max_trans_slack = required_transition - Actual_transition 
# max_cap_slack = required_capacitance - Actual_capacitance 

# Do global routing 
route_global

# report fanout of nets 
report_net_fanout [get_flat_nets -filter "net_type != clock"] -threshold 31 -nosplit

# Report max_transition violation 
report_constraints -scenarios func.ss_125c -all_violators -max_transition -nosplit -significant_digits 3 > ./outputs/mtv.txt

report_constraints -scenarios func.ss_m40c -max_transition -all_violators -nosplit > ./outputs/mtv.txt


# Report max_transition capacitance 
report_constraints -scenarios func.ss_125c -all_violators -max_capacitance -nosplit -significant_digits 3 > ./outputs/mcv.txt

report_constraints -scenarios func.ss_m40c -max_capacitance -all_violators -nosplit > ./outputs/mtv.txt


# Fixing max_trans and max_cap violations . 
# max_trans fixing 
	# Upsize driver/Vt swap driver
	
# Find driver name of a net  
set dn [get_cells -of_objects [get_pins -filter "direction ==out"  [all_connected I_SDRAM_TOP/I_SDRAM_IF/n9845 -leaf]]]

# Find ref_name of a driver 
get_attribute [get_cells $dn] ref_name

# Upsize driver 
size_cell $dn AO22X2_HVT

# Upsize fails 
	 # 1) If Driver is a macro 
	 # 2) If driver is at highest drive strength 
	 source ./scripts/upsize_driver.tcl
	  legalize_placement -incremental

# Insert_buffer method 
	# Based on global route find location where buffer has to inserted add placement blockage 
	change_selection [get_nets I_SDRAM_TOP/I_SDRAM_IF/n10990]
 
 	# find the driver pin of violated net 
 	set dpn [get_pins -filter "direction == out"  [all_connected -leaf I_SDRAM_TOP/I_SDRAM_IF/n9845]]

	# insert_buffer at the driver pin  
	set bn [insert_buffer $dpn NBUFFX8_HVT]

	# put blockage at that point and get co-ordinates 
	get_attribute [get_placement_blockages pb_0] bbox
	
	# move newly added buffer to new location 
	move_objects [get_cells $bn] -to {495.6560 86.9280}

# Check fanout limit 
report_net_fanout -threshold 31

# Setup violations 
report_global_timing 

# Fixing setup violation 
	# Upsize the combo cell 
		# More transition on pin (> 0.7ns)  
	# Vt swapping (HVT --> RVT --> LVT)  
	report_timing -transition_time -nosplit -significant_digits 3 -max_paths 175 > ./outputs/sv_aro.txt
	source ./scripts/bottle_neck_cell.tcl
	 size_cell I_BLENDER_1/U3693 INVX1_LVT
	# Load splitting 
	# Path grouping : group the paths and assign weigtage to most violating paths which has to be given more importance during 
			# optimization 
			# cost = WNS in group * Weightage 
		group_path -from [get_flat_cells *I_BLENDER*] -to [get_flat_cells *I_BLENDER*] -weight 5 -name i_blender
		group_path -from [get_flat_cells *I_PARSER*] -to [get_flat_cells *I_PARSER*] -weight 3 -name i_parser
		group_path -from [get_flat_cells *I_SDRAM_TOP*] -to [get_flat_cells *I_SDRAM_TOP*] -weight 4 -name i_sdram
		remove_routes -global_route 
		place_opt -from initial_opto
		save_block -as place_opt_done_with_pg
		route_global
		report_global_timing 	:
