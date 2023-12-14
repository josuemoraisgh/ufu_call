class Category {
  late int id,
      parent,
      sortorder,
      coursecount,
      visible,
      visibleold,
      timemodified,
      depth;
  late String name, idnumber, description, descriptionformat, path, theme;

  Category(
      this.id,
      this.name,
      this.idnumber,
      this.description,
      this.descriptionformat,
      this.parent,
      this.sortorder,
      this.coursecount,
      this.visible,
      this.visibleold,
      this.timemodified,
      this.depth,
      this.path,
      this.theme);

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['idnumber'] = idnumber;
    map['description'] = description;
    map['descriptionformat'] = descriptionformat;
    map['parent'] = parent;
    map['sortorder'] = sortorder;
    map['coursecount'] = coursecount;
    map['visible'] = visible;
    map['visibleold'] = visibleold;
    map['timemodified'] = timemodified;
    map['depth'] = depth;
    map['path'] = path;
    map['theme'] = theme;
    return map;
  }

  // Extract a Note object from a Map object
  Category.fromMapObject(Map<String, dynamic> map) {
    id = map['id']!;
    name = map['name']!;
    idnumber = map['idnumber']!;
    description = map['description']!;
    descriptionformat = map['descriptionformat']!;
    parent = map['parent']!;
    sortorder = map['sortorder']!;
    coursecount = map['coursecount']!;
    visible = map['visible']!;
    visibleold = map['visibleold']!;
    timemodified = map['timemodified']!;
    depth = map['depth']!;
    path = map['path']!;
    theme = map['theme']!;
  }
}
