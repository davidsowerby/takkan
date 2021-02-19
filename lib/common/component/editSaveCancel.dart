import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/page/editState.dart';
import 'package:provider/provider.dart';

class EditSaveCancel extends StatelessWidget {
  final IconData editIcon;

  final IconData cancelIcon;

  final IconData saveIcon;

  final DataSource dataSource;

  const EditSaveCancel({
    Key key,
    this.editIcon = Icons.edit,
    this.cancelIcon = Icons.cancel_outlined,
    this.saveIcon = Icons.save,
    this.dataSource,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editState = Provider.of<EditState>(context);
    bool editMode = editState.editMode;
    if (editMode) {
      final rowKeyString = '${key.toString()}:row';
      final rowKey = Key(rowKeyString);
      final cancelKey = Key('$rowKeyString:cancelButton');
      final saveKey = Key('$rowKeyString:saveButton');
      return Row(
        key: rowKey,
        children: [
          IconButton(
            key: cancelKey,
            icon: Icon(cancelIcon),
            onPressed: () => _onCancel(editState),
          ),
          IconButton(
            key: saveKey,
            icon: Icon(saveIcon),
            onPressed: () => _onSave(editState),
          ),
        ],
      );
    } else {
      final rowKeyString = '${key.toString()}:row';
      final rowKey = Key(rowKeyString);
      final blankKey = Key('$rowKeyString:blankButton');
      final editKey = Key('$rowKeyString:editButton');
      return Row(
        key: rowKey,
        children: [
          Container(
            key: blankKey,
            // TODO: Make this a 'blank' icon as a separate thing, taking size from IconTheme
            width: 24.0,
            height: 24.0,
          ),
          IconButton(
            key: editKey,
            icon: Icon(editIcon),
            onPressed: () => _onEdit(editState),
          ),
        ],
      );
    }
  }

  _onCancel(EditState editState) {
    dataSource.reset();
    editState.readMode = true;
  }

  _onSave(EditState editState) {
    bool isValid = dataSource.validate();
    if (isValid) {
      dataSource.flushFormsToModel();
      dataSource.persist();
      editState.readMode = true;
    }
  }

  _onEdit(EditState editState) {
    editState.readMode = false;
  }
}
