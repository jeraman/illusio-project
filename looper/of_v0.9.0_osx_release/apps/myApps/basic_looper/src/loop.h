#ifndef LOOP_H
#define LOOP_H

#include "ofMain.h"
#include <vector>


#define BUFFER_SIZE 256
#define SAMPLE_RATE	44100
#define N_CHANNELS 2

class Loop
{
    public:
        Loop();
        Loop(vector<float>, int, int = BUFFER_SIZE, int = N_CHANNELS, int = -1);
        virtual ~Loop();

        void play (float* &output, bool = false);
        void stop ();
        void resume ();
        int  get_size();
        void update_buffer(vector<float>, int);

        int outpos;           //a agulha do vinil (para este loop)
        int bufferSize;       //tamanho do buffer quando gravado
        int nChannels;        //número de canais do loop
        int inipos;           //posição inicial com relação ao main


        int id; //id do botao correspondente
        bool muted;           //to mute the loop

        //variaveis não utilizadas
        float volume;
        float leftpan;
        float rightpan;
        float fade;


    //private:
        vector<float> buffer; //guarda os dados sonoros

};

#endif // LOOP_H
