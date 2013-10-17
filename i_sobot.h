/*
 *  i_sobot.h
 *  i-sobotを各関節角度を指定して操作するライブラリ。
 *  ハードウェアの改造が必要。
 *
 *  Created by OTL on 09/10/31.
 *  Copyright 2009 OTL. All rights reserved.
 *
 */

#ifndef i_sobot_h
#define i_sobot_h

#include "WProgram.h"
#include "i_sobotModule.h"

#define I_SOBOT_DOF 17

class i_sobot
{
public:
    i_sobot(int headPin, int larmPin, int rarmPin, int llegPin, int rlegPin);
    void setup();
    // 各モジュールへの指令
    void writeHeadAngles(byte *pos);
    void writeLarmAngles(byte *pos);
    void writeRarmAngles(byte *pos);
    void writeLlegAngles(byte *pos);
    void writeRlegAngles(byte *pos);
    // 全身の関節角度を指定する
    void writeAngles(byte *pos);
private:
    i_sobotModule _head;
    i_sobotModule _larm;
    i_sobotModule _rarm;
    i_sobotModule _lleg;
    i_sobotModule _rleg;
};

#endif
