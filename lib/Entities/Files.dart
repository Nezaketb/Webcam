import 'package:realm/realm.dart';

part 'Files.g.dart';

@RealmModel()
class _Files {
  @PrimaryKey()
  late final String FileId;
  late String? Photo;
  late String? Extension;
  late String? MimeType;
}