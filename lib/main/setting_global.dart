
settingpagenum class_setting = settingpagenum();

class settingpagenum{
  int _settingnum = 2;

  void setting(int num){
    _settingnum = num;
  }

  int getnum(){
    return _settingnum;
  }
}