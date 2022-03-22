import 'dart:convert';

class Convert {
  List<String> methodList = [];
  bool _toJson = false;
  String _getClassName(String className) {
    return "${className[0].toUpperCase()}${className.substring(1)}";
  }

  String _checkDic(String className, Map<String, dynamic> jsonContent) {
    final cla = "class ${_getClassName(className)} {\n";
    return _checkJson(className, cla, jsonContent);
  }

  String _checkList(String className, List list) {
    Map dic = list.first as Map;
    return _checkDic(className, dic as Map<String, dynamic>);
  }

  String checkListType(String className, List list) {
    final val = list.first;
    if (val is num) {
      return "num";
    } else if (val is String) {
      return 'String';
    } else if (val is List) {
      return 'List';
    } else {
      return _getClassName(className);
    }
  }

  String _checkJson(String className, String content, Map<String, dynamic> jsonContent) {
    // 属性
    String pro = "";
    // 构造方法
    String method = '''extension {0}Ext on {0} {\n  static {0} fromJson(Map<String, dynamic> json) {\n  return {0}(\n'''
        .replaceAll("{0}", _getClassName(className));
    String toJsonString =
        "\n  Map<String, dynamic> toJson() {\n    final Map<String, dynamic> data = <String, dynamic>{};\n";
    List<String> otherClass = [];
    for (var key in jsonContent.keys) {
      final val = jsonContent[key];
      pro += "this." + key + ", ";
      if (val is String) {
        content += "  final String? " + key + ";\n";
        method += "      " + key + ": json['$key'],\n";
        toJsonString += "    data['$key'] = $key;\n";
      } else if (val is int) {
        content += "  final int? " + key + ";\n";
        method += "      " + key + ": json['$key'],\n";
        toJsonString += "    data['$key'] = $key;\n";
      } else if (val is double) {
        content += "  final double? " + key + ";\n";
        method += "      " + key + ": json['$key'],\n";
        toJsonString += "    data['$key'] = $key;\n";
      } else if (val is Map) {
        content += "  final " + _getClassName(key) + "? " + key + ";\n";
        method += "      " + key + ": json['$key'] != null ? ${_getClassName(key)}Ext.fromJson(json['$key']) : null,\n";
        final temp = _checkDic(key, val as Map<String, dynamic>);
        toJsonString += "    if ($key != null) {\n      data['$key'] = $key!.toJson();\n    }\n";
        otherClass.add(temp);
      } else if (val is List) {
        final ty = checkListType(key, val);
        content += "  final List<$ty>? " + key + ";\n";
        if (ty == _getClassName(key)) {
          final temp = _checkList(key, val);
          otherClass.add(temp);
          method += "      " + key + ": json['$key']?.map<$ty>((e) => ${ty}Ext.fromJson(e)).toList(),\n";
        } else {
          method += "      " + key + ": json['$key']?.cast<$ty>(),\n";
        }
        toJsonString += "    if ($key != null) {\n      data['$key'] = $key!.map((v) => v.toJson()).toList();\n    }\n";
      }
    }
    content += "  ${_getClassName(className)}({" + pro + "});\n";
    toJsonString += "    return data;\n  }\n\n";
    if (_toJson) content += toJsonString;
    content += "}\n\n";
    method += "    );\n  }\n}\n\n";
    content += otherClass.join("");
    methodList.add(method);
    return content;
  }

  String convert({required String content, String? className, bool toJson = false}) {
    String res = '''class ${className ?? 'Response'} { \n''';
    _toJson = toJson;
    Map<String, dynamic> jsonContent = json.decode(content);
    res += _checkJson(className ?? 'Response', "", jsonContent);
    res += methodList.join("");
    return res;
  }
}
