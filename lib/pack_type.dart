enum PackType {
  int8(1),
  uint8(1),
  int16(2),
  uint16(2),
  int32(4),
  uint32(4),
  int64(8),
  uint64(8),
  float32(4),
  float64(8),
  boolP(1);

  final int size;

  const PackType(this.size);
}