class StateList {
  String StateId;
  String StateName;

  StateList({
    this.StateId,
    this.StateName,
  });

  factory StateList.fromJson(Map<String, dynamic> json) {
    return StateList(
      StateId: json['StateId'],
      StateName: json['StateName'],
    );
  }
}
