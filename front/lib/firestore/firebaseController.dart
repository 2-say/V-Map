import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseController {
  var db = FirebaseFirestore.instance;

  getInst(String name) async {
    Map<String, dynamic>? result;
    await db
        .collection('inst')
        .where('name', isEqualTo: name)
        .get()
        .then((inst) {
      if (inst.size > 0) {
        result = inst.docs.first.data();
      }
    });
    return result;
  }

  getStudent(String instName, String name, String password) async {
    Map<String, dynamic>? result;
    await db
        .collection('student')
        .where("inst", isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: password)
        .get()
        .then((value) {
      if (value.size > 0) {
        result = value.docs.first.data();
      }
    });
    return result;
  }

  addStudent(String instName, List<dynamic> group, String name, String birth,
      String phone, String examConfig) async {
    bool duplicationChecker = false;
    Map<String, dynamic> map = {
      'inst': instName,
      'group': group,
      'name': name,
      'birth': birth ?? "0000",
      'phone': phone ?? "01000000000",
      'step': "-",
      'chapters': [],
      'testable': false,
      'recent': "-",
      'is_master': false,
      "caseSearch": setSearchParam(name),
      "examConfig": examConfig
    };

    await db
        .collection('student')
        .where('inst', isEqualTo: instName)
        .where('name', isEqualTo: name)
        .where('birth', isEqualTo: birth)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        print(doc.data());
        duplicationChecker = true;
      }
    });
    if (duplicationChecker == false) {
      print('중복 없음을 확인, 학생 추가');
      db.collection('student').add(map);
      return true;
    }
    else {
      print('중복 확인, 추가 거부');
      return false;
    }
  }

  setSearchParam(String caseNumber) {
    List<String> caseSearchList = [""];
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i];
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }

  updateStudent(String instName,
      String orgName,
      String orgBirth,
      List<dynamic> group,
      String name,
      String birth,
      String phone,
      String examConfig) async {
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

  updateStudentStepAndChapters(String inst, String name, String birth,
      String step, List<String> chapters) {
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

  setStudentTestable(String instName, String name, String birth,
      bool testable) {
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
    await db
        .collection('group')
        .where('inst', isEqualTo: instName)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        result.add(doc.data()['name']);
      }
    });
    return result;
  }

  addGroup(String instName, String name) {
    Map<String, dynamic> map = {
      "inst": instName,
      "name": name,
      "isDefault": false
    };
    db.collection('group').add(map);
  }

  removeGroup(String instName, String name) {
    db
        .collection('group')
        .where('inst', isEqualTo: instName)
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      for (var doc in value.docs) {
        doc.reference.delete();
      }
    });
    db
        .collection('student')
        .where("inst", isEqualTo: instName)
        .get()
        .then((value) {
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

  addTestResult(String instName,
      String name,
      String birth,
      String title,
      List<bool> scores,
      List<dynamic> answers,
      List<dynamic> exams,
      DateTime datetime,
      String grade) {
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

  getTestResult(String instName, String name, String birth,
      String title) async {
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

  updateStudentRecentResult(String instName, String name, String birth,
      String recent) {
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

  setStudentExamConfig(String instName, String name, String birth,
      String examConfig) {
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

  Future<void> addExamConfig(String inst, String name, int total, int cutLine,
      int examMultiple) async {
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

  Future<QueryDocumentSnapshot?> _getExamConfig(String inst,
      String name) async {
    await db
        .collection('examConfig')
        .where("inst", isEqualTo: inst)
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        print(qds['total']);
        return qds.data();
      }
    });
    return null;
  }

  Future<void> updateExamConfig(String inst, String name, int total,
      int cutLine, int examMultiple) async {
    Map<String, dynamic> map = {
      "total": total,
      "cutLine": cutLine,
      "examMultiple": examMultiple
    };
    await db
        .collection('examConfig')
        .where("inst", isEqualTo: inst)
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        qds.reference.update(map);
      }
    });
  }

  Future<void> removeExamConfig(String inst, String name) async {
    await db
        .collection('examConfig')
        .where("inst", isEqualTo: inst)
        .where("name", isEqualTo: name)
        .get()
        .then((value) {
      for (QueryDocumentSnapshot qds in value.docs) {
        qds.reference.delete();
      }
    });
  }
}
