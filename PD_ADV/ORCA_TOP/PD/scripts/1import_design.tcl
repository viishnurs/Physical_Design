#code for impororting the design in synopsys icc2 shell to get design which has standard cells and macros 
#############
#### created by : vishnu rs 
#### description :sourcing this file import design work 



lappend search_path /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/CLIBs /home/vishnu/PD_Adv_Aug23/ORCA_TOP/PD/inputs


#set design_name ORCA_TOP
#set date [sh date +%d_%m_%y]

# After invoking of tool
#
#if {[ file exists ./outputs/work/$design_name.nlib]} {sh mv ./outputs/work/$design_name.nlib ./outputs/work/$design_name.nlib_$date}

#create_lib ./outputs/work/$design_name.nlib
#save_lib

## linking of all the .ndm files 

set design_ref {saed32_hvt.ndm saed32_rvt.ndm saed32_lvt.ndm saed32_sram_lp.ndm }

set_ref_libs -ref_libs $design_ref 
report_ref_libs

#reading of verilog file 
#
read_verilog ./inputs/$design_name.v

link_block


#### saving thr block 

#save_block -as import_design
#remove_block $design_name

#####################################
######### for the next time opening of design 
#lsit_block
#open_block import_design
#
#
#close_block -f
#close_lib
#exit
#
#
########## sanaty check ############
check_netlist 
check_mv_design
report_ref_lib
check_timing
## THE END OF Import Desing #############

 
