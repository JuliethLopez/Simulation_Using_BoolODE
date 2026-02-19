# Set the path to your clone of the BoolODE repository here
# The current options will perform stochastic simulations
# using the default kinetic parameters.
# If you would like to sample parameters, use the following options:
#  --sample-par --std 0.05 -i
# The above will specify a standard deviation of 5% of the default parameter
# value, and the -i option will set all parameters to a single sampled value.
# In order to generate samples, we use the scripts/genSamples.py
# The -d option specified number of datasets to generate (Set to 1)
# Each dataset will have a sample of 500 cells from the full set of 2000 simulations
# This is specified using the -n option.

path_to_boolode=".."
numcells="100"
numcellssample="100"
numdatasets="1"

# Synthetic Networks
output_dir="../tests/Synthetic/"

# Linear
output_name="dyn-LI"
model_name="dyn-linear"
drop_probability=0.5
quantil=0.5
quantil_name=$(awk "BEGIN {print int($quantil*100)}")

echo "Simulating "$model_name
python $path_to_boolode/src/BoolODE.py --path $path_to_boolode/data/$model_name.txt\
       --ics $path_to_boolode/data/$model_name"_ics.txt" --max-time 5 --num-cells $numcells\
       --do-parallel\
       --sample-pars true --std 0.05 --identical-pars true\
       --outPrefix $output_dir$output_name"/"

python $path_to_boolode/scripts/genSamples.py -p $output_dir$output_name"/"\
       -n $numcellssample -d $numdatasets --outPrefix $output_name

echo "Generating dropouts for q="$quantil_name" for "$model_name
python $path_to_boolode/scripts/genDropouts.py  -e $output_dir$output_name"/"$output_name"-"$numcellssample"-1/ExpressionData.csv"\
       -p $output_dir$output_name"/"$output_name"-"$numcellssample"-1/PseudoTime.csv"\
       -r $output_dir$output_name"/"$output_name"-"$numcellssample"-1/refNetwork.csv"\
       -n $numcellssample -d --drop-cutoff $quantil --drop-prob $drop_probability -i 1\
       --outPrefix $output_dir$output_name"/"$output_name"-"$numcellssample"-1""/"$output_name

echo "Generating graphics for q=50 for "$model_name
model_folder=$output_dir$output_name
model_folder_cells=$output_name"-"$numcellssample"-1"
model_folder_dropout=$model_folder_cells"-"$quantil_name"-"$drop_probability
output_folder=$model_folder"/"$model_folder_cells"/"$model_folder_dropout
python $path_to_boolode/scripts/genVis.py -i $output_folder"/ExpressionData.csv" -p $output_folder"/PseudoTime.csv"