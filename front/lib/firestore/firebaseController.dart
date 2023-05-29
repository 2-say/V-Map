import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:front/testFeatures/debugMessage.dart';

class FirebaseController {
  var db = FirebaseFirestore.instance;

  getUser(String userName, String email) async {
    Map<String, dynamic>? result;
    await db
        .collection('users')
        .where("userName", isEqualTo: userName)
        .where('email', isEqualTo: email)
        .get()
        .then((value) {
      if (value.size > 0) {
        result = value.docs.first.data();
        result!['id'] = value.docs.first.id;
      }
    });
    return result;
  }

  //유저 로그인용
  loginUser(String email, String pw) async {
    Map<String, dynamic>? result;
    await db.collection('users').where("email", isEqualTo: email).where('pw', isEqualTo: pw).get().then((value) {
      if (value.size > 0) {
        result = value.docs.first.data();
        result!['id'] = value.docs.first.id;
      }
    });
    return result;
  }

  editPrevMeetingUser(String email, String prevMeeting) async {
    db.collection('users').where('email', isEqualTo: email).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.update({
          'prevMeeting': FieldValue.arrayUnion([prevMeeting])
        });
        DebugMessage(isItPostType: true, featureName: 'updateUser', dataType: '', data: prevMeeting).firebaseMessage();
      }
    });
  }

  //유저 추가
  addUser(String userName, String password, String email) async {
    bool duplicationChecker = false;
    Map<String, dynamic> map = {
      'userName': userName,
      'email': email,
      'password': password,
      'accessToken': '',
      'dataBaseId': '',
      'pageId': ''
    };

    await db.collection('users').where('email', isEqualTo: email).get().then((value) {
      for (var doc in value.docs) {
        print(doc.data());
        duplicationChecker = true;
      }
    });
    if (duplicationChecker == false) {
      String messageSuccess = '중복 없음을 확인, 학생 추가';
      DebugMessage(isItPostType: true, featureName: 'addUser', dataType: '', data: messageSuccess).firebaseMessage();
      db.collection('users').add(map);
      return true;
    } else {
      String messageFail = '중복 확인, 학생 추가 거부';
      DebugMessage(isItPostType: true, featureName: 'addUser', dataType: '', data: messageFail).firebaseMessage();
      return false;
    }
  }

  //유저 정보 업데이트
  updateUser(String email, String accessToken, String dataBaseId, String pageId) async {
    Map<String, dynamic> map = {'accessToken': accessToken, 'dataBaseId': dataBaseId, 'pageId': pageId};

    db.collection('users').where('email', isEqualTo: email).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.update(map);
      }
      DebugMessage(isItPostType: true, featureName: 'updateUser', dataType: '', data: map.toString()).firebaseMessage();
    });
  }

  //----------------------------------------------------------------------- 이하 meeting 컬렉션 관련 함수

  //미팅 추가
  addMeeting(
      Map<String, dynamic> clerk, String zoomUrlClerk, String zoomUrlEtc, String meetingName, String startTime) async {
    Random _random = Random();

    String randomHexString(int length) {
      StringBuffer sb = StringBuffer();
      for (var i = 0; i < length; i++) {
        sb.write(_random.nextInt(16).toRadixString(16));
      }
      return sb.toString();
    }

    String password = randomHexString(12);
    Map<String, dynamic> testContents = {
      'user': '안내',
      'startTime': '00:00',
      'endTime': '00:00',
      'text': '반갑습니다. 왼쪽하단 버튼을 통해 녹음 기능을 이용하세요.'
    };

    bool duplicationChecker = false;
    Map<String, dynamic> map = {
      'password': password,
      'clerk': clerk,
      'etc': [clerk],
      'meetingName': meetingName,
      'zoomUrlClerk': zoomUrlClerk,
      'zoomUrlEtc': zoomUrlEtc,
      'startTime': startTime,
      'endTime': '',
      'contents': [testContents],
      'summrize': [],
      'agenda': [],
      'todo': [],
      'zoomMeetingId': ''.toString(),
    };

    await db
        .collection('meetings')
        .where('clerk', isEqualTo: clerk)
        .where('startTime', isEqualTo: startTime)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        print(doc.data());
        duplicationChecker = true;
      }
    });
    if (duplicationChecker == false) {
      Map<String, dynamic> copy;
      String messageSuccess = '중복 없음을 확인, 회의록 추가';
      DebugMessage(isItPostType: true, featureName: 'addMeeting', dataType: '', data: messageSuccess).firebaseMessage();
      await db.collection('meetings').add(map);
      await db.collection('meetings').where('password', isEqualTo: password).get().then((value) {
        copy = value.docs.first.data();
        copy['id'] = value.docs.first.id;
        for (var doc in value.docs) {
          doc.reference.update(copy);
        }
      });
      return password;
    } else {
      String messageFail = '중복 확인, 회의록 추가 거부';
      DebugMessage(isItPostType: true, featureName: 'addMeeting', dataType: '', data: messageFail).firebaseMessage();
      return false;
    }
  }

  // 회의 정보 get
  getMeetingInfo(String meetingCode) async {
    Map<String, dynamic>? result;
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      if (value.size > 0) {
        result = value.docs.first.data();
        print(result!['meetingName']);
      }
      DebugMessage(isItPostType: true, featureName: 'updateMeetingParticipants', dataType: '', data: result)
          .firebaseMessage();
    });
    print(result!['meetingName']);
    return result;
  }

  updateMeetingClerk(Map<String, dynamic> clerkInfo, String meetingCode) async {
    Map<String, dynamic> map = {
      'clerk': clerkInfo,
    };
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.update(map);
      }
    });
  }

  // 회의 업데이트 함수
  updateMeetingParticipants(Map<String, dynamic> participants, String meetingCode) async {
    Map<String, dynamic>? result;
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.update({
          'etc': FieldValue.arrayUnion([participants])
        });
        if (value.size > 0) {
          result = value.docs.first.data();
          print(result!['meetingName']);
        }
      }
      DebugMessage(
              isItPostType: true, featureName: 'updateMeetingParticipants', dataType: '', data: participants.toString())
          .firebaseMessage();
    });
    print(result!['meetingName']);
    return result;
  }

  updateMeetingContents(String meetingCode, String user, String startTime, String endTime, String text) async {
    Map<String, dynamic>? content = {'startTime': startTime, 'endTime': endTime, 'user': user, 'text': text};
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.update({
          'contents': FieldValue.arrayUnion([content])
        });
      }
      DebugMessage(isItPostType: true, featureName: 'updateMeetingContents', dataType: '', data: content.toString())
          .firebaseMessage();
    });
  }

  editMeetingContents(String meetingCode, Map<String, dynamic> content, int index) async {
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      //찾은 문서의 id 추출
      String id = value.docs.first.id;
      //해당 id의 문서 레퍼런스 추출
      DocumentReference docRef = FirebaseFirestore.instance.collection('meetings').doc(id);
      //회의내용 추출
      var origin = value.docs.first.data()['contents'];
      // 회의내용 갈아끼우기
      origin[index] = content;
      //트랜잭션 실행 ( 이거 하기전까지는 다른 유저는 모두 대기상태
      db.runTransaction((transaction) async {
        DocumentSnapshot _snapshot = await transaction.get(docRef);
        if (!_snapshot.exists) {
          throw Exception('Does not exists');
        }
        docRef.update({"contents": origin});
      });
      DebugMessage(isItPostType: true, featureName: 'updateMeetingParticipants', dataType: '', data: content.toString())
          .firebaseMessage();
    });
  }

  deleteMeetingContents(String meetingCode, Map<String, dynamic> content, int index) async {
    await db.collection('meetings').where('password', isEqualTo: meetingCode).get().then((value) {
      //찾은 문서의 id 추출
      String id = value.docs.first.id;
      //해당 id의 문서 레퍼런스 추출
      DocumentReference docRef = FirebaseFirestore.instance.collection('meetings').doc(id);
      //회의내용 추출
      var origin = value.docs.first.data()['contents'];
      // 회의내용 갈아끼우기
      origin.removeAt(index);
      //맵으로 다시 감싸기
      //트랜잭션 실행 ( 이거 하기전까지는 다른 유저는 모두 대기상태
      db.runTransaction((transaction) async {
        DocumentSnapshot _snapshot = await transaction.get(docRef);
        if (!_snapshot.exists) {
          throw Exception('Does not exists');
        }
        docRef.update({"contents": origin});
      });
      DebugMessage(isItPostType: true, featureName: 'updateMeetingParticipants', dataType: '', data: content.toString())
          .firebaseMessage();
    });
  }

  //----------------------------------------------------------------------- 이하 레퍼런스용 함수
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [""];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  updateStudent(String instName, String orgName, String orgBirth, List<dynamic> group, String name, String birth,
      String phone, String examConfig) async {
    Map<String, dynamic> map = {
      'group': group,
      'name': name,
      'birth': birth,
      'phone': phone,
      "caseSearch": setSearchParam(name),
      "examConfig": examConfig
    };

    db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: orgName)
        .where('birth', isEqualTo: orgBirth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update(map);
      }
    });
  }

  updateStudentStepAndChapters(String inst, String name, String birth, String step, List<String> chapters) {
    Map<String, dynamic> map = {
      "step": step,
      "chapters": chapters,
    };
    db
        .collection('student')
        .where('inst', isEqualTo: inst)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update(map);
      }
    });
  }

  removeStudent(String instName, String name, String birth) {
    db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
    db
        .collection("testResult")
        .where("inst", isEqualTo: instName)
        .where("name", isEqualTo: name)
        .where("birth", isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
  }

  setStudentTestable(String instName, String name, String birth, bool testable) {
    db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update({'testable': testable});
      }
    });
  }

  getGroups(String instName) async {
    var result = [];
    await db.collection('group').where('inst', isEqualTo: instName).get().then((value) {
      for (var doc in value.docs) {
        result.add(doc.data()['name']);
      }
    });
    return result;
  }

  addGroup(String instName, String name) {
    Map<String, dynamic> map = {"inst": instName, "name": name, "isDefault": false};
    db.collection('group').add(map);
  }

  removeGroup(String instName, String name) {
    db.collection('group').where('inst', isEqualTo: instName).where("name", isEqualTo: name).get().then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
    db.collection('student').where("inst", isEqualTo: instName).get().then((value) {
      for (var doc in value.docs) {
        List<dynamic> group = doc.data()["group"] as List<dynamic>;
        group.remove(name);
        if (group.isEmpty) group.add("그룹 없음");
        doc.reference.update({'group': group});
      }
    });
  }

  getSteps() async {
    var result = [];
    await db.collection('step').get().then((value) {
      for (var doc in value.docs) {
        result.add(doc.data()['name']);
      }
    });
    return result;
  }

  addTestResult(String instName, String name, String birth, String title, List<bool> scores, List<dynamic> answers,
      List<dynamic> exams, DateTime datetime, String grade) {
    List<String> answers_ = answers.map((item) => '$item').toList();
    List<Map> exams_ = [];
    for (List<dynamic> r in exams) {
      Map exams_1 = {};
      String g = r[r.length - 1] as String;
      exams_1['word'] = r[0];
      exams_1['meaning'] = r[1];
      if (g == 'm') {
        exams_1['index'] = r[2];
      }
      exams_1['class'] = r[r.length - 1];
      exams_.add(exams_1);
    }
    Map<String, dynamic> map = {
      "inst": instName,
      "name": name,
      "birth": birth,
      "title": title,
      "scores": scores,
      "answers": answers_,
      "exams": exams_,
      "datetime": datetime,
      "grade": grade
    };
    db.collection('testResult').add(map);
  }

  getTestResults(String instName, String name, String birth) async {
    var result = [];
    await db
        .collection('testResult')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .orderBy('datetime')
        .get()
        .then((value) {
      for (var doc in value.docs) {
        result.add(doc.data()['title']);
      }
    });
    return result;
  }

  getTestResult(String instName, String name, String birth, String title) async {
    dynamic data;
    await db
        .collection('testResult')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        data = doc.data();
      }
    });
    return data;
  }

  updateStudentRecentResult(String instName, String name, String birth, String recent) {
    Map<String, dynamic> map = {
      // 'testable': false, // 기존 값을 따라야 한다.
      'recent': recent
    };

    db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update(map);
      }
    });
  }

  /* ExamConfig */

  setStudentExamConfig(String instName, String name, String birth, String examConfig) {
    db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.update({'examConfig': examConfig});
      }
    });
  }

  Future<void> addExamConfig(String inst, String name, int total, int cutLine, int examMultiple) async {
    Map<String, dynamic> map = {
      "inst": inst,
      "name": name,
      "total": total,
      "cutLine": cutLine,
      "examMultiple": examMultiple,
      "isDefault": false
    };
    await db.collection('examConfig').add(map);
  }

  getExamConfig(String instName, String name) async {
    Map<String, dynamic>? examConfig;
    await db
        .collection('examConfig')
        .where("inst", isEqualTo: instName)
        .where('name', isEqualTo: name)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        examConfig = qds.data() as Map<String, dynamic>?;
      }
    });
    return examConfig;
  }

  Future<QueryDocumentSnapshot?> _getExamConfig(String inst, String name) async {
    await db.collection('examConfig').where("inst", isEqualTo: inst).where("name", isEqualTo: name).get().then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        print(qds['total']);
        return qds.data();
      }
    });
    return null;
  }

  Future<void> updateExamConfig(String inst, String name, int total, int cutLine, int examMultiple) async {
    Map<String, dynamic> map = {"total": total, "cutLine": cutLine, "examMultiple": examMultiple};
    await db.collection('examConfig').where("inst", isEqualTo: inst).where("name", isEqualTo: name).get().then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        qds.reference.update(map);
      }
    });
  }

  Future<void> removeExamConfig(String inst, String name) async {
    await db.collection('examConfig').where("inst", isEqualTo: inst).where("name", isEqualTo: name).get().then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        qds.reference.delete();
      }
    });
  }
}
