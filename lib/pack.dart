import 'dart:typed_data';
import 'pack_type.dart';

/// 该方法接收三个参数
///
/// - [values] 要打包的数据列表
/// - [formats] 格式列表
/// - [endian] 默认大端格式（根据协议）
///
/// 该方法首先会检查数据列表和格式列表长度是否相等（每一个数据都有对应的格式）。
/// 然后根据每一个字段的大小计算需要分配的byteData的大小。最后遍历整个数据列表，将数据转化为对应的格式添加到byteData中。
Uint8List pack(
  List<dynamic> values,
  List<PackType> formats, {
  Endian endian = Endian.big,
}) {
  if (values.length != formats.length) {
    throw ArgumentError('values 和 formats 长度必须一致');
  }
  // 计算总长度
  int totalSize = 0;
  for (final f in formats) {
    totalSize += f.size;
  }

  final byteData = ByteData(totalSize);
  int offset = 0;

  for (int i = 0; i < values.length; i++) {
    final v = values[i];
    final f = formats[i];

    switch (f) {
      case PackType.int8:
        byteData.setInt8(offset, v);
        break;
      case PackType.uint8:
        byteData.setUint8(offset, v);
        break;
      case PackType.int16:
        byteData.setInt16(offset, v, endian);
        break;
      case PackType.uint16:
        byteData.setUint16(offset, v, endian);
        break;
      case PackType.int32:
        byteData.setInt32(offset, v, endian);
        break;
      case PackType.uint32:
        byteData.setUint32(offset, v, endian);
        break;
      case PackType.float32:
        byteData.setFloat32(offset, v, endian);
        break;
      case PackType.float64:
        byteData.setFloat64(offset, v, endian);
        break;
    }

    offset += f.size;
  }

  return byteData.buffer.asUint8List();
}

/// 从字节数据中解包，返回解析后的值列表
/// 该方法接收三个参数：
///
/// - [bytes] 未解析的整数列表
/// - [formats] 对应的格式列表
/// - [endian] 默认大段
///
/// 首先把 Uint8List 变成 ByteData 视图，初始化 result 列表，
/// 然后遍历整个formats列表，从data取值，每取一次后，游标 [offset] 增加其对应的大小。
List<dynamic> unpack(
  Uint8List bytes,
  List<PackType> formats, {
  Endian endian = Endian.big,
}) {
  final data = ByteData.sublistView(bytes);
  int offset = 0;
  final result = <dynamic>[];

  for (final format in formats) {
    if (offset + format.size > bytes.length) {
      throw ArgumentError('字节数据长度不足，无法解析 ${format.name}');
    }

    switch (format) {
      case PackType.int8:
        result.add(data.getInt8(offset));
        offset += 1;
        break;
      case PackType.uint8:
        result.add(data.getUint8(offset));
        offset += 1;
        break;
      case PackType.int16:
        result.add(data.getInt16(offset, endian));
        offset += 2;
        break;
      case PackType.uint16:
        result.add(data.getUint16(offset, endian));
        offset += 2;
        break;
      case PackType.int32:
        result.add(data.getInt32(offset, endian));
        offset += 4;
        break;
      case PackType.uint32:
        result.add(data.getUint32(offset, endian));
        offset += 4;
        break;
      case PackType.float32:
        result.add(data.getFloat32(offset, endian));
        offset += 4;
        break;
      case PackType.float64:
        result.add(data.getFloat64(offset, endian));
        offset += 8;
        break;
    }
  }
  return result;
}

