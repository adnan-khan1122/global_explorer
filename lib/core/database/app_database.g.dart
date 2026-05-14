// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $FavoriteCountriesTable extends FavoriteCountries
    with TableInfo<$FavoriteCountriesTable, FavoriteCountry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteCountriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cca3Meta = const VerificationMeta('cca3');
  @override
  late final GeneratedColumn<String> cca3 = GeneratedColumn<String>(
    'cca3',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameCommonMeta = const VerificationMeta(
    'nameCommon',
  );
  @override
  late final GeneratedColumn<String> nameCommon = GeneratedColumn<String>(
    'name_common',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagPngMeta = const VerificationMeta(
    'flagPng',
  );
  @override
  late final GeneratedColumn<String> flagPng = GeneratedColumn<String>(
    'flag_png',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _regionMeta = const VerificationMeta('region');
  @override
  late final GeneratedColumn<String> region = GeneratedColumn<String>(
    'region',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addedAtMeta = const VerificationMeta(
    'addedAt',
  );
  @override
  late final GeneratedColumn<DateTime> addedAt = GeneratedColumn<DateTime>(
    'added_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    cca3,
    nameCommon,
    flagPng,
    region,
    addedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_countries';
  @override
  VerificationContext validateIntegrity(
    Insertable<FavoriteCountry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('cca3')) {
      context.handle(
        _cca3Meta,
        cca3.isAcceptableOrUnknown(data['cca3']!, _cca3Meta),
      );
    } else if (isInserting) {
      context.missing(_cca3Meta);
    }
    if (data.containsKey('name_common')) {
      context.handle(
        _nameCommonMeta,
        nameCommon.isAcceptableOrUnknown(data['name_common']!, _nameCommonMeta),
      );
    } else if (isInserting) {
      context.missing(_nameCommonMeta);
    }
    if (data.containsKey('flag_png')) {
      context.handle(
        _flagPngMeta,
        flagPng.isAcceptableOrUnknown(data['flag_png']!, _flagPngMeta),
      );
    }
    if (data.containsKey('region')) {
      context.handle(
        _regionMeta,
        region.isAcceptableOrUnknown(data['region']!, _regionMeta),
      );
    }
    if (data.containsKey('added_at')) {
      context.handle(
        _addedAtMeta,
        addedAt.isAcceptableOrUnknown(data['added_at']!, _addedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cca3};
  @override
  FavoriteCountry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FavoriteCountry(
      cca3: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cca3'],
      )!,
      nameCommon: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_common'],
      )!,
      flagPng: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}flag_png'],
      ),
      region: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}region'],
      ),
      addedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}added_at'],
      )!,
    );
  }

  @override
  $FavoriteCountriesTable createAlias(String alias) {
    return $FavoriteCountriesTable(attachedDatabase, alias);
  }
}

