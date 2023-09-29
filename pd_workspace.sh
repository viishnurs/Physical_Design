###########################################################
############## Created by Vishnu #####################
############ PD dir structure ###############
###########################################################


mkdir -p PD_Adv_Aug23/ORCA_TOP/PD
cd PD_Adv_Aug23/ORCA_TOP/PD
mkdir -p inputs outputs/work outputs/import_design/reports outputs/import_design/logs outputs/floorplan/logs outputs/floorplan/reports outputs/powerplan/reports outputs/powerplan/logs outputs/placement/reports outputs/placement/logs outputs/cts/reports outputs/cts/logs outputs/routing/logs outputs/routing/reports scripts/ref_scripts




cd inputs

##design_data_inputs

ln -s /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/ORCA_TOP_design_data/ORCA_TOP.v .
ln -s /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/ORCA_TOP_design_data/ORCA_TOP.upf .
ln -s /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/ORCA_TOP_design_data/ORCA_TOP.scandef .
 
## CLIB'S

ln -s /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/CLIBs/* .

##constrains 

cp -rd /home/rahulkumar/ORCA_TOP_2/PD/inputs/sdc_constraints .

##tlup

ln -s /home/vlsiguru/PHYSICAL_DESIGN/TRAINER1/ICC2/ORCA_TOP/ref/tech/* .


cd ../scripts

touch import_design.tcl floorplan.tcl powerplan.tcl placement.tcl cts.tcl routing.tcl
