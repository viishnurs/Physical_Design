##################################################
###### VISHNU RS ############################
###############################################

set_attribute [get_layers {M1 M3 M5 M7 M9}] routing_direction -value horizontal
set_attribute [get_layers {M2 M4 M6 M8 MRDL}] routing_direction -value vertical



initialize_floorplan -site_def unit -flip_first_row true -core_utilization 0.7 -use_site_row -core_offset {10}
#set routing layers


##port placement##

   ## took will automatically place all ports ( io and clock) once the ports placed do fix them###
set a [remove_from_collection [all_inputs ] [get_ports *clk*]]
set coi [get_attribute [get_placement_blockages pb_0 bbox]
create_pin_guide -boundary $coi -layers M6 -pin_spacing 6 $a



set coo  [get_attribute [get_placement_blockages pb_0 ] bbox]
create_pin_guide -boundary $coo -layers M6 -pin_spacing 5 [all_outputs ]
place_pins -ports [all_outputs ]
## macro placement ## 
## do macro manually using flyline analyses and giving spacing of 8-10 ##
set_attribute [get_flat_cells -filter "is_hard_macro"] physical_status -value fixed
# Apply Keepout margin to macros (1um)
create_keepout_margin [get_flat_cells -filter:wq "is_hard_macro"] -type hard -outer {1 1 1 1}
# Apply Blockages -- Soft blockage 


#insert boundary cells
set_boundary_cell_rules -left_boundary_cell saed14hvt_tt0p8v25c/SAEDHVT14_CAPB2 -right_boundary_cell saed14hvt_tt0p8v25c/SAEDHVT14_CAPB2 -at_va_boundary
compile_boundary_cells
check_boundary_cells 
#insert tap cells
create_tap_cells -distance 30 -lib_cell  saed14hvt_tt0p8v25c/SAEDHVT14_CAPB2 -pattern stagger -skip_fixed_cells
derive_placement_blockages 
check_legality
check_design














