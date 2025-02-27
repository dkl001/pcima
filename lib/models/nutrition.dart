// class NutritionCase {
//   final int id;
//   final String patientName;
//   final int ageMonths;
//   final double muac;
//   final double weight;
//   final double height;
//   final bool hasEdema;
//   final String edemaSeverity;
//   final String admissionType;
//   final String status;
//   final DateTime admissionDate;
//   final bool isVaccinated;
//   final bool hasFailedTreatment;  // Échec de traitement
//   final String failureCause;      // Cause de l'échec
//   final bool isReferred;          // Référé à un autre établissement
//   final bool isTransferred;       // Transfert interne
//   final bool isDischarged;        // Patient sorti
//   final bool isDeceased;          // Patient décédé
//   final bool isAbandoned;         // Abandon

//   NutritionCase({
//     required this.id,
//     required this.patientName,
//     required this.ageMonths,
//     required this.muac,
//     required this.weight,
//     required this.height,
//     required this.hasEdema,
//     required this.edemaSeverity,
//     required this.admissionType,
//     required this.status,
//     required this.admissionDate,
//     required this.isVaccinated,
//     this.hasFailedTreatment = false,
//     this.failureCause = '',
//     this.isReferred = false,
//     this.isTransferred = false,
//     this.isDeceased = false,
//     this.isAbandoned = false,
//     this.isDischarged = false,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'patientName': patientName,
//       'ageMonths': ageMonths,
//       'muac': muac,
//       'weight': weight,
//       'height': height,
//       'hasEdema': hasEdema ? 1 : 0,
//       'edemaSeverity': edemaSeverity,
//       'admissionType': admissionType,
//       'status': status,
//       'admissionDate': admissionDate.toIso8601String(),
//       'isVaccinated': isVaccinated ? 1 : 0,
//       'hasFailedTreatment': hasFailedTreatment ? 1 : 0,
//       'failureCause': failureCause,
//       'isReferred': isReferred ? 1 : 0,
//       'isTransferred': isTransferred ? 1 : 0,
//       'isDeceased': isDeceased ? 1 : 0,
//       'isAbandoned': isAbandoned ? 1 : 0,
//       'isDischarged': isDischarged ? 1 : 0,
//     };
//   }

//   factory NutritionCase.fromMap(Map<String, dynamic> map) {
//     return NutritionCase(
//       id: map['id'],
//       patientName: map['patientName'],
//       ageMonths: map['ageMonths'],
//       muac: map['muac'],
//       weight: map['weight'],
//       height: map['height'],
//       hasEdema: map['hasEdema'] == 1,
//       edemaSeverity: map['edemaSeverity'],
//       admissionType: map['admissionType'],
//       status: map['status'],
//       admissionDate: DateTime.parse(map['admissionDate']),
//       isVaccinated: map['isVaccinated'] == 1,
//       hasFailedTreatment: map['hasFailedTreatment'] == 1,
//       failureCause: map['failureCause'],
//       isReferred: map['isReferred'] == 1,
//       isTransferred: map['isTransferred'] == 1,
//       isDeceased: map['isDeceased'] == 1,
//       isAbandoned: map['isAbandoned'] == 1,
//       isDischarged: map['isDischarged'] == 1,
//     );
//   }
// }
