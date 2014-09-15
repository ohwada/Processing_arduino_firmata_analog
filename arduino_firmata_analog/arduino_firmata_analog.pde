/**
 * XY Plot Graph for Arduino Analog Input with Firmata
 * K.OHWADA 2014-08-01
 */ 

import processing.serial.*;
import cc.arduino.*;

// serial
int SERIAL_PORT = 0;
int SERIAL_SPEED = 57600;

// pin number
int PIN_ANALOG = 0;

// analog value
int MIN_VALUE = 0;
int MAX_VALUE = 1023;

// screen
int SCREEN_WIDTH = 800;
int SCREEN_HEIGHT = 600;

// graph
int GRAPH_MARGIN = 10;
int ELLIPSE_DIAMETER = 4;

int RECT_WIDTH = SCREEN_WIDTH -  2 * GRAPH_MARGIN;
int RECT_HEIGHT = SCREEN_HEIGHT -  2 * GRAPH_MARGIN;
int X_MAX = SCREEN_WIDTH - GRAPH_MARGIN;
int Y_MAX = SCREEN_HEIGHT - GRAPH_MARGIN;

// color
color COLOR_BACK = color( 255, 255, 255 ); // white
color COLOR_RECT = color( 0, 0, 0 ); // black
color COLOR_LINE = color( 0, 0, 255 ); // blue

// Arduino
Arduino arduino;

// counter which draw the width of screen
int cnt; 

void setup() {
	size( SCREEN_WIDTH, SCREEN_HEIGHT );

// initialize Arduino
	println( Arduino.list() );
	arduino = new Arduino( this, Arduino.list()[ SERIAL_PORT ], SERIAL_SPEED );
	arduino.pinMode( PIN_ANALOG, Arduino.INPUT );

// initialize graph
	initGraph();
}

// draw
void draw() {
	// plot graph 
	int value = arduino.analogRead( PIN_ANALOG );
	fill( COLOR_LINE );
	float tx = map( cnt, 0, width, GRAPH_MARGIN, X_MAX );
	float ty = map( value, MIN_VALUE, MAX_VALUE, Y_MAX, GRAPH_MARGIN );
	ellipse( tx, ty, ELLIPSE_DIAMETER, ELLIPSE_DIAMETER );

	// re-initialize graph when drawing to the right end of a screen. 
	if (cnt > width) {
		initGraph();
	}
	// count up
	cnt++;
}

// initialize graph
void initGraph() {
	background( COLOR_BACK  );
	stroke( COLOR_RECT );
	fill( COLOR_BACK );
	rect( GRAPH_MARGIN, GRAPH_MARGIN, RECT_WIDTH, RECT_HEIGHT );
	noStroke();
	cnt = 0;
}

