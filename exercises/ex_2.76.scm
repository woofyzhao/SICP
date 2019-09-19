1. Generic Operations with Explicit Dispatch:

New operations:
need to add coressponding new generic functions and do the dispatch on existing types

New types:
need to modify existing generic functions to add dispatching on new types

2. Data Directed Style:

New operations:
need to install new operations on the client's side

New types:
need to install new types on the client's side

* existing generic functions need not change

3. Message Passing Style:

New operations:
need to add new message processing within each existing type

New types:
need to implement message processing within new type

* existing generic functions need not change


Which would be most appropriate for a system in which new types must often be added?
Data Directed Or Message Passing

Which would be most appropriate for a system in which new operations must often be added?
Message Passing 