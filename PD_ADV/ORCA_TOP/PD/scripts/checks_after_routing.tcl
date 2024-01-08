# Short-cuts 
# Delete - d 
# Extending - s 
# cutting metal layer - shift + l 
# for manual routing - shift + r 

# Checks after Routing  	
	# Check LVS 
	check_lvs -max_errors 0

# Check PG DRC
	check_pg_drc
	check_pg_connectivity 
	

# Checks DRC 
	check_routes

# To see cross talk reports 
report_delay_calculation -from  I_SDRAM_TOP/I_SDRAM_IF/U4691/Y -to I_SDRAM_TOP/I_SDRAM_IF/place_opt_ropt_mt_inst_23661/A -significant_digits 6 -crosstalk > ./outputs/ct.txt

# Insert buffer on routes 
get_attribute [get_nets I_SDRAM_TOP/net_sdram_if_wDQ[54]] dr_length
add_buffer_on_route [get_nets $nn] -repeater_distance $nld -lib_cell NBUFFX2_HVT

# upsize_driver.tcl
# insert_buffer_on_routes.tcl 
legalize_placement -incremental 
route_eco -reuse_existing_global_route true -utilize_dangling_wires true -reroute modified_nets_first_then_others

check violations again (max_cap and max_trans) 
check_routes

connect_pg_nets  
check_lvs -max_errors 0 
