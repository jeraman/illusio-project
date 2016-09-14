#Illusio Project
![Image] (image.jpg)

The code dates back from 2011 but this repository has been reorganized in 2016 for research purposes. Tested only in a OS X 10.11.6.

[jeraman.info](http://jeraman.info), 2011

##About
Illusio is an open source digital musical instrument that allows the control of real-time recorded loops through collaborative and ludic performances based on relationships between sketches and sounds.

Developed in Processing and Openframeworks, it mixes multitouch technologies with the interaction metaphor of guitar pedals.

Concept and development by Jeraman, finalized in 2011. Developed with the support of Rumos Itaú Cultural Arte Cibernética 2009.

http://jeraman.info/​illusio


##How to Run
The Illusio is divided in three parts: the interface, the looper, and the tracker.

###Interface
Here, you only need to run the Illusio.app. 

If you want to edit the source code, you need to use the Processing IDE version 1.5, also available in this folder.

###Looper
Here, you only need to run the basic_looper.app. 

If you want to edit the source code, make sure you're using the XCode version 7.3.1. Compatibility with other versions is not guaranteed.

###Tracker
We use the Community Core Vision (CCV) to tracks touches in the table and to convert these touches into TUIO messages. To set things up you'll need to:

1. In case you're using the PS3 EYe, you might want install the proper drivers (read [this](tracker/macam/README.md) for details);

2. Run the Community Core Vision (CCV) app;

3. Chose the camera option, and check if it's working with your camera;

4. Fine tune the parameters in order to better track the blobs;

5. Calibrate the touch. make sure you read all the instructions presented by CCV in order to have better results;

6. Save the configuration;

7. Press space bar in order to minimize the interface workload;

8. Choose the option "send TUIO messages";

10. You should be good to go! make sure CCV is tracking you blobs all right!

#Contact
jbcj [at] cin.ufpe.br
