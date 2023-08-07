User user = User();
Serviceaddress svaddress = Serviceaddress();

class User {
  String name = "";
  String birthday = "";
  String phonenumber = "";
  String email = "";
  String password = "";

  String zipcode = "";

  String address1 = "";
  String address2 = "";
  String address3 = "";
  String address4 = "";
  String address5 = "";
  String addressnickname = "";

  String profile = "";
  String nickname = "";

  void init(){
    name = "";
    birthday = "";
    phonenumber = "";
    email = "";
    password = "";

    zipcode = "";
    address1 = "";
    address2 = "";
    address3 = "";
    address4 = "";
    address5 = "";

    profile = "";
    nickname = "";
  }

  void init1(){
    phonenumber = "";
  }
  void init2(){
    name = "";
    birthday = "";
    email = "";
    password = "";
  }
  void init3(){
    zipcode = "";
    address1 = "";
    address2 = "";
    address3 = "";
    address4 = "";
    address5 = "";
    addressnickname = "";
  }
  void init4(){
    profile = "";
    nickname = "";
  }
}

class Serviceaddress {
  String _address = "";

  void init(){
    _address = "";
  }

  void set(String address){
    this._address = address;
  }

  String get(){
    return _address;
  }
}
