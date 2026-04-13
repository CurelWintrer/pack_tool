用于打包和解包二进制通讯协议



栗子：

```dart
class AirControl {
  final int header;
  final int msgType;
  final int deviceId;
  final int cmd;
  final int power;
  final double temp;

  AirControl({
    required this.header,
    required this.msgType,
    required this.deviceId,
    required this.cmd,
    required this.power,
    required this.temp,
  });

  static const List<PackType> types = [
        .uint8,.uint8,.uint8,.uint8,.uint8,.float32,
  ];

  Uint8List toBytes() {
    return pack([header,msgType,deviceId,cmd,power,temp], types);
  }
}
```

