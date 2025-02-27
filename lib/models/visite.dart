import 'package:flutter/material.dart';

class Visite {
  String id;
  String enfantId;
  DateTime date;
  String status; // "Réalisée", "À venir", "Manquée"
  String type;
  String idDepistage;
  String idType;

  Visite({
    required this.id,
    required this.enfantId,
    required this.date,
    required this.status,
    required this.type,
    required this.idDepistage,
    required this.idType,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'enfant_id': enfantId,
        'date': date.toIso8601String(),
        'status': status,
        'idDepistage': idDepistage,
        'type' : type,
        'idType': idType,
      };

  factory Visite.fromJson(Map<String, dynamic> json) => Visite(
        id: json['id'],
        enfantId: json['enfant_id'],
        date: DateTime.parse(json['date']),
        status: json['status'],
        idDepistage: json['idDepistage'],
        type: json['type'],
        idType: json['idType'],

      );
}
