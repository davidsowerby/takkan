// /// Updates the [dataProvider] with the current [_mutableDocument], effectively
// /// saving the document.
// ///
// /// Some providers have different API calls for a new vs an updated document, and the
// /// [DataProvider] interface reflects that.
// ///
// /// if the id field in [_mutableDocument] it is assumed to be a brand new document.
// ///
// /// The property name for the id field is identified by [dataProvider.objectIdKey], as it
// /// may vary from one provider to another
// Future<UpdateResult> updateRemote() async {
//   final keyFieldValue = mutableDocument.output[dataProvider.objectIdKey];
//   UpdateResult result;
//   if (keyFieldValue == null) {
//     result = await dataProvider.createDocument(
//         documentClass: documentSchema.name, data: mutableDocument.output);
//     mutableDocument[dataProvider.objectIdKey] = result.objectId;
//     // _cache[result.objectId] = Map.from(mutableDocument.output);
//     mutableDocument.saved();
//     return result;
//   } else {
//     result = await dataProvider.updateDocument(
//       documentId: DocumentId(
//         documentClass: documentSchema.name,
//         objectId: keyFieldValue,
//       ),
//       data: mutableDocument.output,
//     );
//     mutableDocument.saved();
//     return result;
//   }
// }

// /// Resets the [temporaryDocument] to prepare for a new document.
// ///
// /// If [discardChanges] is false, request confirmation from user before discarding
// /// unsaved changes in [temporaryDocument].
// ///
// /// If [discardChanges] is true, any unsaved changes in [temporaryDocument]
// /// will be discarded without confirmation from user
// ///
// /// [initialData] can be used to preset the data of the new document
// Future<bool> createDocument(
//     {Map<String, dynamic> initialData = const {},
//       bool discardChanges = false}) async {
//   if (!(await _canDiscardChanges(discardChanges))) {
//     return false;
//   }
//   return true;
// }

// /// First, check for unsaved changes
// ///
// /// Gets the document either from cache or remote, and makes it the currently
// /// active document by placing in [temporaryDocument].
// ///
// /// Returns true if successful
// ///
// /// Could do a better job of background loading, see open issue:
// /// https://gitlab.com/takkan_/takkan_client/-/issues/109
// Future<bool> readDocument({required String objectId}) async {
//   if (!(await _canDiscardChanges(false))) {
//     return false;
//   }
//   if (cacheContains(objectId)) {
//     return await createDocument(
//       initialData: _cache[objectId]!,
//       discardChanges: true,
//     );
//   }
//   final readResult = await dataProvider.readDocument(
//       documentId:
//       DocumentId(documentClass: documentSchema.name, objectId: objectId));
//   if (readResult.success) {
//     _cache[objectId] = readResult.data;
//     return await createDocument(
//         initialData: _cache[objectId]!, discardChanges: true);
//   }
//   return false;
// }

// Future<bool> _canDiscardChanges(bool discardChanges) async {
//   if (discardChanges) {
//     return true;
//   } else {
//     final responseRetriever = inject<UserDiscardChangesPrompt>();
//     final response = await responseRetriever.getResponse();
//     if (!response) {
//       _userDiscardCancelled();
//     }
//     return response;
//   }
// }
// void _userDiscardCancelled() {}
/// Prompt the user to either accept or reject discard of changes
///
/// Injectable interface for testing
// abstract class UserDiscardChangesPrompt {
//   /// Returns true if the user approves discard of changes
//   Future<bool> getResponse();
// }
//
// class DefaultUserDiscardChangesPrompt implements UserDiscardChangesPrompt {
//   @override
//   Future<bool> getResponse() {
//     // TODO: implement getResponse
//     throw UnimplementedError();
//   }
// }
//
// /// Prompt the user to either accept or reject deletion
// ///
// /// Injectable interface for testing
// abstract class UserDeleteDocumentPrompt {
//   /// Returns true if the user approves discard of changes
//   Future<bool> getResponse();
// }
//
// class DefaultUserDeleteDocumentPrompt implements UserDeleteDocumentPrompt {
//   @override
//   Future<bool> getResponse() {
//     // TODO: implement getResponse
//     throw UnimplementedError();
//   }
// }

// Future<bool> deleteDocument({required String objectId}) async {
//   final responseRetriever = inject<UserDeleteDocumentPrompt>();
//   final response = await responseRetriever.getResponse();
//   if (response) {
//     final result = await dataProvider.deleteDocument(
//       documentId: DocumentId(
//         documentClass: documentSchema.name,
//         objectId: objectId,
//       ),
//     );
//     if (result.success) {
//       _cache.remove(objectId);
//       return true;
//     } else {
//       return false;
//     }
//   }
//   return false;
// }
