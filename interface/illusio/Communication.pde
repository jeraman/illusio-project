  
OscP5 oscP5;
NetAddress addr;

void setup_communication() 
{
  oscP5 = new OscP5(this,12345);
  addr  = new NetAddress("127.0.0.1",12345);
}

void send_record(int id) 

{
  OscMessage message = new OscMessage("/record");
  message.add(id);
  oscP5.send(message, addr);
}


void send_play(int id) 
{
  OscMessage message = new OscMessage("/play");
  message.add(id);
  oscP5.send(message, addr);
}


void send_stop(int id) 
{
  OscMessage message = new OscMessage("/stop");
  message.add(id);
  oscP5.send(message, addr);
}


void send_erase(int id) 
{
  OscMessage message = new OscMessage("/erase");
  message.add(id);
  oscP5.send(message, addr);
}

/*
void send_play_or_stop(int id) 
{
  OscMessage message = new OscMessage("/playstop");
  message.add(id);
  oscP5.send(message, addr);
}
*/
