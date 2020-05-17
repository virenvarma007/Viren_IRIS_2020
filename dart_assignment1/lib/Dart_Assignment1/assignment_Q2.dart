import 'dart:core';
import 'dart:io';

class OpenElectives{
  String coursename, coursecode;

  OpenElectives(String coursename, String coursecode) {
    this.coursename= coursename;
    this.coursecode= coursecode;
  }
  void showOutput1() {
    print('$coursename,$coursecode');
  }
}

class BranchElectives{
  String coursename, coursecode, Branch, year;

  BranchElectives(String coursename, String coursecode, String Branch, String year) {
    this.coursename= coursename;
    this.coursecode= coursecode;
    this.Branch= Branch;
    this.year= year;
  }
  void showOutput2() {
    print('$coursename,$coursecode,$Branch,$year');
  }
}

void main() {
  List<OpenElectives> openCourses = [
    OpenElectives('Elective1','el111'),
    OpenElectives('Elective2','el112'),
    OpenElectives('Elective3','el113'),
    OpenElectives('Elective4','el114'),
    OpenElectives('Elective5','el115'),
  ];
  List<BranchElectives> branchCourses = [
    BranchElectives('Course1','co111','CS','1'),
    BranchElectives('Course1','co111','IT','2'),
    BranchElectives('Course1','co111','ECE','2'),
    BranchElectives('Course1','co111','EEE','3'),
    BranchElectives('Course1','co111','Mechanical','3'),
    BranchElectives('Course1','co111','Chemical','4'),
    BranchElectives('Course1','co111','Civil','4')
  ];
  var input5 = '1';
  while(input5== '1') {
    print(
        "Welcome to Course Enquiry: \n May I know if you are a Student or an Admin \n Press: \n 1.Admin\n 2.Student");
    var input1 = stdin.readLineSync();
    switch (input1) {
      case '1':
        print('Welcome Admin');
        print('Here are the list of Open Electives:');
        for (var n in openCourses) {
          n.showOutput1();
        }
        print('Here are the list of Branch Electives:');
        for (var m in branchCourses) {
          m.showOutput2();
        }
        print("Press 1 to add a course and press 2 to exit:");
        var input2 = stdin.readLineSync();
        if (input2 == '2') {
          break;
        }
        else if (input2 == '1') {
          print(
              'Press \n 1.Add an Open Elective \n 2.Add a Branch Elective \n');
          var input3 = stdin.readLineSync();
          switch (input3) {
            case '1':
              print('Enter CourseName for Open Elective:');
              String cname1 = stdin.readLineSync();
              print('Enter CourseCode for Open Elective:');
              String ccode1 = stdin.readLineSync();
              openCourses.add(OpenElectives(cname1, ccode1));
              print('Course has been added');
              for (var n in openCourses) {
                n.showOutput1();
              }
              break;

            case '2':
              print('Enter CourseName for Branch Elective:');
              String cname2 = stdin.readLineSync();
              print('Enter CourseCode for Branch Elective:');
              String ccode2 = stdin.readLineSync();
              print('Enter Branch:');
              String branch2 = stdin.readLineSync();
              print('Enter Year for Branch Elective:');
              String year2 = stdin.readLineSync();
              branchCourses.add(
                  BranchElectives(cname2, ccode2, branch2, year2));
              print('Course has been added');
              for (var m in branchCourses) {
                m.showOutput2();
              }
              break;

            default:
              print('Invalid Input');
              break;
          }
        }
        else {
          print('Invalid Input');
          break;
        }

        break;
      case '2':
        print('Welcome Student');
        print('Press: \n 1.View Open Electives \n 2.View Branch Electives \n');
        var input4 = stdin.readLineSync();
        switch (input4) {
          case '1':
            print('Here are the list of Open Electives:');
            for (var n in openCourses) {
              n.showOutput1();
            }
            break;
          case '2':
            print('Enter your branch');
            var sbranch = stdin.readLineSync();
            print('Enter your Year');
            var syear = stdin.readLineSync();
            for (int i = 0; i < branchCourses.length; i++) {
              if (sbranch == branchCourses[i].Branch &&
                  syear == branchCourses[i].year) {
                String scoursecode, scoursename;
                scoursecode = branchCourses[i].coursecode;
                scoursename = branchCourses[i].coursename;
                print('$syear, $sbranch, $scoursename, $scoursecode');
              }
              else {
                print(
                    "No Branch Specific Courses applicable for $syear and $sbranch");
                print('Here are the list of Open Electives:');
                for (var n in openCourses) {
                  n.showOutput1();
                }
                break;
              }
            }
            break;
          default:
            print('Invalid Input');
            break;
        }
        break;

      default:
        print('Invalid Input');
        break;
    }
    print("Press 1 to restart and 0 to end");
    input5 = stdin.readLineSync();
  }

}