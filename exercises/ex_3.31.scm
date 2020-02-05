This is what will happen (level with Figure 3.25):
In the beginning, A and B is 0, if no initializing action is called, the E signal is also 0 instead of 1
Now set signal A to 1, no action will propagate through E thus making E still 0 and S also still 0, 
which is wrong (since S has not changed, nothing will print on the screen)
