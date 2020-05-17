import 'dart:core';
import 'dart:io';

void main() {
  var LoginMap = {
    'ID1': 'password1@',
    'ID2': 'password2@',
    'ID3': 'password3@',
    'ID4': 'password4@',
    'ID5': 'password5@',
    'ID6': 'password6@'
  };
  var input1 = '1';
  while (input1 == '1') {
    print('Welcome to LogIn \n Please Sign in to continue:\n Enter Login');
    String Id= stdin.readLineSync();
    if (Id != ''){//I used '' instead of something like null because null was continuing
      sleep( const Duration(seconds: 5));
      print('Welcome $Id, Please Enter Your Password:');
      String password= stdin.readLineSync();
      if (password == LoginMap[Id]) {
        sleep(const Duration(seconds: 5));
        print('Welcome $Id, You have succesfully signed into your account!');
        break;
      }
      else {
        print('Press \n 1.To Try again \n 2.To Exit');
        input1= stdin.readLineSync();
      }
    }
    else {
      print('Press \n 1.To Try again \n 2.To Exit');
      input1= stdin.readLineSync();
    }
  }
}
