# Aysnc Horror
## Experiments with async and Ruby

*Refer to commit history to find experiment evolution.*

### Learnings
#### Experiment 1: Too many threads
+ When number of threads > 5, performance seriously declines (similar to synchronous, or sometimes even worse)
+ When using a pool of threads <= 5, process finishes up to 50 times faster...
+ *HOWEVER*, are all actors finishing before main thread finishes? Need to experiment. My guess is no.

What the experts say:

+ [Concurrency and parrellelism are not the same.](http://www.toptal.com/ruby/ruby-concurrency-and-parallelism-a-practical-primer) "...concurrency is when two tasks can start, run, and complete in overlapping time periods. It doesn’t necessarily mean, though, that they’ll ever both be running at the same instant (e.g., multiple threads on a single-core machine). In contrast, parallelism is when two tasks literally run at the same time (e.g., multiple threads on a multicore processor)"
+ Why does a large pool of threads perform poorly? "The answer, which is the bane of existence of many a Ruby programmer, is the Global Interpreter Lock (GIL). Thanks to the GIL, CRuby (the MRI implementation) doesn’t really support threading... An interpreter which uses GIL will always allow exactly one thread and one thread only to execute at a time, even if run on a multi-core processor."
+ Threads ain't free and if you create too many, you'll eventually run out of resources.
+ There is overhead associated with creating threads in the first place! (Maybe the source of my proformance issues?)

#### Experiment 2: Waiting for actors to finish
+ In the previous expermient, the main thread was definitely finishing and killing all the actors before they had a chance to finish (demonstrated here in the `do_all_the_things_insync` method)
+ Celluloid futures can be used to ensure that the main thread waits untill all actors finish.
+ However, using futures runs just as slow as the synchronous code. What gives?


## TODO
+ Try to measure if actors are finishing
+ Figure out how to join actors and wait for main thread to finish
+ Experiment with threadsafe performance


