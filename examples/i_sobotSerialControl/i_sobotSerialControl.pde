// 
// i-sobot通信プログラム
// written by Takashi Ogura <t.ogura@gmail.com>
//
// ver 0.0.1  2009/11/11 text input
// ver 0.0.0  2009/10/31 initial version
//
#include <SoftwareSerial.h>
#include <i_sobot.h>

//
// 定数のdefine
//
#define headPin 4
#define larmPin 2
#define rarmPin 6
#define llegPin 3
#define rlegPin 5

#define ledPin 13

#define CMD_ALL 1
#define CMD_HEAD 2
#define CMD_LARM 3
#define CMD_RARM 4
#define CMD_LLEG 5
#define CMD_RLEG 6
#define MAX_BUF_LEN 256
//
// グローバル変数
//
byte ledPinState = 0;  // LEDの状態
byte command;  // PCとのシリアル通信におけるコマンドID
byte jointBuf[I_SOBOT_DOF];  // PCとのシリアル通信のバッファ
int jointIt = 0; // ジョイント角度配列のイテレータ
i_sobot robot = i_sobot(headPin, larmPin, rarmPin, llegPin, rlegPin); // i-sobot操作用インスタンス

//
// setup()
//
void setup()
{
    // 初期化 (pinMode, SoftSerial)
    robot.setup();
    // PCからのコマンドをシリアル(USB)で受信
    Serial.begin(9600);
    // for debug
    pinMode(ledPin, OUTPUT);
}

//
// loop()
//
void loop()
{

    receiveSerial();
}


void receiveSerial()
{
   
    command = receiveCommand();
    if ( command )
    {
	if (receiveData())
	{
	    sendCommand();
	}
    }
}

byte receiveCommand()
{
    // PCとのシリアル通信で受信したbyte
    byte receiveByte;
    int it = -1;

    // PCからのコマンドを受信したとき
    while(it == -1)
    {
	if (Serial.available() > 0)
	{	
	    receiveByte = Serial.read();
	    // コマンド待ち
	    // 最初の1byteはコマンドとして認識する
	    // 識別可能なコマンドは以下(カッコの中はその後に必要なデータ数(byte))
	    // 'a'(17): 全軸の姿勢角を指定する
	    // 'h'(1):  頭の姿勢角を指定する
	    // 'l'(3):  左腕の姿勢角を指定する
	    // 'r'(3):  右腕の姿勢角を指定する
	    // 'L'(5):  左脚の姿勢角を指定する
	    // 'R'(5):  右脚の姿勢角を指定する
	    switch ( receiveByte )
	    {
	    case 'a':
		command = CMD_ALL;
		it = 0;
		//Serial.print("CMD_ALL:");
		break;
	    case 'h':
		command = CMD_HEAD;
		it = 0;
		//Serial.print("CMD_HEAD:");
		break;
	    case 'l':
		command = CMD_LARM;
		it = 0;
		//Serial.print("CMD_LARM:");
		break;
	    case 'r':
		command = CMD_RARM;
		it = 0;
		//Serial.print("CMD_RARM:");
		break;
	    case 'L':
		command = CMD_LLEG;
		it = 0;
		//Serial.print("CMD_LLEG:");
		break;
	    case 'R':
		command = CMD_RLEG;
		it = 0;
		//Serial.print("CMD_RLEG:");
		break;
	    default:
		it = -1;
		Serial.println("no such command");
		//ループを繰り返す
		break;
	    }
	}
    }

    return command;
}

int receiveData()
{
    // PCとのシリアル通信で受信したbyte
    byte receiveByte;
    int jointAngle;
    char buf[MAX_BUF_LEN];  // PCとのシリアル通信のバッファ
    int it = -1;   // PCとのシリアル通信の受信イテレータ
    int isReceiving = 1;
    jointIt = 0; // 初期化

    //Serial.println("start receiveData");
    // PCからのコマンドを受信したとき
    while(it < MAX_BUF_LEN && isReceiving)
    {
	if (Serial.available() > 0)
	{	
	    // コマンドの内容を受信
	    it++;
	    buf[it] = Serial.read();
	    // 受信内容(関節角度)をPCに送信
	    //Serial.print(buf[it]);

	    // 'E'を受け取ったら終了というプロトコル
	    if (buf[it] == 'E')
	    {
		isReceiving = 0;
	    }
	    if (buf[it] == ',' || buf[it] == ' ' || buf[it] == 'E' )
	    {
		// ,の前までを文字列から数字に置き換えて jointBufに入れる
		buf[it] = '\0';
		jointAngle = atoi(buf);
		it = -1;//イテレータを戻す
		//Serial.print("JA=");
		//Serial.println(buf);
		if (jointAngle >= 0 && jointAngle < 256 )
		{
		    jointBuf[jointIt] = (byte)jointAngle;
		    //Serial.print(" receive=");
		    //Serial.println(jointAngle);
		    jointIt++;
		}
		else
		{
		    Serial.println("joint angle range error! 0=<j<256");
		    return 0; // fail
		}	
		
	    }
	}
    }
    return 1; // success
}


void sendCommand()
{
    //Serial.print(jointIt);
    //Serial.println(" joint data");

    if ( command == CMD_ALL && jointIt == I_SOBOT_DOF )
    {
	robot.writeAngles(jointBuf);
	Serial.println("a");
    }
    else if ( command == CMD_HEAD && jointIt >= 1 )
    {
	robot.writeHeadAngles(jointBuf);
	Serial.println("h");
    }
    else if ( command == CMD_LARM && jointIt >= 3 )
    {
	robot.writeLarmAngles(jointBuf);
	Serial.println("l");
    }
    else if ( command == CMD_RARM && jointIt >= 3 )
    {
	robot.writeRarmAngles(jointBuf);
	Serial.println("r");
    }
    else if ( command == CMD_LLEG && jointIt >= 5 )
    {
	robot.writeLlegAngles(jointBuf);
	Serial.println("L");
    }
    else if ( command == CMD_RLEG && jointIt >= 5 )
    {
	robot.writeRlegAngles(jointBuf);
	Serial.println("R");
    }
    else
    {
	// 何もしない
    }
    
    toggleLed(ledPin); // 動作が見えるよう、受信するたびにLEDを反転
}

void toggleLed(int pinNum) {
    digitalWrite(pinNum, ledPinState);
    ledPinState = !ledPinState;  // pinStateが0なら1、1なら0に反転
}
