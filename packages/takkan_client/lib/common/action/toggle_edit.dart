import 'package:flutter/widgets.dart';
import 'package:takkan_client/pod/page/edit_state.dart';
import 'package:provider/provider.dart';

/// Changes the state of the nearest [SectionEditState]
mixin ToggleSectionEditState {
  /// Changes the state of the nearest [sectionEditState]
  /// In theory we could just call this with BuildContext, but if we did that we would not be listening for changes
  /// in the calling build() method
  toggleEditState(BuildContext context) {
    final EditState sectionEditState =
        Provider.of<EditState>(context, listen: false);
    // final DocumentModelShared documentEditState = Provider.of<DocumentModelShared>(context, listen: false);

    if (sectionEditState.readMode) {
      sectionEditState.readMode = false;
    } else {
      sectionEditState.readMode = true;
    }

    /// Let the DocumentEditState know, in case other actions required
    // documentEditState.sectionEditStateChanged(sectionEditState.readMode);
  }
}
