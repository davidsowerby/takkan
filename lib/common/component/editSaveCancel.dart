import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:precept_client/common/component/keyAssist.dart';
import 'package:precept_client/data/dataSource.dart';
import 'package:precept_client/page/editState.dart';
import 'package:precept_script/common/log.dart';
import 'package:provider/provider.dart';

class EditSaveCancel extends StatelessWidget {
  final IconData editIcon;

  final IconData cancelIcon;

  final IconData saveIcon;

  final DataSource dataSource;
  
  final _saveKey='save';
  final _cancelKey='cancel';
  final _rowKey='row';
  final _editKey='edit';
  final _blankKey='blank';


  const EditSaveCancel({
    Key key,
    this.editIcon = Icons.edit,
    this.cancelIcon = Icons.cancel_outlined,
    this.saveIcon = Icons.save,
    this.dataSource,
  }) : super(key: key);


  Key get rowKey => keys(key,[_rowKey]);
  Key get saveKey => keys(key,[_rowKey,_saveKey]);
  Key get editKey => keys(key,[_rowKey,_editKey]);
  Key get cancelKey => keys(key,[_rowKey,_cancelKey]);
  Key get blankKey => keys(key,[_rowKey,_blankKey]);

  @override
  Widget build(BuildContext context) {
    final editState = Provider.of<EditState>(context);
    bool editMode = editState.editMode;
    if (editMode) {
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

  _onSave(EditState editState) async {
    bool isValid = dataSource.validate();
    if (isValid) {
      dataSource.flushFormsToModel();
      await dataSource.persist();
      editState.readMode = true;
      logType(this.runtimeType).d('Save completed by $key');
    }
  }

  _onEdit(EditState editState) {
    editState.readMode = false;
  }
}
