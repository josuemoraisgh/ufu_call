class Course {
  late int id, categoryid;
  int? categorysortorder,
      showgrades,
      newsitems,
      startdate,
      enddate,
      numsections,
      maxbytes,
      showreports,
      visible,
      hiddensections,
      groupmode,
      groupmodeforce,
      defaultgroupingid,
      timecreated,
      timemodified,
      enablecompletion,
      completionnotify,
      summaryformat;
  late String shortname, fullname, summary, format;
  String? displayname, idnumber, lang, forcetheme;
  //List<Courseformatoptions> courseformatoptions;
  //List<Customfields> customfields;
  /*Course(this._id,  this._shortname,  this._categoryid,  this._categorysortorder,  this._fullname,  this._displayname,  this._idnumber,  this._summary,  this._summaryformat,  
  this._format,  this._showgrades,  this._newsitems,  this._startdate,  this._enddate,  this._numsections,  this._maxbytes,  this._showreports,  this._visible,  
  this._hiddensections,  this._groupmode,  this._groupmodeforce,  this._defaultgroupingid,  this._timecreated,  this._timemodified,  this._enablecompletion,  
  this._completionnotify,  this._lang,  this._forcetheme);*/

  Course(
    this.id,
    this.categoryid,
    this.shortname,
    this.fullname,
    this.summary,
    this.format,
  );

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['shortname'] = shortname;
    map['categoryid'] = categoryid;
    map['categorysortorder'] = categorysortorder;
    map['fullname'] = fullname;
    map['displayname'] = displayname;
    map['idnumber'] = idnumber;
    map['summary'] = summary;
    map['summaryformat'] = summaryformat;
    map['format'] = format;
    map['showgrades'] = showgrades;
    map['newsitems'] = newsitems;
    map['startdate'] = startdate;
    map['enddate'] = enddate;
    map['numsections'] = numsections;
    map['maxbytes'] = maxbytes;
    map['showreports'] = showreports;
    map['visible'] = visible;
    map['hiddensections'] = hiddensections;
    map['groupmode'] = groupmode;
    map['groupmodeforce'] = groupmodeforce;
    map['defaultgroupingid'] = defaultgroupingid;
    map['timecreated'] = timecreated;
    map['timemodified'] = timemodified;
    map['enablecompletion'] = enablecompletion;
    map['completionnotify'] = completionnotify;
    map['lang'] = lang;
    map['forcetheme'] = forcetheme;
    return map;
  }

  // Extract a Note object from a Map object
  Course.fromMapObject(Map<String, dynamic> map) {
    id = map['id']!;
    shortname = map['shortname']!;
    categoryid = map['categoryid']!;
    categorysortorder = map['categorysortorder'];
    fullname = map['fullname']!;
    displayname = map['displayname'];
    idnumber = map['idnumber'];
    summary = map['summary']!;
    summaryformat = map['summaryformat'];
    format = map['format']!;
    showgrades = map['showgrades'];
    newsitems = map['newsitems'];
    startdate = map['startdate'];
    enddate = map['enddate'];
    numsections = map['numsections'];
    maxbytes = map['maxbytes'];
    showreports = map['showreports'];
    visible = map['visible'];
    hiddensections = map['hiddensections'];
    groupmode = map['groupmode'];
    groupmodeforce = map['groupmodeforce'];
    defaultgroupingid = map['defaultgroupingid'];
    timecreated = map['timecreated'];
    timemodified = map['timemodified'];
    enablecompletion = map['enablecompletion'];
    completionnotify = map['completionnotify'];
    lang = map['lang'];
    forcetheme = map['forcetheme'];
  }
}
