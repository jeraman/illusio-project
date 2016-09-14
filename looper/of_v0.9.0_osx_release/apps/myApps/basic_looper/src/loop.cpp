#include "loop.h"

Loop::Loop(vector<float> b, int ip, int bufsize, int nchan, int i)
{
    //inicializando as variáveis
    buffer = b;
    inipos = ip;
    bufferSize = bufsize;
    nChannels = nchan;
    muted = false;

    //inicializando o id
    id = i;

    //começando do início
    outpos = 0;

    //inicializando as variáveis não usadas
    volume = 1.f;
    leftpan = 1.f;
    rightpan = 1.f;
    fade = 0.7f;

}

Loop::~Loop()
{
    buffer.clear();
}



void Loop::stop()
{
    muted = true;
    //outpos = 0;
}

void Loop::resume()
{
    muted = false;
    outpos = 0;
}


int  Loop::get_size()
{
    return buffer.size();
}


void Loop::play(float* &output, bool e_principal)
{
    if (!muted)
    {
        //debugging variable
        //vector<float> copy;
        
        for(int i=0; i<bufferSize; i++) {
            int   index = i*nChannels;
            
            output[index  ] += buffer[outpos + index];// * volume * leftpan;
            output[index+1] += buffer[outpos + index];// * volume * rightpan;
            
            //copy.push_back(output[index]);
            //copy.push_back(output[index+1]);

        }
    
        outpos = ((outpos + bufferSize*2)%(buffer.size()));
        
        //if (outpos==bufferSize*2)
        //    cout<<endl;
        
        
        //if (outpos==0)
        //    cout<<endl;

        

    }
    else if (e_principal) //se e o principal e ele esta mudo
    {
        /* old code, see the comments below
        if (outpos + bufferSize <= buffer.size())
            outpos += (int)bufferSize;
        else
            outpos = 0;
         */
        
        outpos = (((int)bufferSize*2)%(buffer.size()));
    }
    
    /* orginal code
    if (!muted)
    {
        //checks if it's possible the output plus buffersize is within the current callback's buffer
        //if (outpos + bufferSize < buffer.size())
        //{

            for(int i=0; i<bufferSize; i++)
            {
                //feeds the left channel of the buffer
                output[i*nChannels    ]   += buffer[buffer.size()-(nChannels * outpos)] * volume * leftpan;
                
                //debugging variable
                copy.push_back(output[i*nChannels]);
                
                //feeds the right channel of the buffer
                output[i*nChannels + 1]   += buffer[buffer.size()-(nChannels * (outpos+1))] * volume * rightpan;

                //debugging variable
                copy.push_back(output[i*nChannels + 1]);
                
                //updates outpos
                outpos = (outpos+1)%(int)(buffer.size());
                
            }
        
        //cout << "test" <<endl;
            //this was activated before
            //outpos += (int)bufferSize;
        //}
        //this was activated before
        //else
        //   outpos = 0;
    }
    
    else if (e_principal) //se e o principal e ele esta mudo
    {
        if (outpos + bufferSize <= buffer.size())
            outpos += (int)bufferSize;
        else
            outpos = 0;
    }
     */
    

}


void Loop::update_buffer(vector<float> b, int ip)
{
    //inicializando as variáveis
    buffer = b;
    inipos = ip;
}
