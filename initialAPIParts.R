# Will rehash version controlling later...
if (!require(plumber)){
  install.packages("plumber")
}
library (plumber)

runIperf <- function() {
  if (isServer) {
    # rename tee output to current hostname...
    system(paste("iperf3 -s -p ", port, " | tee serverOut.txt"))
  } 
  else {
    system(paste("iperf3 -c ", hostname, ".local -i 1 -t 30 | tee clientOut.txt"))
  }
}

# Function to set up iperf test on the devices. MUST RUN SERVER BEFORE
# CLIENT
# Additional Values to be added...

#* @get /run_and_collect
#* @param isServer
#* @param port
#* @serializer text
oof <- function(isServer, port) {
  runIperf(TRUE)
  
}
