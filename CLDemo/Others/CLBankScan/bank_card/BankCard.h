//接口 判断当前图像的对焦数值，决定是否进行调用识别
//一般认为返回值大于5.0f可以进行识别
#ifdef __cplusplus
extern "C"
#endif
float GetFocusScore(unsigned char *imgdata, int width, int height, int pitch, int lft, int top, int rgt, int btm);

//接口
//根据ImageFormat.NV21直接用来识别，不经过java层的转换，这样提高工作效率, java层转化太慢了 Android
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV21(unsigned char *pbResult, int nMaxSize, unsigned char *pbNV21, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);

//接口
//根据ImageFormat.NV12直接用来识别  IOS
#ifdef __cplusplus
extern "C"
#endif
int BankCardNV12(unsigned char *pbResult, int nMaxSize, unsigned char *pbNV12, int iW, int iH, int iLft, int iTop, int iRgt, int iBtm);


//接口：一般在手机上调用上面接口
//输入32位的图像，转成24位的图像，Android系统用
#ifdef __cplusplus
extern "C"
#endif
int BankCard32(unsigned char *pbResult, int nMaxSize, unsigned char *pbImg32, int iW, int iH, int iPitch);

