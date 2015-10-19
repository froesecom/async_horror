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
+ There is overhead associated with creating threads in the first place! (Maybe the source of my performance issues?)

#### Experiment 2: Waiting for actors to finish
+ In the previous expermient, the main thread was definitely finishing and killing all the actors before they had a chance to finish (demonstrated here in the `do_all_the_things_insync` method... the whole process finishes in less time than it would take for one actor to finish)
+ Celluloid futures can be used to ensure that the main thread waits untill all actors finish.
+ However, using futures runs just as slow as the synchronous code. What gives?

#### Experiment 3: CPU-bound tasks and Ruby MRI
+ Multi-threading of CPU-bound tasks gives no performance benefit, which is why `do_all_the_things_with_futures` method runs at the same speed as the synchronous method.
+ If you use futures to do something non-CPU-bound (I/O tasks, or `sleep 1` for example), you will see benefit. In this case it's 10 times faster.
+ The Matz Ruby Interpreter (MRI) uses 'Global Interpreter Lock' (GIL), which only allows one thread to execute at a time. We are not a thread guy! (More reading: [Nobody understands the GIL](http://www.jstorimer.com/blogs/workingwithcode/8085491-nobody-understands-the-gil))
+ Installing JRuby (Java implementation of Ruby) should allow for speed increase.

What the experts says:

+ [This legend](http://stackoverflow.com/questions/33101565/celluloid-futures-not-faster-than-synchronous-computation/33102081#33102081) answered my StackOverflow question.
+ Most of what I read (including Celluloid docs), say things like this: "writing multi-threaded code can be tricky regardless of which tool you use, and even if you use Celluloid or ruby-concurrent to give you better higher-level abstractions than working directly with threads, working with multi-threaded concurrency will require becoming familiar with some techniques for such and require some tricky debugging from time to time."

#### Experiment 4: The real world
+ When implementing asycn in Rails, it's important to know that ActiveRecord only allows 5 connections by default.
+ This exception will be raised if you try to implement more `ERROR -- : Actor crashed! ActiveRecord::ConnectionTimeoutError: could not obtain a database connection within 5.000 seconds`
+ You can change the [default number of connections](https://devcenter.heroku.com/articles/concurrency-and-database-connections), but I'm not sure of the implications of that in production.

#### Experiment 5: Leaking database connections
+ Even with only 5 actors in a pool (using SQLite) the actors crash because the database is locked.
+ When using mysql, the async method runs almost 2.5 times quiker (12.5 seconds, vs 30.1 seconds), HOWEVER...
+ It tends to lock the database after the method runs, when running with Rails Console. *What's happening here?*
+ It also periodically crashses during task, as it has issues connecting to the database (waited 5 seconds... blah, blah)
+ With a pool of 3, I still have issues with it crashing, but slightly less often. The Celluloid/Active-Record combination [appears to be leaking db connections](https://groups.google.com/forum/#!topic/celluloid-ruby/n9a1RpRztjY)

 Type | Time | Database lock?
 --- | --- | ---
 Async, pool==5, | 11-12 sec | *yes*
 Sync, pool==5 | 30-31 sec | *yes*
 Asyncy, pool==3 | 18-19 sec | yes, but less often
 Sync, pool==3 | 30-31 sec | yes, but less often


#### Experiment 6: Stale connections
+ Apparently Rails 3 would [clear stale connections for you](https://bibwild.wordpress.com/2014/07/17/activerecord-concurrency-in-rails4-avoid-leaked-connections/). In Rails 4, it's much harder to clean up leaked connections.
+ You have to explicitly ensures the connection is returned back to the pool when completed using `ActiveRecord::Base.connection_pool.with_connection`. This is an ActiveRecord thing, not a Celluloid thing. This seems to do the trick.
+ * The speed increase you get with this async implementation is really OS/hardware dependant. On my faster, higher powered Mac, the asyncy is only about 20% faster (likely because the I/O compenent is really fast)


## TODO
+ Try to keep track of state and results
+ Experiment with threadsafe performance

##THEMES
+ writing multi-threaded code can be tricky regardless of which tool you use


