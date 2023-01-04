# LCQPow Test Benchmark

This repository was created for benchmarking LCQPow, a solver for quadratic programming problems with linear complementarity constraints. 

## Dependencies 

1. [LCQPow](https://github.com/hallfjonas/LCQPow)
1. [Matlab](https://www.mathworks.com/products/matlab.html)
1. [CasADi](https://web.casadi.org/)
1. [Gurobi](https://www.gurobi.com/)

## Usage
This benchmark contains three test sets: *MacMPEC*, *IVOCP*, and *MovingMasses*. 
Adjust the paths in the file *addpaths* to reflect your local settings.
Then execute the script 'Run.m'. This will run all benchmarks and create performance plots.