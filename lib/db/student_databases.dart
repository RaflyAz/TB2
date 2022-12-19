import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crud_flutter/model/student.dart';

class StudentDatabase {
  static final StudentDatabase instance = StudentDatabase._init();

  static Database? _database;

  StudentDatabase._init();

  Future <Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('student_db.db');
    return _database!;
  }

  Future <Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB (Database db, int version) async {
    await db.execute('''
      CREATE TABLE $studentTable (
        ${StudentFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${StudentFields.name} TEXT NOT NULL,
        ${StudentFields.nim} TEXT NOT NULL UNIQUE,
        ${StudentFields.phone} TEXT,
        ${StudentFields.email} TEXT
      )

    ''');
  }

  Future <Student> create(Student student) async {
    final db = await instance.database;

    final id = await db.insert(studentTable, student.toJson());
    return student.copy(id: id);
  }

  Future <Student> readStudent(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      studentTable,
      columns: StudentFields.values,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Student.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future <List<Student>> readAllStudents() async {
    final db = await instance.database;
    final orderBy = '${StudentFields.name} ASC';
    final result = await db.query(studentTable, orderBy: orderBy);

    return result.map((json) => Student.fromJson(json)).toList();

  }

  Future <int> update(Student student) async {
    final db = await instance.database;

    return db.update(
      studentTable,
      student.toJson(),
      where: '${StudentFields.id} = ?',
      whereArgs: [student.id]);
  }

  Future <int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      studentTable,
      where: '${StudentFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }

}