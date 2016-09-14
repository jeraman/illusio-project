#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	 
	
	ofSetVerticalSync(true);
	ofSetCircleResolution(80);
	ofBackground(54, 54, 54);	
	
	// 0 output channels, 
	// 2 input channels
	// 44100 samples per second
	// 256 samples per buffer
	// 4 num buffers (latency)
	
	soundStream.printDeviceList();
	
	//if you want to set a different device id 
	//soundStream.setDeviceID(0); //bear in mind the device id corresponds to all audio devices, including  input-only and output-only devices.
	
	left.assign(BUFFER_SIZE, 0.0);
	right.assign(BUFFER_SIZE, 0.0);
	volHistory.assign(400, 0.0);
	
	//bufferCounter	= 0;
	//drawCounter		= 0;
	//smoothedVol     = 0.0;
	//scaledVol		= 0.0;

	soundStream.setup(this, N_CHANNELS, N_CHANNELS, SAMPLE_RATE, BUFFER_SIZE, 4);
    
    //setting up osc receiver
    receiver.setup( PORT );
    
    current_msg_string = 0;
    mouseX = 0;
    mouseY = 0;
    mouseButtonState = "";
    
    //starting the sound stream
    //soundStream.start();
    
    //freezing the framerate
    ofSetFrameRate(60);
    
    cout << "setuped!" <<endl;


}

//--------------------------------------------------------------
void ofApp::handleOscMessages()
{
    while( receiver.hasWaitingMessages() )
    {
        ofxOscMessage m;
        receiver.getNextMessage( m );
        
        if (m.getAddress() == "/alive")
            return;
        if (m.getAddress() == "/kill-all")
            return;
        
        int id = m.getArgAsInt32(0);
        
        
        if ( m.getAddress() == "/record" ) {
            cout << "grava! " << id << endl;
            lm.record(id);
        }
        
        if ( m.getAddress() == "/play" ) {
            cout << "toca! " << id << endl;
            lm.play(id);
        }
        
        if ( m.getAddress() == "/stop" ) {
            cout << "para! " << id << endl;
            lm.stop(id);
        }
        
        if ( m.getAddress() == "/erase" ) {
            cout << "apaga! " << id << endl;
            lm.erase(id);
        }
        
    }
}


void ofApp::drawFirstLoop()
{
    //getting the first loop if available
    
    Loop* first = lm.get_loop('1');
    
    //checks if there is first. continues to execute if there is
    if (first == nullptr) {
        return;
    }
        
    //start drawing first waveform
    ofSetColor(150, 0, 0);
    ofSetLineWidth(1);
    
    float posy = ofGetHeight()/2.0;
    
    int loopsize = first->buffer.size();
    
    //iterates over the first loop
    for (unsigned int i = 0; i < loopsize; i++){
        //gets the correspond position of the index of the loop and the screen width
        float posx = ofMap(i, 0, loopsize, 0, ofGetWidth());
        //computing the y size of each rectangle
        float sizey = ofMap(first->buffer[i], -1, 1, -posy, posy);
        
        ofDrawRectangle(posx,posy,1,sizey);
    }
    
    float beg  = first->buffer[0];
    float end  = first->buffer[loopsize-1];
    
    cout << "beg: " << ofToString(beg)       <<endl;
    cout << "end: " << ofToString(end)       <<endl;
    cout << "dif: " << ofToString(beg - end) <<endl <<endl;
}


//--------------------------------------------------------------
void ofApp::update(){
    //handles osc messages
    handleOscMessages();
    
	//lets scale the vol up to a 0-1 range 
	scaledVol = ofMap(smoothedVol, 0.0, 0.17, 0.0, 1.0, true);

	//lets record the volume into an array
	volHistory.push_back( scaledVol );
	
	//if we are bigger the the size we want to record - lets drop the oldest value
	if( volHistory.size() >= 400 ){
		volHistory.erase(volHistory.begin(), volHistory.begin()+1);
	}
     
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofBackground(0,0,0);
    ofSetColor(200);
	
    string buf;
    buf = "listening for osc\n messages on port " + ofToString( PORT );
    ofDrawBitmapString( buf, 10, 20 );
    
    for ( int i=0; i<NUM_MSG_STRINGS; i++ )
        ofDrawBitmapString( msg_strings[i], 10, 40+15*i );
    
    //drawFirstLoop();
		
}

//--------------------------------------------------------------
void ofApp::audioIn(float * input, int bufferSize, int nChannels){
    lm.audio_input(input, bufferSize, nChannels);
}


//--------------------------------------------------------------
void ofApp::audioOut(float * output, int bufferSize, int nChannels){
    
    
    lm.audio_output(output, bufferSize, nChannels);
}


//--------------------------------------------------------------
void ofApp::keyPressed  (int key){
    
    if (key=='-')
        lm.pop();
    if (key=='1')
        lm.record(key);
    if (key=='2')
        lm.record(key);
    if (key=='3')
        lm.record(key);
    if (key=='4')
        lm.record(key);
    if (key=='5')
        lm.record(key);
    
	/*
    if( key == 's' ){
		soundStream.start();
	}
	
	if( key == 'e' ){
		soundStream.stop();
	}
     */
}

//--------------------------------------------------------------
void ofApp::mousePressed(int x, int y, int button){
    cout << button <<endl;
    if (button==0)
        lm.play('1');
    if (button==2)
        lm.stop('1');
}

//--------------------------------------------------------------
void ofApp::keyReleased(int key){ 
	
}

//--------------------------------------------------------------
void ofApp::mouseMoved(int x, int y ){
	
}

//--------------------------------------------------------------
void ofApp::mouseDragged(int x, int y, int button){
	
}

//--------------------------------------------------------------
void ofApp::mouseReleased(int x, int y, int button){

}

//--------------------------------------------------------------
void ofApp::mouseEntered(int x, int y){

}

//--------------------------------------------------------------
void ofApp::mouseExited(int x, int y){

}

//--------------------------------------------------------------
void ofApp::windowResized(int w, int h){

}

//--------------------------------------------------------------
void ofApp::gotMessage(ofMessage msg){

}

//--------------------------------------------------------------
void ofApp::dragEvent(ofDragInfo dragInfo){ 

}

