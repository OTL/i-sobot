//
//
//
//
//
#include "i_sobot.h"

i_sobot::i_sobot(int headPin, int larmPin, int rarmPin, int llegPin, int rlegPin) :
	_head(headPin),
	_larm(larmPin),
	_rarm(rarmPin),
	_lleg(llegPin),
	_rleg(rlegPin)
{
}

void i_sobot::setup()
{
	_head.setup();
	_larm.setup();
	_rarm.setup();
	_lleg.setup();
	_rleg.setup();
}

void i_sobot::writeHeadAngles(byte *pos)
{
    // なぜか[3]が頭
    byte tmpPos[5];

    tmpPos[0] = 0;
    tmpPos[1] = 0;
    tmpPos[2] = 0;
    tmpPos[3] = pos[0];
    tmpPos[4] = 0;

    _head.writeAngles(tmpPos);
}

void i_sobot::writeLarmAngles(byte *pos)
{
    byte tmpPos[5];
    memcpy(tmpPos,pos,5);
    tmpPos[3] = 0;
    tmpPos[4] = 0;
    _larm.writeAngles(tmpPos);
}


void i_sobot::writeRarmAngles(byte *pos)
{
    byte tmpPos[5];
    memcpy(tmpPos,pos,5);
    tmpPos[3] = 0;
    tmpPos[4] = 0;
    _rarm.writeAngles(tmpPos);
}


void i_sobot::writeLlegAngles(byte *pos)
{
    byte tmpPos[5];
    memcpy(tmpPos,pos,5);
    _lleg.writeAngles(tmpPos);
}


void i_sobot::writeRlegAngles(byte *pos)
{
    byte tmpPos[5];
    memcpy(tmpPos,pos,5);
    _rleg.writeAngles(tmpPos);
}

// 頭[1], 左腕[3], 右腕[3], 左脚[5], 右脚[5]
// 合計17軸の角度を並べる(128がニュートラル。単位はほぼdeg (?))
void i_sobot::writeAngles(byte *pos)
{
    writeHeadAngles(pos);
    writeLarmAngles(pos+1);
    writeRarmAngles(pos+1+3);
    writeLlegAngles(pos+1+3+3);
    writeRlegAngles(pos+1+3+3+5);
}
