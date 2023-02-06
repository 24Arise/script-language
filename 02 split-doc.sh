#!/bin/bash

# Split a large file into different small files according to the number of lines
# sed -n 'start line number,end line numberp'  large file >> new file
sed -n '1,1000p' hfbs_cnaps.sql >> hfbs_cnaps-1.sql