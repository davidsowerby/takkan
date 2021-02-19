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

  EditSaveCancel({
    this.editIcon = Icons.edit,
    this.cancelIcon = Icons.cancel_outlined,
    this.saveIcon = Icons.save,
    this.dataSource,
  });

  @override
  Widget build(BuildContext context) {
    final editState = Provider.of<EditState>(context);
    bool editMode=editState.editMode;
    if (editMode) {
      return Row(
        children: [
          IconButton(icon: Icon(cancelIcon), onPressed: ()=>_onCancel(editState)),
          IconButton(icon: Icon(saveIcon), onPressed: ()=>_onSave(editState)),
        ],
      );
    } else {
      return Row(
        children: [
          Container(
            // TODO: Make this a 'blank' icon as a separate thing, taking size from IconTheme
            width: 24.0,
            height: 24.0,
          ),
          IconButton(icon: Icon(editIcon), onPressed:()=> _onEdit(editState)),
        ],
      );
    }
  }

  _onCancel(EditState editState) {
    dataSource.reset();
    editState.readMode=true;
  }

  _onSave(EditState editState) {
    bool isValid = dataSource.validate();
    if (isValid) {
      dataSource.flushFormsToModel();
      dataSource.persist();
      editState.readMode=true;
    }
  }

  _onEdit(EditState editState) {
    editState.readMode=false;
  }
}