class FavoriteCountry extends DataClass implements Insertable<FavoriteCountry> {
  final String cca3;
  final String nameCommon;
  final String? flagPng;
  final String? region;
  final DateTime addedAt;
  const FavoriteCountry({
    required this.cca3,
    required this.nameCommon,
    this.flagPng,
    this.region,
    required this.addedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['cca3'] = Variable<String>(cca3);
    map['name_common'] = Variable<String>(nameCommon);
    if (!nullToAbsent || flagPng != null) {
      map['flag_png'] = Variable<String>(flagPng);
    }
    if (!nullToAbsent || region != null) {
      map['region'] = Variable<String>(region);
    }
    map['added_at'] = Variable<DateTime>(addedAt);
    return map;
  }

  FavoriteCountriesCompanion toCompanion(bool nullToAbsent) {
    return FavoriteCountriesCompanion(
      cca3: Value(cca3),
      nameCommon: Value(nameCommon),
      flagPng: flagPng == null && nullToAbsent
          ? const Value.absent()
          : Value(flagPng),
      region: region == null && nullToAbsent
          ? const Value.absent()
          : Value(region),
      addedAt: Value(addedAt),
    );
  }

  factory FavoriteCountry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FavoriteCountry(
      cca3: serializer.fromJson<String>(json['cca3']),
      nameCommon: serializer.fromJson<String>(json['nameCommon']),
      flagPng: serializer.fromJson<String?>(json['flagPng']),
      region: serializer.fromJson<String?>(json['region']),
      addedAt: serializer.fromJson<DateTime>(json['addedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cca3': serializer.toJson<String>(cca3),
      'nameCommon': serializer.toJson<String>(nameCommon),
      'flagPng': serializer.toJson<String?>(flagPng),
      'region': serializer.toJson<String?>(region),
      'addedAt': serializer.toJson<DateTime>(addedAt),
    };
  }

  FavoriteCountry copyWith({
    String? cca3,
    String? nameCommon,
    Value<String?> flagPng = const Value.absent(),
    Value<String?> region = const Value.absent(),
    DateTime? addedAt,
  }) => FavoriteCountry(
    cca3: cca3 ?? this.cca3,
    nameCommon: nameCommon ?? this.nameCommon,
    flagPng: flagPng.present ? flagPng.value : this.flagPng,
    region: region.present ? region.value : this.region,
    addedAt: addedAt ?? this.addedAt,
  );
  FavoriteCountry copyWithCompanion(FavoriteCountriesCompanion data) {
    return FavoriteCountry(
      cca3: data.cca3.present ? data.cca3.value : this.cca3,
      nameCommon: data.nameCommon.present
          ? data.nameCommon.value
          : this.nameCommon,
      flagPng: data.flagPng.present ? data.flagPng.value : this.flagPng,
      region: data.region.present ? data.region.value : this.region,
      addedAt: data.addedAt.present ? data.addedAt.value : this.addedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteCountry(')
          ..write('cca3: $cca3, ')
          ..write('nameCommon: $nameCommon, ')
          ..write('flagPng: $flagPng, ')
          ..write('region: $region, ')
          ..write('addedAt: $addedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(cca3, nameCommon, flagPng, region, addedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FavoriteCountry &&
          other.cca3 == this.cca3 &&
          other.nameCommon == this.nameCommon &&
          other.flagPng == this.flagPng &&
          other.region == this.region &&
          other.addedAt == this.addedAt);
}

class FavoriteCountriesCompanion extends UpdateCompanion<FavoriteCountry> {
  final Value<String> cca3;
  final Value<String> nameCommon;
  final Value<String?> flagPng;
  final Value<String?> region;
  final Value<DateTime> addedAt;
  final Value<int> rowid;
  const FavoriteCountriesCompanion({
    this.cca3 = const Value.absent(),
    this.nameCommon = const Value.absent(),
    this.flagPng = const Value.absent(),
    this.region = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FavoriteCountriesCompanion.insert({
    required String cca3,
    required String nameCommon,
    this.flagPng = const Value.absent(),
    this.region = const Value.absent(),
    this.addedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cca3 = Value(cca3),
       nameCommon = Value(nameCommon);
  static Insertable<FavoriteCountry> custom({
    Expression<String>? cca3,
    Expression<String>? nameCommon,
    Expression<String>? flagPng,
    Expression<String>? region,
    Expression<DateTime>? addedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cca3 != null) 'cca3': cca3,
      if (nameCommon != null) 'name_common': nameCommon,
      if (flagPng != null) 'flag_png': flagPng,
      if (region != null) 'region': region,
      if (addedAt != null) 'added_at': addedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FavoriteCountriesCompanion copyWith({
    Value<String>? cca3,
    Value<String>? nameCommon,
    Value<String?>? flagPng,
    Value<String?>? region,
    Value<DateTime>? addedAt,
    Value<int>? rowid,
  }) {
    return FavoriteCountriesCompanion(
      cca3: cca3 ?? this.cca3,
      nameCommon: nameCommon ?? this.nameCommon,
      flagPng: flagPng ?? this.flagPng,
      region: region ?? this.region,
      addedAt: addedAt ?? this.addedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cca3.present) {
      map['cca3'] = Variable<String>(cca3.value);
    }
    if (nameCommon.present) {
      map['name_common'] = Variable<String>(nameCommon.value);
    }
    if (flagPng.present) {
      map['flag_png'] = Variable<String>(flagPng.value);
    }
    if (region.present) {
      map['region'] = Variable<String>(region.value);
    }
    if (addedAt.present) {
      map['added_at'] = Variable<DateTime>(addedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteCountriesCompanion(')
          ..write('cca3: $cca3, ')
          ..write('nameCommon: $nameCommon, ')
          ..write('flagPng: $flagPng, ')
          ..write('region: $region, ')
          ..write('addedAt: $addedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $FavoriteCountriesTable favoriteCountries =
      $FavoriteCountriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [favoriteCountries];
}

typedef $$FavoriteCountriesTableCreateCompanionBuilder =
    FavoriteCountriesCompanion Function({
      required String cca3,
      required String nameCommon,
      Value<String?> flagPng,
      Value<String?> region,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });
typedef $$FavoriteCountriesTableUpdateCompanionBuilder =
    FavoriteCountriesCompanion Function({
      Value<String> cca3,
      Value<String> nameCommon,
      Value<String?> flagPng,
      Value<String?> region,
      Value<DateTime> addedAt,
      Value<int> rowid,
    });

class $$FavoriteCountriesTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteCountriesTable> {
  $$FavoriteCountriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get cca3 => $composableBuilder(
    column: $table.cca3,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameCommon => $composableBuilder(
    column: $table.nameCommon,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flagPng => $composableBuilder(
    column: $table.flagPng,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FavoriteCountriesTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteCountriesTable> {
  $$FavoriteCountriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get cca3 => $composableBuilder(
    column: $table.cca3,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameCommon => $composableBuilder(
    column: $table.nameCommon,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flagPng => $composableBuilder(
    column: $table.flagPng,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get region => $composableBuilder(
    column: $table.region,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get addedAt => $composableBuilder(
    column: $table.addedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FavoriteCountriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteCountriesTable> {
  $$FavoriteCountriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get cca3 =>
      $composableBuilder(column: $table.cca3, builder: (column) => column);

  GeneratedColumn<String> get nameCommon => $composableBuilder(
    column: $table.nameCommon,
    builder: (column) => column,
  );

  GeneratedColumn<String> get flagPng =>
      $composableBuilder(column: $table.flagPng, builder: (column) => column);

  GeneratedColumn<String> get region =>
      $composableBuilder(column: $table.region, builder: (column) => column);

  GeneratedColumn<DateTime> get addedAt =>
      $composableBuilder(column: $table.addedAt, builder: (column) => column);
}

class $$FavoriteCountriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FavoriteCountriesTable,
          FavoriteCountry,
          $$FavoriteCountriesTableFilterComposer,
          $$FavoriteCountriesTableOrderingComposer,
          $$FavoriteCountriesTableAnnotationComposer,
          $$FavoriteCountriesTableCreateCompanionBuilder,
          $$FavoriteCountriesTableUpdateCompanionBuilder,
          (
            FavoriteCountry,
            BaseReferences<
              _$AppDatabase,
              $FavoriteCountriesTable,
              FavoriteCountry
            >,
          ),
          FavoriteCountry,
          PrefetchHooks Function()
        > {
  $$FavoriteCountriesTableTableManager(
    _$AppDatabase db,
    $FavoriteCountriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteCountriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteCountriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteCountriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> cca3 = const Value.absent(),
                Value<String> nameCommon = const Value.absent(),
                Value<String?> flagPng = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteCountriesCompanion(
                cca3: cca3,
                nameCommon: nameCommon,
                flagPng: flagPng,
                region: region,
                addedAt: addedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cca3,
                required String nameCommon,
                Value<String?> flagPng = const Value.absent(),
                Value<String?> region = const Value.absent(),
                Value<DateTime> addedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FavoriteCountriesCompanion.insert(
                cca3: cca3,
                nameCommon: nameCommon,
                flagPng: flagPng,
                region: region,
                addedAt: addedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FavoriteCountriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FavoriteCountriesTable,
      FavoriteCountry,
      $$FavoriteCountriesTableFilterComposer,
      $$FavoriteCountriesTableOrderingComposer,
      $$FavoriteCountriesTableAnnotationComposer,
      $$FavoriteCountriesTableCreateCompanionBuilder,
      $$FavoriteCountriesTableUpdateCompanionBuilder,
      (
        FavoriteCountry,
        BaseReferences<_$AppDatabase, $FavoriteCountriesTable, FavoriteCountry>,
      ),
      FavoriteCountry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$FavoriteCountriesTableTableManager get favoriteCountries =>
      $$FavoriteCountriesTableTableManager(_db, _db.favoriteCountries);
}
