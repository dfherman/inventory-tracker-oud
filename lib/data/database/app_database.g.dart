// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProductsTable extends Products
    with TableInfo<$ProductsTable, ProductRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _naamMeta = const VerificationMeta('naam');
  @override
  late final GeneratedColumn<String> naam = GeneratedColumn<String>(
    'naam',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _houdbaarTotMeta = const VerificationMeta(
    'houdbaarTot',
  );
  @override
  late final GeneratedColumn<DateTime> houdbaarTot = GeneratedColumn<DateTime>(
    'houdbaar_tot',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _aantalMeta = const VerificationMeta('aantal');
  @override
  late final GeneratedColumn<int> aantal = GeneratedColumn<int>(
    'aantal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _notitieMeta = const VerificationMeta(
    'notitie',
  );
  @override
  late final GeneratedColumn<String> notitie = GeneratedColumn<String>(
    'notitie',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toegevoegdOpMeta = const VerificationMeta(
    'toegevoegdOp',
  );
  @override
  late final GeneratedColumn<DateTime> toegevoegdOp = GeneratedColumn<DateTime>(
    'toegevoegd_op',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    naam,
    houdbaarTot,
    aantal,
    notitie,
    toegevoegdOp,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'products';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('naam')) {
      context.handle(
        _naamMeta,
        naam.isAcceptableOrUnknown(data['naam']!, _naamMeta),
      );
    } else if (isInserting) {
      context.missing(_naamMeta);
    }
    if (data.containsKey('houdbaar_tot')) {
      context.handle(
        _houdbaarTotMeta,
        houdbaarTot.isAcceptableOrUnknown(
          data['houdbaar_tot']!,
          _houdbaarTotMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_houdbaarTotMeta);
    }
    if (data.containsKey('aantal')) {
      context.handle(
        _aantalMeta,
        aantal.isAcceptableOrUnknown(data['aantal']!, _aantalMeta),
      );
    }
    if (data.containsKey('notitie')) {
      context.handle(
        _notitieMeta,
        notitie.isAcceptableOrUnknown(data['notitie']!, _notitieMeta),
      );
    }
    if (data.containsKey('toegevoegd_op')) {
      context.handle(
        _toegevoegdOpMeta,
        toegevoegdOp.isAcceptableOrUnknown(
          data['toegevoegd_op']!,
          _toegevoegdOpMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      naam: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}naam'],
      )!,
      houdbaarTot: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}houdbaar_tot'],
      )!,
      aantal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}aantal'],
      )!,
      notitie: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notitie'],
      ),
      toegevoegdOp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}toegevoegd_op'],
      )!,
    );
  }

  @override
  $ProductsTable createAlias(String alias) {
    return $ProductsTable(attachedDatabase, alias);
  }
}

class ProductRow extends DataClass implements Insertable<ProductRow> {
  /// Automatisch oplopende primaire sleutel.
  final int id;

  /// Naam van het product (verplicht, 1–100 tekens).
  final String naam;

  /// Houdbaarheidsdatum.
  final DateTime houdbaarTot;

  /// Aantal stuks; standaard 1.
  final int aantal;

  /// Optionele notitie.
  final String? notitie;

