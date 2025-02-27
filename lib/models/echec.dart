class FailureRecord {
  final int id;
  final int patientId;
  final String cause;
  final String actions;
  final DateTime dateRecorded;

  FailureRecord({
    required this.id,
    required this.patientId,
    required this.cause,
    required this.actions,
    required this.dateRecorded,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'cause': cause,
      'actions': actions,
      'dateRecorded': dateRecorded.toIso8601String(),
    };
  }

  factory FailureRecord.fromMap(Map<String, dynamic> map) {
    return FailureRecord(
      id: map['id'],
      patientId: map['patientId'],
      cause: map['cause'],
      actions: map['actions'],
      dateRecorded: DateTime.parse(map['dateRecorded']),
    );
  }
}
