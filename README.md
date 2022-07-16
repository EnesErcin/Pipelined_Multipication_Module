# Pipelined_Multipication_Module
An attempt of creating faster multiplication circuit with HDL VHDL


This project is based upon the tasks which were given in my second week of FPGA implementation internship at university lab.
Initially the instructor described the submodules of a simple generic multipication module and expected us to build the code also test the results.

In first glanse, most of the submodules seems unneccesery that is why I was hesistant to build the model which is represented. In addition I once heard the term **Piplined Multipication**. However I knew what pipline means form computer acrhitecture classes, I did not know how pipline can be applied in  *multipication in hardware*. After going over binary multipication artihmatic couple of times I got an idea of what this piplined multipication could mean.

## Thougth Process
                            "Add and image here"
Lets first describe generic addition:
To be able to desribe better lets say addition result is recored in register HOLD (which has 2 times more bits than the opperands). For each clock cycle (or different choosen signal) the opperation and has to be performed by particular bit of the multplier and the whole multipicand. For the next particular bit (more important bit) same and opperation is performed but the result is shifted one bit. Finaly these two opperands will be added together in addition module. Result than can be used as first opperand of addition with the and result. This cycle will countinue until the final bit of multplier is reached.

This simple process seems irretably hard to understand when put into generic method. Lets assume we must multpily 0101 (5) and 0110 (6).
What we actually doing is 0101(5) * 0010(4) + 0101(5) * 0100(2) this is way simpler to imagine now because now all we have to do is shift the multipicand with rigth amount in our case 4 and 2  and add them together. 

1)                 0101(5) * 0010(4) = 0001 0100 (20)  //If there is single 1 bit in multplier then multpication can be viewed as shift
2)                 0101(5) * 0100(2) = 0000 1010 (10)
3)   0000 1010(20)  + 0001 0100(10)  = 0001 1110 (30)

## Implementation, optimization and issues
My design consist of two module one for multplier analaysis and the second one for shifting. The output of multplier analaysis module is for now 3 outputs for determining the location of each 1 bit in multiplier. The issue for now however is the multplier analaysis module  can only analayse numbers with maxiumum of 3 1's in multiplier. 
***It was possible to countunie but I relised a better implementation along the way.***
***The issue is what if the multipicand has less amount of 1's then multiplier. In that case it is better to shift their roles.***
***Other issue is it enough to use there registers to give the distance between ones since each stage requires one cycle of addition.***

I am currently working on those issues. Next step after those improvment is to build a generic analysis module.

Since the instructor would suggest us to finish this project to start the next one I also had to build the multipication circuit module with submodules described in the picture below.
                            "Add and image here"