  /// Tijdstip van toevoegen; standaard "nu".
  final DateTime toegevoegdOp;
  const ProductRow({
    required this.id,
    required this.naam,
    required this.houdbaarTot,
    required this.aantal,
    this.notitie,
    required this.toegevoegdOp,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['naam'] = Variable<String>(naam);
    map['houdbaar_tot'] = Variable<DateTime>(houdbaarTot);
    map['aantal'] = Variable<int>(aantal);
    if (!nullToAbsent || notitie != null) {
      map['notitie'] = Variable<String>(notitie);
    }
    map['toegevoegd_op'] = Variable<DateTime>(toegevoegdOp);
    return map;
  }

  ProductsCompanion toCompanion(bool nullToAbsent) {
    return ProductsCompanion(
      id: Value(id),
      naam: Value(naam),
      houdbaarTot: Value(houdbaarTot),
      aantal: Value(aantal),
      notitie: notitie == null && nullToAbsent
          ? const Value.absent()
          : Value(notitie),
      toegevoegdOp: Value(toegevoegdOp),
    );
  }

  factory ProductRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductRow(
      id: serializer.fromJson<int>(json['id']),
      naam: serializer.fromJson<String>(json['naam']),
      houdbaarTot: serializer.fromJson<DateTime>(json['houdbaarTot']),
      aantal: serializer.fromJson<int>(json['aantal']),
      notitie: serializer.fromJson<String?>(json['notitie']),
      toegevoegdOp: serializer.fromJson<DateTime>(json['toegevoegdOp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'naam': serializer.toJson<String>(naam),
      'houdbaarTot': serializer.toJson<DateTime>(houdbaarTot),
      'aantal': serializer.toJson<int>(aantal),
      'notitie': serializer.toJson<String?>(notitie),
      'toegevoegdOp': serializer.toJson<DateTime>(toegevoegdOp),
    };
  }

  ProductRow copyWith({
    int? id,
    String? naam,
    DateTime? houdbaarTot,
    int? aantal,
    Value<String?> notitie = const Value.absent(),
    DateTime? toegevoegdOp,
  }) => ProductRow(
    id: id ?? this.id,
    naam: naam ?? this.naam,
    houdbaarTot: houdbaarTot ?? this.houdbaarTot,
    aantal: aantal ?? this.aantal,
    notitie: notitie.present ? notitie.value : this.notitie,
    toegevoegdOp: toegevoegdOp ?? this.toegevoegdOp,
  );
  ProductRow copyWithCompanion(ProductsCompanion data) {
    return ProductRow(
      id: data.id.present ? data.id.value : this.id,
      naam: data.naam.present ? data.naam.value : this.naam,
      houdbaarTot: data.houdbaarTot.present
          ? data.houdbaarTot.value
          : this.houdbaarTot,
      aantal: data.aantal.present ? data.aantal.value : this.aantal,
      notitie: data.notitie.present ? data.notitie.value : this.notitie,
      toegevoegdOp: data.toegevoegdOp.present
          ? data.toegevoegdOp.value
          : this.toegevoegdOp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductRow(')
          ..write('id: $id, ')
          ..write('naam: $naam, ')
          ..write('houdbaarTot: $houdbaarTot, ')
          ..write('aantal: $aantal, ')
          ..write('notitie: $notitie, ')
          ..write('toegevoegdOp: $toegevoegdOp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, naam, houdbaarTot, aantal, notitie, toegevoegdOp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductRow &&
          other.id == this.id &&
          other.naam == this.naam &&
          other.houdbaarTot == this.houdbaarTot &&
          other.aantal == this.aantal &&
          other.notitie == this.notitie &&
          other.toegevoegdOp == this.toegevoegdOp);
}

class ProductsCompanion extends UpdateCompanion<ProductRow> {
  final Value<int> id;
  final Value<String> naam;
  final Value<DateTime> houdbaarTot;
  final Value<int> aantal;
  final Value<String?> notitie;
  final Value<DateTime> toegevoegdOp;
  const ProductsCompanion({
    this.id = const Value.absent(),
    this.naam = const Value.absent(),
    this.houdbaarTot = const Value.absent(),
    this.aantal = const Value.absent(),
    this.notitie = const Value.absent(),
    this.toegevoegdOp = const Value.absent(),
  });
  ProductsCompanion.insert({
    this.id = const Value.absent(),
    required String naam,
    required DateTime houdbaarTot,
    this.aantal = const Value.absent(),
    this.notitie = const Value.absent(),
    this.toegevoegdOp = const Value.absent(),
  }) : naam = Value(naam),
       houdbaarTot = Value(houdbaarTot);
  static Insertable<ProductRow> custom({
    Expression<int>? id,
    Expression<String>? naam,
    Expression<DateTime>? houdbaarTot,
    Expression<int>? aantal,
    Expression<String>? notitie,
    Expression<DateTime>? toegevoegdOp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (naam != null) 'naam': naam,
      if (houdbaarTot != null) 'houdbaar_tot': houdbaarTot,
      if (aantal != null) 'aantal': aantal,
      if (notitie != null) 'notitie': notitie,
      if (toegevoegdOp != null) 'toegevoegd_op': toegevoegdOp,
    });
  }

  ProductsCompanion copyWith({
    Value<int>? id,
    Value<String>? naam,
    Value<DateTime>? houdbaarTot,
    Value<int>? aantal,
    Value<String?>? notitie,
    Value<DateTime>? toegevoegdOp,
  }) {
    return ProductsCompanion(
      id: id ?? this.id,
      naam: naam ?? this.naam,
      houdbaarTot: houdbaarTot ?? this.houdbaarTot,
      aantal: aantal ?? this.aantal,
      notitie: notitie ?? this.notitie,
      toegevoegdOp: toegevoegdOp ?? this.toegevoegdOp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (naam.present) {
      map['naam'] = Variable<String>(naam.value);
    }
    if (houdbaarTot.present) {
      map['houdbaar_tot'] = Variable<DateTime>(houdbaarTot.value);
    }
    if (aantal.present) {
      map['aantal'] = Variable<int>(aantal.value);
    }
    if (notitie.present) {
      map['notitie'] = Variable<String>(notitie.value);
    }
    if (toegevoegdOp.present) {
      map['toegevoegd_op'] = Variable<DateTime>(toegevoegdOp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductsCompanion(')
          ..write('id: $id, ')
          ..write('naam: $naam, ')
          ..write('houdbaarTot: $houdbaarTot, ')
          ..write('aantal: $aantal, ')
          ..write('notitie: $notitie, ')
          ..write('toegevoegdOp: $toegevoegdOp')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProductsTable products = $ProductsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [products];
}

typedef $$ProductsTableCreateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      required String naam,
      required DateTime houdbaarTot,
      Value<int> aantal,
      Value<String?> notitie,
      Value<DateTime> toegevoegdOp,
    });
typedef $$ProductsTableUpdateCompanionBuilder =
    ProductsCompanion Function({
      Value<int> id,
      Value<String> naam,
      Value<DateTime> houdbaarTot,
      Value<int> aantal,
      Value<String?> notitie,
      Value<DateTime> toegevoegdOp,
    });

class $$ProductsTableFilterComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get naam => $composableBuilder(
    column: $table.naam,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get houdbaarTot => $composableBuilder(
    column: $table.houdbaarTot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get aantal => $composableBuilder(
    column: $table.aantal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notitie => $composableBuilder(
    column: $table.notitie,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get toegevoegdOp => $composableBuilder(
    column: $table.toegevoegdOp,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get naam => $composableBuilder(
    column: $table.naam,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get houdbaarTot => $composableBuilder(
    column: $table.houdbaarTot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get aantal => $composableBuilder(
    column: $table.aantal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notitie => $composableBuilder(
    column: $table.notitie,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get toegevoegdOp => $composableBuilder(
    column: $table.toegevoegdOp,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductsTable> {
  $$ProductsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get naam =>
      $composableBuilder(column: $table.naam, builder: (column) => column);

  GeneratedColumn<DateTime> get houdbaarTot => $composableBuilder(
    column: $table.houdbaarTot,
    builder: (column) => column,
  );

  GeneratedColumn<int> get aantal =>
      $composableBuilder(column: $table.aantal, builder: (column) => column);

  GeneratedColumn<String> get notitie =>
      $composableBuilder(column: $table.notitie, builder: (column) => column);

  GeneratedColumn<DateTime> get toegevoegdOp => $composableBuilder(
    column: $table.toegevoegdOp,
    builder: (column) => column,
  );
}

class $$ProductsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductsTable,
          ProductRow,
          $$ProductsTableFilterComposer,
          $$ProductsTableOrderingComposer,
          $$ProductsTableAnnotationComposer,
          $$ProductsTableCreateCompanionBuilder,
          $$ProductsTableUpdateCompanionBuilder,
          (
            ProductRow,
            BaseReferences<_$AppDatabase, $ProductsTable, ProductRow>,
          ),
          ProductRow,
          PrefetchHooks Function()
        > {
  $$ProductsTableTableManager(_$AppDatabase db, $ProductsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> naam = const Value.absent(),
                Value<DateTime> houdbaarTot = const Value.absent(),
                Value<int> aantal = const Value.absent(),
                Value<String?> notitie = const Value.absent(),
                Value<DateTime> toegevoegdOp = const Value.absent(),
              }) => ProductsCompanion(
                id: id,
                naam: naam,
                houdbaarTot: houdbaarTot,
                aantal: aantal,
                notitie: notitie,
                toegevoegdOp: toegevoegdOp,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String naam,
                required DateTime houdbaarTot,
                Value<int> aantal = const Value.absent(),
                Value<String?> notitie = const Value.absent(),
                Value<DateTime> toegevoegdOp = const Value.absent(),
              }) => ProductsCompanion.insert(
                id: id,
                naam: naam,
                houdbaarTot: houdbaarTot,
                aantal: aantal,
                notitie: notitie,
                toegevoegdOp: toegevoegdOp,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductsTable,
      ProductRow,
      $$ProductsTableFilterComposer,
      $$ProductsTableOrderingComposer,
      $$ProductsTableAnnotationComposer,
      $$ProductsTableCreateCompanionBuilder,
      $$ProductsTableUpdateCompanionBuilder,
      (ProductRow, BaseReferences<_$AppDatabase, $ProductsTable, ProductRow>),
      ProductRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProductsTableTableManager get products =>
      $$ProductsTableTableManager(_db, _db.products);
}
