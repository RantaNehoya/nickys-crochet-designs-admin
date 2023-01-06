import 'package:flutter/material.dart';
import 'package:nickys_crochet_designs/presentation/resources/value_manager.dart';

class PaginatedTable extends StatelessWidget {
  final int rows;
  final DataTableSource source;
  final List<String> dataColumns;

  const PaginatedTable({
    Key key,
    @required this.rows,
    @required this.source,
    @required this.dataColumns,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable(
      source: source,
      showFirstLastButtons: true,
      headingRowHeight: SizeManager.s_45,
      rowsPerPage: rows,
      columns: List.generate(dataColumns.length, (index) {
        return DataColumn(
          label: Text(
            dataColumns[index],
          ),
        );
      }),
    );
  }
}
