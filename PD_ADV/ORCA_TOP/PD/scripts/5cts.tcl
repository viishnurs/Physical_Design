remove_routes -global_route 
# 1)  cells to be used in clock path 
	set_lib_cell_purpose -exclude cts [get_lib_cells]
	# a) cells already present in clock path 
	source ./scripts/cts_include_refs.tcl

	# b) cells to be inseted to build clock tree 
	set CTS_CELLS [get_lib_cells "*/NBUFF*LVT */INVX*_LVT /*DFF*"]
	set_lib_cell_purpose -include cts $CTS_CELLS

# 2)  Specify NDR
remove_routing_rules -all 
create_routing_rule iccrm_clock_double_spacing -default_reference_rule -multiplier_spacing 2 
set_clock_routing_rules  -rules iccrm_clock_double_spacing -min_routing_layer M4 -max_routing_layer M5

 
# 3) Timing constraints 
	# a) max_clock_transition 
	current_mode func
	set_max_transition 0.15 -clock_path [get_clocks] -corners [all_corners]

	# b) target skew
	set_clock_tree_options -target_skew 0.05 -corners [get_corners ss_125c]
	set_clock_tree_options -target_skew 0.05 -corners [get_corners ss_m40c]
	set_clock_tree_options -target_skew 0.02 -corners [get_corners ff_m40c]
	set_clock_tree_options -target_skew 0.02 -corners [get_corners ff_125c]

	# d) uncertainity 
	foreach_in_collection scen [all_scenarios] {
	current_scenario $scen
	set_clock_uncertainty 0.1 -setup [all_clocks]
	set_clock_uncertainty 0.05 -hold [all_clocks]
	}

	# e) Enable CRPR 
	set_app_options -name time.remove_clock_reconvergence_pessimism -value true

# 4) Mention clock tree exceptions 
		foreach_in_collection mode [all_modes] {
		current_mode $mode
		set_clock_balance_points \
      		-consider_for_balancing true \
      		-balance_points [get_pins "I_SDRAM_TOP/I_SDRAM_IF/sd_mux_*/S0"]
		}

	## Dont Touch Cells
		set_dont_touch [get_cells "I_SDRAM_TOP/I_SDRAM_IF/sd_mux_*"]
		report_dont_touch I_SDRAM_TOP/I_SDRAM_IF/sd_mux_*

		set_dont_touch [get_cells "I_CLOCKING/sys_clk_in_reg"]
		report_dont_touch I_CLOCKING/sys_clk_in_reg

# Strat building clock tree 
# i) Build clock tree
# ii) route clock tree 
# iii) optimize clock tress

clock_opt -to route_clock

set_lib_cell_purpose -exclude hold [get_lib_cells] 
set_lib_cell_purpose -include hold [get_lib_cells "*/DELLN*_RVT */NBUFFX2_RVT */NBUFFX4_RVT */NBUFFX8_RVT"]
set_app_options -list {opt.dft.clock_aware_scan true}
set_app_options -list {clock_opt.hold.effort high}

clock_opt -from final_opto
#save_block -as clock_opt_done 

