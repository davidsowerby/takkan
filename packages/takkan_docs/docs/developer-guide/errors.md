# Common Errors

## Flutter
 
### Timers in testWidget

Message: 'A Timer is still pending even after the widget tree was disposed.'

#### Fix:

``` dart
await tester.pumpWidget(widgetTree);
await tester.pumpAndSettle(const Duration(seconds: 1));
```