######################## Placement ########################### 
# Do sanity checks for each stage 
# get_cell_count
sizeof_collection [get_flat_cells -all ]

# get_utilization 
create_utilization_configuration -include all fp_uti
report_utilization -config fp_uti
report_utilization -config fp_uti -of_objects [get_voltage_areas PD_RISC_CORE ]
report_utilization -config fp_uti -of_objects [get_voltage_areas DEFAULT_VA]

# Fix macros 
set_fixed_objects [get_flat_cells -filter "is_hard_macro"]

# Check pg connectivity 
# read_mcmm
source ./inputs/sdc_constraints/mcmm_ORCA_TOP.tcl

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
set_app_options -name place.coarse.max_density -value 0.8

# Set max fanout value 
set_app_options -name opt.common.max_fanout -value 20

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
set_app_options -name place_opt.flow.enable_ccd -value false

# Give prefix to cells added during placement stage 
set_app_option -name opt.common.user_instance_name_prefix -value "place_opt_"

# Disable zero interconnect delay 
reset_app_options time.delay_calculation_style

# Perform  coarse placment 
create_placement

# Legalize placement  
legalize_placement

# Save block 
save_block -as coarse_placement_done

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
 


	# c) Increase macro spacing  
	# d) changing voltage 
	# e) Check pg connectivity 
	# f) Apply partial blockage in macro channel 
	# g) add tap and end cap cells 
	# h) create coarse placement and check congestion .  
