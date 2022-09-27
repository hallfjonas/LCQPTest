# LCQPow Test Benchmark

This repository was created for benchmarking LCQPow, a solver for quadratic programming problems with linear complementarity constraints. 

## Dependencies 

1. [LCQPow](https://github.com/hallfjonas/LCQPow)
1. [Matlab](https://www.mathworks.com/products/matlab.html)
1. [CasADi](https://web.casadi.org/)
1. [Gurobi](https://www.gurobi.com/)

## Usage
This benchmark contains three test sets: *MacMPEC*, *IVOCP*, and *MovingMasses*. Each of those directories contain a file that runs the respective benchmark (navigate to the specific directory and run the file). In those files you may adapt which solvers to include (specify the solver function name in the given struct `benchmark.solvers`). The set of solvers are contained in the directory *solvers*. 