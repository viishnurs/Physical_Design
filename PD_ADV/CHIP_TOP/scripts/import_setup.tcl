source ./scripts/common_setup.tcl
    set link_library  $LINK_LIBRARY_FILES_MVT
    set target_library $TARGET_LIBRARY_FILES_MVT
    set power "VDD"
    set ground "VSS"
    create_lib -ref_libs $NDM_REFERENCE_LIB_DIRS_MVT -technology $TECH_FILE ./outputs/works/chiptop2.nlib
    #create_lib -ref_libs $NDM_REFERENCE_LIB_DIRS_MVT -technology $TECH_FILE ./outputs/works/chiptop2.nlib
    puts $NDM_REFERENCE_LIB_DIRS
    puts $TECH_FILE
    puts $TLUPLUS_MAX_FILE
    read_parasitic_tech -tlup $TLUPLUS_MAX_FILE  -layermap  $MAP_FILE
    read_parasitic_tech -tlup $TLUPLUS_MIN_FILE  -layermap  $MAP_FILE
    set TOP_DESIGN ChipTop
    set gate_verilog "./inputs/chiptop.v"
    read_verilog -top $TOP_DESIGN $gate_verilog
    link_block
    puts $TOP_DESIGN
   # set_wire_track_pattern -site_def unit -layer M1  -mode uniform -mask_constraint {mask_two mask_one} -coord 0.037 -space 0.074 -direction vertical
    source ./inputs/mcmm.tcl
    set constraints_file "./inputs/chiptop+_s0_mcmm.sdc"
    remove_corners -all
    remove_modes -all
    remove_scenarios -all
    create_corner slow
    create_corner fast
    read_parasitic_tech -tlup $TLUPLUS_MAX_FILE -layermap $MAP_FILE -name tlup_max
    read_parasitic_tech -tlup $TLUPLUS_MIN_FILE -layermap $MAP_FILE -name tlup_min
    set_parasitics_parameters -early_spec tlup_min -late_spec tlup_min -corners {fast}
    set_parasitics_parameters -early_spec tlup_max -late_spec tlup_max -corners {slow}
    create_mode func
    current_mode func
    create_scenario -mode func -corner fast -name func_fast
    create_scenario -mode func -corner slow -name func_slow
    puts $Constraints_file
    set Constraints_file /home/rameshcs/vishnu_rs/pd/CHIP_TOP/inputs/chiptop+_s0_mcmm.sdc
    current_scenario func_fast
    read_sdc $Constraints_file
    current_scenario func_fast
    read_sdc $Constraints_file
    if { [sizeof_collection [get_corners -quiet estimated_corner]] > 0 } {
	remove_corners estimated_corner
	}
    list_blocks
     report_ref_libs
     save_block -as import_design
     report_timing
     list_blocks
     current_block
     closr_l
     close_lib
     his
