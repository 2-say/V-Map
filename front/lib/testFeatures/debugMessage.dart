class DebugMessage {
  bool isItPostType;
  String featureName;
  String dataType;
  var data;

  DebugMessage({
    required this.isItPostType,
    required this.featureName,
    required this.dataType,
    required this.data,
  });

  void message() {
    print('------------------------------------------------debug message------------------------------------------------');
    isItPostType == true
        ? print('featureType:http/post')
        : print('featureType:http/get');
    print('featureName:$featureName');
    print('dataType:json');
    print('body:\n$data');
    print('-------------------------------------------------------------------------------------------------------------');
  }
}
