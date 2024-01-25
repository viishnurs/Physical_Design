set p=`pwd`
mkdir ./outputs/work_dir/cbest
cd ./outputs/work_dir/cbest
#to generate spef file for the corner m40
/home/tools/synopsys/synopsys_oct2021_tools/starrc/T-2022.03-SP2/bin/StarXtract -clean $p/scripts/cbest_spef.cmd
cd ../../..

