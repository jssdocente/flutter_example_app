
class PersonalNameVO {
  final String name;

  PersonalNameVO(this.name);

  String get getInitials => _calculateInitials();

  String get getAvatarInitials => _calculateInitials(length: 2);

  String _calculateInitials({int length=10}) {
    try {
      var initials = new StringBuffer();
      this.name.split(" ")
          .take(length)
          .map((part) => part.substring(0, 1))
          .forEach((initial) => initials.write(initial));

      return initials.toString();
    } catch(ex){
      return "";
    }
  }

  String toJson() => name;

  @override
  String toString() {
    return name;
  }

  factory PersonalNameVO.empty() {
    return PersonalNameVO("");
  }


}