# Go to ORCA_TOP folder 
# SPEF : Standard parasitic extraction format 
# STARRC inputs required : 
			# ndm library 
			# routed block (All routed layerys and cell frame views) 
			# nxtgrd files (Cmax Cmin) [from itf file ]
			# mapping file (map .tf and .itf) 

			# Cmax_spef (More delay) 
			# Cmin_spef (less delay) 

# Steps 
# Go to ORCA_TOP (/home/deepaksn/PD_Adv_Aug23/ORCA_TOP)  
mkdir STARRC 
cd STARRC 
mkdir inputs outputs scripts 
cd outputs 
mkdir work_dir SPEF  
cd ..

cd inputs 
cp /home/deepaksn/ORCA_TOP/STARRC/inputs/*.nxtgrd .
cp /home/deepaksn/ORCA_TOP/STARRC/inputs/*.map .

cd ../scripts
cp /home/deepaksn/ORCA_TOP/STARRC/scripts/* .
# open cbest_spef.cmd and paths 
# open cworst_spef.cmd and paths

# go to script folder 
cp /home/deepaksn/PD_Adv_Aug23/ORCA_TOP/STARRC/scripts/*.sh . 

# go to STARRC folder 
csh
source /home/tools/synopsys/cshrc_synopsys 
source ./scripts/best_spef.sh
source ./scripts/worst_spef.sh

############################################## Prime Time #########################################################  
# In ORCA_TOP folder 
mkdir 	PRIME_TIME
cd PRIME_TIME  
mkdir inputs outputs scripts 

# Inputs for primetime 
	# Route Netlist 
	# .sdc 
	# SPEF 
	# UPF 
	# .lib/.db 
	# ndm_lib and block
	
# go to ICC2 
	# open lib 
	# open routed block 
		write_verilog ./../PRIME_TIME/inputs/routed_netlist.v 
		write_sdc -scenario func.ss_125c -output ./../PRIME_TIME/inputs/orca_ss_125c.sdc
		write_sdc -scenario func.ff_m40c -output ./../PRIME_TIME/inputs/orca_ff_m40c.sdc

# go script folder of prime time 
cp /home/deepaksn/PD_Adv_Aug23/ORCA_TOP/PRIME_TIME/scripts/pt.tcl .

# edit pt.tcl 

# go to PRIME_TIME folder 
csh
source /home/tools/synopsys/cshrc_synopsys 
pt_shell -output_log_file ./outputs/30_12_23.log

# max_trans violation 
report_constraint -all_violators -max_transition

# Fixing max_trans 
fix_eco_drc -type max_transition -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT}

fix_eco_drc -type max_transition -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -cell_type {clock_network}

# Fixing max_cap 
fix_eco_drc -type max_capacitance -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -verbose 

 set_app_var eco_allow_sizing_with_lib_cell_attributes is_level_shifter

 fix_eco_drc -type max_capacitance -buffer_list {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT} -verbose -cell_type {clock_network

# Fix Setup Violations
fix_eco_timing -type setup -verbose

fix_eco_timing -type setup -cell_type {clock_network} -buffer_list  {NBUFFX2_HVT NBUFFX4_HVT NBUFFX8_HVT NBUFFX16_HVT NBUFFX2_RVT NBUFFX4_RVT NBUFFX8_RVT NBUFFX16_RVT NBUFFX2_LVT NBUFFX4_LVT NBUFFX8_LVT NBUFFX16_LVT}

# Write Changes 
write_changes -format icc2tcl -output ./../PD/inputs/change_pt.tcl

# Go to ICC2 
	# open lib 
	# open routed block
	source ./inputs/change_pt.tcl
	legalize_placement -incremental
	connect_pg_net 
	route_eco -reuse_existing_global_route true -utilize_dangling_wires true -reroute modified_nets_first_then_others

	check_routes
	check_lvs
	
