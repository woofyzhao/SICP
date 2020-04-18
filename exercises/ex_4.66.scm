he realizes that some query pattern may cause duplicate variables to accumulate
which is incorrect.

he can specifiy another key variable to remove duplicates before accumulation 
for example the staff name. 

for example:

(sum-uniq ?amount ; variable to accumulate
          ?x      ; variable as unique key
          (and (job ?x (computer programmer))
               (salary ?x ?amount)))