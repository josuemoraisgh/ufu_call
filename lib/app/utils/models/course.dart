import 'dart:core';

class Course {
  late int id, summaryformat;
  late String shortname, fullname, summary, format, idnumber, fileurl;

  Course(
    this.id,
    this.shortname,
    this.fullname,
    this.summary,
    this.format,
    this.idnumber,
    this.summaryformat,
    this.fileurl,
  );

  // Convert a Note object into a Map object
  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['shortname'] = shortname;
    map['fullname'] = fullname;
    map['idnumber'] = idnumber;
    map['summary'] = summary;
    map['summaryformat'] = summaryformat;
    map['format'] = format;
    map['fileurl'] = fileurl;

    return map;
  }

  Course.fromJson(Map<String, dynamic> map) {
    id = map['id']!;
    shortname = map['shortname']!;
    fullname = map['fullname']!;
    idnumber = map['idnumber'];
    summary = map['summary']!;
    summaryformat = map['summaryformat'];
    format = map['format']!;
    fileurl = ((map['overviewfiles'] as List).isNotEmpty
        ? map['overviewfiles'][0]['fileurl']
        : "");
  }
}
