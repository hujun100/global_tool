echo "`nvidia-smi`"|grep 'python'|awk '{print $3 " "}' |xargs sudo kill -9 
