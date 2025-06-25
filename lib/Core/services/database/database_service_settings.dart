class DatabaseServiceSettings {
  static const int version = 1;
  static const List<SqlTable> tables = [

  ];
}

class SqlTable {
  final String name;
  final String sql;

  const SqlTable({required this.name, required this.sql});
}
