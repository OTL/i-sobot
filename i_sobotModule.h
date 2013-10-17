/*
 *  i_sobotModule.h
 *  i-sobotの各モジュール(頭、左腕、右腕、左脚、右脚)への指令
 *
 *  Created by OTL on 09/10/31.
 *  Copyright 2009 OTL. All rights reserved.
 *
 */
#ifndef i_sobotModule_h
#define i_sobotModule_h

#include "WProgram.h"

#include <SoftwareSerial.h>  // ライブラリの導入

class i_sobotModule
{
 public:
  i_sobotModule(int txPin);
  void setup();
  void writeAngles(byte *pos);

 private:
  // シリアルポートのTx用のピン番号
  int _txPin;
  // このモジュールで利用するシリアルポート
  SoftwareSerial _serial;

  // チェックサムの計算
  void writeCheckSum(byte *pos);
  // ヘッダの出力
  void writeAngleHeader();
  // 関節角度を書き込み
  void writeAngleData(byte *pos);
};

#endif
