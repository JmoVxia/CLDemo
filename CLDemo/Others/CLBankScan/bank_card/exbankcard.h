/************************************************************************\
北京易道博识科技有限公司
CopyRight (C) 2018

File name: exbankcard.h
  Function : 银行卡识别接口文件
  Author   : zjm@exocr.com
  Version  : 2017.12.12	V1.2
***************************************************************************/

#ifndef __EX_BANK_CARD_H__
#define __EX_BANK_CARD_H__

//打开文件识别，用于调试和开发使用
#ifdef __cplusplus
extern "C"
#endif
int BankCardRecoFile(const char *szImgFile, unsigned char *pbResult, int nMaxSize);

//接口
//24位色 RGB或者BGR 识别
#ifdef __cplusplus
extern "C"
#endif
int BankCard24(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg24, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

//接口
//输入32(0xargb)位的图像，转成24位的图像，Android系统用
#ifdef __cplusplus
extern "C"
#endif
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch, int iLft, int iTop, int iRgt, int iBtm);

//接口
//根据ImageFormat.NV21直接用来识别，不经过java层的转换，这样提高工作效率, java层转化太慢了
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbVU, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//接口
//根据ImageFormat.NV12直接用来识别
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbY, unsigned char *pbUV, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//接口
//获取对焦分数
#ifdef __cplusplus
extern "C"
#endif
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);


#endif //__EX_BANK_CARD_H__
