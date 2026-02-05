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
numcells="2000"
numcellssample="2000" #100, 200, 500, 1000, 2000
numdatasets="2"

# Curated models

# Here, we also run Slingshot on the sample of 500 cells, and then generate dropouts for that sample.
output_dir="../Curated/" #Test

# mCAD
output_name="mCAD"
model_name="mCAD"
numclusters="2"
drop_probability=0.5 # Set to 0.5 for q=50, try 0.0, 0.5, 0.7
quantil=0.5
quantil_name=$(awk "BEGIN {print int($quantil*100)}")

echo "Simulating "$model_name
python $path_to_boolode/src/BoolODE.py --path $path_to_boolode/data/$model_name.txt\
       --ics $path_to_boolode/data/$model_name"_ics.txt" --max-time 5 --num-cells $numcells\
       --do-parallel\
       --nClusters $numclusters\
       --outPrefix $output_dir$output_name"/"

for n_cells in 100 200 500 1000 2000; do
       numcellssample=$n_cells
       echo $numcellssample

       python $path_to_boolode/scripts/genSamples.py -p $output_dir$output_name"/"\
              -n $numcellssample -d $numdatasets --outPrefix $output_name

       for n_dataset in $(seq 1 $numdatasets); do 
              echo "Generating graphics for"$model_name" sample "$numcellssample" dataset "$n_dataset" without dropout"
              model_folder=$output_dir$output_name
              model_folder_cells=$output_name"-"$numcellssample"-"$n_dataset
              output_folder=$model_folder"/"$model_folder_cells
              echo $output_folder
              python $path_to_boolode/scripts/genVis.py -i $output_folder"/ExpressionData.csv" -p $output_folder"/PseudoTime.csv"
         
              for drop_probability in 0.5 0.7; do
                     echo "Generating dropouts $drop_probability for q="$quantil_name" for "$model_name" sample "$numcellssample" dataset "$n_dataset
                     python $path_to_boolode/scripts/genDropouts.py  -e $output_dir$output_name"/"$output_name"-"$numcellssample"-"$n_dataset"/ExpressionData.csv"\
                            -p $output_dir$output_name"/"$output_name"-"$numcellssample"-"$n_dataset"/PseudoTime.csv"\
                            -r $output_dir$output_name"/"$output_name"-"$numcellssample"-"$n_dataset"/refNetwork.csv"\
                            -n $numcellssample -d --drop-cutoff $quantil --drop-prob $drop_probability -i $n_dataset\
                            --outPrefix $output_dir$output_name"/"$output_name"-"$numcellssample"-"$n_dataset"/"$output_name

                     echo "Generating graphics"
                     model_folder=$output_dir$output_name
                     model_folder_cells=$output_name"-"$numcellssample"-"$n_dataset
                     model_folder_dropout=$model_folder_cells"-"$quantil_name"-"$drop_probability
                     output_folder=$model_folder"/"$model_folder_cells"/"$model_folder_dropout
                     echo $output_folder
                     python $path_to_boolode/scripts/genVis.py -i $output_folder"/ExpressionData.csv" -p $output_folder"/PseudoTime.csv"
                     done
              done
       done