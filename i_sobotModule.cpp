// 
// i-sobot通信プログラム
// written by Takashi Ogura <t.ogura@gmail.com>
//
// based on SoftwareSerial example by Tom Igoe
// based on examples by David Mellis and Heather Dewey-Hagborg

#include "i_sobotModule.h"

#define ADOF 5
#define serialSpeed 2400

i_sobotModule::i_sobotModule(int txPin):_serial(0, txPin)
{
	_txPin = txPin;
}

void i_sobotModule::setup()
{
	pinMode(_txPin, OUTPUT);
	_serial.begin(serialSpeed);
}

void i_sobotModule::writeCheckSum(byte *pos)
{
	int checkSum = 0;
	int i = 0; 
	
	// 普通に足したらうまくいかないので・・・
	for ( i = 0; i < ADOF; i++)
	{
		checkSum += pos[i];
		if ( checkSum > 255 )
		{
			checkSum -= 255;
		}
	}
	checkSum += 5;// header部分
	// 書き込み
	_serial.print(lowByte(checkSum), BYTE);
}

void i_sobotModule::writeAngleHeader()
{
	_serial.print(255, BYTE); // データの切れ目
	_serial.print(5,BYTE); // データの数?コマンド?
}

void i_sobotModule::writeAngleData(byte *pos)
{
	int i = 0;
	for ( i = 0; i < ADOF; i++)
	{
		_serial.print(pos[i], BYTE);
	}
}

void i_sobotModule::writeAngles(byte *pos)
{
	writeAngleHeader();
	writeAngleData(pos);
	writeCheckSum(pos);
}

