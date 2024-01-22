#!/bin/bash

set -e

num_parallel=50

dir=/home/beni/Downloads/kde

# most recent id jan 2024: 1973041
id_file=$dir/last_successful_id
echo id_file: $id_file

last_id=$(cat $id_file)
echo last_id: $last_id

id=$(expr $last_id + 0)
echo "starting ID:" $id

stop_at_id=1000000

seq ${id} -1 ${stop_at_id} | xargs -n 1 -P $num_parallel ./download-kde-themes-worker.sh


echo finished

# while (( id >= 1000000 )); do
#     echo "$id (start)";

# 	while (( ++num_running <= num_parallel )); do
#         (( id-- ));
# 		# echo id $id num_running $num_running;
# 		fetchTheme $id &
# 	done
    
#     echo
# 	echo waiting
# 	wait
  	
#   	echo -n $id > $dir/last_successful_id;
# 	num_running=0
# done

echo finished



