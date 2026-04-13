import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import '../crc/crc16_modbus.dart';




class CheckDigit {
  const CheckDigit._();

  /// 给原始数据包追加 CRC16（低字节在前）
  static Uint8List append(Uint8List payload) {
    final crcBytesLE = Crc16Modbus.computeLE(payload);
    return Uint8List.fromList([
      ...payload,
      ...crcBytesLE,
    ]);
  }

  /// 校验【带 CRC】的数据包是否正确
  static bool verify(Uint8List packet) {
    if (packet.length < 3) return false;

    final dataLength = packet.length - 2;
    final data = packet.sublist(0, dataLength);

    final crcLow = packet[dataLength];
    final crcHigh = packet[dataLength + 1];
    final actualCrc = (crcHigh << 8) | crcLow;

    final expectedCrc = Crc16Modbus.compute(data);

    return expectedCrc == actualCrc;
  }


  /// 计算数据包CRC 校验【带 CRC】的数据包是否正确
  static bool verifyModbus(Uint8List packet) {
    final crc = Crc16Modbus.compute(packet);
    if (crc != 0) {
      debugPrint('Modbus CRC error: 0x${crc.toRadixString(16)}');
    }
    return crc == 0;
  }

  /// 从数据包中提取原始数据（不校验 CRC）
  static Uint8List extractPayload(Uint8List packet) {
    if (packet.length < 3) {
      throw ArgumentError('数据包长度不足');
    }
    return packet.sublist(0, packet.length - 2);
  }

  /// 获取 CRC 值（低字节在前）
  static int extractCrc(Uint8List packet) {
    if (packet.length < 2) {
      throw ArgumentError('数据包长度不足');
    }
    final low = packet[packet.length - 2];
    final high = packet[packet.length - 1];
    return (high << 8) | low;
  }
}
