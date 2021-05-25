# LCQP Test Set for Benchmarking
This test set contains LCQPs of various dimensions. Each directory in `Problems` represents one test problem, each of which is expected to have a function `main.m` returning the test problem in (my) LCQP standard form, i.e., it should return the following struct
```
lcqp.Q
lcqp.g
lcqp.L
lcqp.R
lcqp.A*
lcqp.lbA*
lcqp.ubA*
lcqp.lb*
lcqp.ub*
lcqp.params*
lcqp.x0*
lcqp.y0*

*: Can be empty.
```

Each test problem is generated from within the `RunBenchmark.m` script, which calls the different solver types and stores all benchmark data to the directory `saved_variables`. The script `CreatePerformancePlot.m` reads the benchmark data and creates performance plots.

## Extending the test framework

