import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

Uuid uuid = Uuid();

@immutable
class Todo {
  late final String id;
  final String desc;
  final bool isCompleted;
  Todo({
    String? id,
    required this.desc,
    this.isCompleted = false,
  }) {
    this.id = id ?? uuid.v4();
  }

  Todo copyWith({String? id, String? desc, bool? isCompleted}) {
    return Todo(
        id: id ?? this.id,
        desc: desc ?? this.desc,
        isCompleted: isCompleted ?? this.isCompleted);
  }
}
