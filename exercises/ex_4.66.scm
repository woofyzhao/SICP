He realizes that some query pattern may cause duplicate variables to accumulate
which is incorrect.

For example, to sum all salaries of wheels using Ben's approach:

(sum ?amount
     (and (wheel ?x)
          (salary ?x amount)))

will cause Oliver Warbucks's salary to be added 4 times.

He can specifiy another key variable to remove duplicates before accumulation 
for example the staff name. 

For example:

(sum-uniq ?amount ; variable to accumulate
          ?x      ; variable as unique key
          (and (wheel ?x)
               (salary ?x amount)))
