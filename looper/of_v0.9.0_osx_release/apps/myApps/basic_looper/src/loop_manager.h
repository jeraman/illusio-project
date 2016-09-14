#ifndef LOOP_MANAGER_H
#define LOOP_MANAGER_H

#include "loop.h"
#include <vector>


/**************************
 **************************
 **************************
 *** COMANDOS POSSÍVEIS  **
 ***  - record (ID);     **
 ***  - play   (ID);     **
 ***  - stop   (ID);     **
 ***  - erase  (ID);     **
 **************************
 **************************
 **************************/


class Loop_Manager
{
    public:
         Loop_Manager();
        ~Loop_Manager(){};

        void audio_input (float*&, int, int);  //should be called when there's any audio input
        void audio_output(float*&, int, int); //should be called when there's any audio output
        Loop* get_loop (int);   //returns a pointer to given loop
        void  record   (int);   //records and stops recording a loop
        void  play     (int);   //play a given loop
        void  stop     (int);   //stops playing a given loop
        void  erase    (int);   //deletes a given loop
        void  kill_all ();      //kills all the loops
        //void  play_or_stop(int);//stops or play a given loop

        void  pop ();

   	private:
		vector<float> input_buf;
		vector<Loop>  loops; //armazena os loops
        int  temp_inipos;    //stores the temp inipos!
        int  start_time;     //conta o tempo passado em segundos
		int  temp_id;        //id do loop que está sendo gravado
		bool recording;      //marca se esta gravando
		bool playing;        //marca se esta tocando

		int   search   (int);   //searches a given loop in database


};

#endif // LOOP_MANAGER_H
