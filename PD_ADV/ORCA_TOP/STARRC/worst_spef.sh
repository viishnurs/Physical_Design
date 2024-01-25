set p=`pwd`
mkdir $p/outputs/work_dir/cworst
cd $p/outputs/work_dir/cworst
#to generate spef for the corner 125c
/home/tools/synopsys/synopsys_oct2021_tools/starrc/T-2022.03-SP2/bin/StarXtract  -clean $p/scripts/cworst_spef.cmd
cd -
