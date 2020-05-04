Design a way to make the interperter implement the "simultaneous" scope rule
for internal definitions without constructing the extra frame:

Just reorder the body expressions so that all definitions come up first.

====
However we will lose the '*unassigned* detection mechanism this way. 
Another approach see: https://www.inchmeal.io/sicp/ch-4/ex-4.17.html