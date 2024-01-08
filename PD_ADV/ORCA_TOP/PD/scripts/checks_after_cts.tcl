# 1) Find Number of ICGs in design - 23
sizeof_collection [get_clock_gates]

# 1.1) Find Name of all ICGs 
get_clock_gates 

# 2) Find number of flip-flops connecting to a clock (PCI_CLK) 
sizeof_collection [ all_registers -clock [get_clocks PCI_CLK]]

# 3) Write command to get WNS for setup and hold 
# Setup 
get_attribute [get_timing_paths -delay_type max ] slack
get_attribute [get_timing_paths -delay_type max ] logic_levels
get_attribute [get_timing_paths -delay_type max ] arrival
get_attribute [get_timing_paths -delay_type max ] required

# Hold 
get_attribute [get_timing_paths -delay_type min ] slack
get_attribute [get_timing_paths -delay_type min ] logic_levels
get_attribute [get_timing_paths -delay_type min ] arrival
get_attribute [get_timing_paths -delay_type min ] required

# 4) Find number of clock gating check violations 
 sizeof_collection [get_timing_paths -to [get_clock_gates ] -slack_lesser_than 0 -max_paths 20]

# 5)  Find whether it has clock gating cell . If ICG is present then it is present after
# how many logics 
# set  pi I_PCI_TOP/I_PCI_READ_FIFO/PCI_FIFO_CTL/U2/this_addr_g_int_reg[2]/CLK
# set pi I_PCI_TOP/I_PCI_CORE/mega_shift_reg[9][13]/CLK
get_flat_cells [all_fanin -to $pi -flat -only_cells] -filter "is_integrated_clock_gating_cell"] 

# To find logic level of ICG

proc ICG_TEST pi {
set i 0
set flag 1 
 
foreach_in_collection a [all_fanin -to $pi -flat -only_cells] {
set c [get_object_name $a] 
set b [get_attribute [get_cells $a] is_integrated_clock_gating_cell ]
	if {$b == true} {
		puts "$c is ICG at the level  $i" 
		set flag 0 
		break 	
	} 
incr i
}

if {$flag == 1}  {
puts "No ICG cells found " 
}  

} 



######################################### Checks After CTS ##########################################################################
# Check timing of Results 
report_global_timing

# Analyze / Report Latency and 
 report_clock_qor -type latency -scenarios func.ss_125c

# DRC violations in CTS path 
report_clock_qor -type drc_violators -scenarios func.ss_m40c


# report_min_pulse_width 
report_min_pulse_width -scenarios func.ss_125c -all_violators

# Check Timing 
# Usefull skew 
report_timing -path_type full_clock > ./outputs/sv_aco.txt

# get worst slack of next path  from capture flip-flop of current path 
get_attribute [get_timing_paths -from I_BLENDER_1/R_280/CLK] slack

# if slack in positive then insert buffer at capture ff clock pin 
insert_buffer I_BLENDER_1/R_280/CLK NBUFFX8_LVT

legalize_placement -incr 

# Hold Fixing 
report_timing -delay_type min
insert_buffer I_PCI_TOP/I_PCI_CORE/mega_shift_reg[10][23]/D NBUFFX2_HVT
size_cell I_PCI_TOP/eco_cell_7_0 DELLN1X2_HVT
legalize_placement -cell {I_PCI_TOP/eco_cell_4_0}
