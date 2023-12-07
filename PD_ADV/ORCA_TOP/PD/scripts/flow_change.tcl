### go work folder in outputs folder 
###############################################
##### changing of the design  because of the more congestion in previous desing 
##################################################################################
rm -rf ORCA_TOP.nlib/

# Create ORCA_TOP.nlib again 
lappend search_path  /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/CLIBs
set design_name ORCA_TOP
create_lib ./outputs/work/$design_name.nlib
set_ref_libs -ref_libs  {saed32_1p9m_tech.ndm saed32_rvt.ndm saed32_hvt.ndm saed32_lvt.ndm saed32_sram_lp.ndm}
save_lib

# read_verilog 
read_verilog ./inputs/ORCA_TOP.v

# Create core area and die area  
# {{5 5} {900 5} {900 450} {450 450} {450 900} {5 900} {5 5}} 
 initialize_floorplan -boundary {{5 5} {900 5} {900 450} {450 450} {450 900} {5 900} {5 5}} -use_site_row -site_def unit -core_offset 5



# port placement 
remove_block_pin_constraints -self 
remove_individual_pin_constraints -ports [get_ports]

# input port placement 
set a [remove_from_collection [all_inputs ] [get_ports *clk*]]
set coi [get_attribute [get_placement_blockages pb_3] bbox]
create_pin_guide -boundary $coi -layers M6 -pin_spacing 1 $a
place_pins -ports $a

# Place output ports 
set coo  [get_attribute [get_placement_blockages pb_0 ] bbox]
create_pin_guide -boundary $coo -layers M6 -pin_spacing 1 [all_outputs ]
place_pins -ports [all_outputs ]

# Place clock ports 
set coc [get_attribute [get_placement_blockages pb_1] bbox]
 create_pin_guide -boundary $coc -layers M5 -pin_spacing 1 [get_ports *clk*]
place_pins -ports [get_ports *clk*]

# Load UPF 
load_upf ./inputs/ORCA_TOP.upf
source ./scripts/va_redone.tcl

# Macro placement
# 458.072 \
## tap_cells and endcap cells insertion 
# Power planning 
# Fixing power planning issues 
# coarse placement
# do legalization	  
# check congestion 
# place_opt 
