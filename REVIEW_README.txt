
 LCQPow Code Guide and Result Reproduction - MPC Review
========================================================

Code Structure:
    - I cloned two main repositories to the server (/home/mpc-linux-01)

    1) LCQPow (https://github.com/hallfjonas/LCQPow)
        - This is the C++ implementation of the presented solver
        - It's source code is split into header files ('include') and source files ('src')
        - Some examples are provided in the 'examples' directory, and some more in the 'test/examples' directory
        - The directory 'external' contains the submodules qpOASES, OSQP, gtest and pybind11
        - Installation is done via cmake, and specific instructions can be found on the github page
        - A working version is already installed

    2) LCQPTest (https://github.com/hallfjonas/LCQPTest)
        - This contains the 3 benchmarks from the paper: MacMPEC, IVOCP, and MovingMasses
        - Since the remote server is headless, I suggest the following procedure to reproducing the results in two steps:
            1) Running the benchmarks on the server
                a) Fork the LCQPTest repository to an anonymous github account
                b) Clone the fork to the server to a desired location <fork_path>
                c) Navigate to <fork_path> and start matlab
                d) Execute 'nohup ./run.sh >/dev/null 2>&1 &'
                    - This command runs the benchmark in the background and you may quit the ssh connection
                    - Note that the benchmarks take several hours to complete
                e) The solutions should eventually show up in
                    - <fork_path/MacMPEC/solutions/mpc_review>
                    - <fork_path/IVOCP/solutions/mpc_review>
                    - <fork_path/MovingMasses/solutions/mpc_review>
                f) Once the solutions are created, push them to you forked repository
            2) Creating the performance plots on a local server
                a) Pull the forked repo with the created solutions
                b) Navigate into <fork_path>
                c) Open matlab and run 'CreatePlots'
                d) When the script terminates the figures can be found in the same solution directories as above
                