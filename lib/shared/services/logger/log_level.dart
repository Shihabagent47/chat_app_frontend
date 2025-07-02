enum LogLevel {
  debug(0),
  info(1),
  warning(2),
  error(3),
  fatal(4);

  const LogLevel(this.value);
  final int value;

  bool operator >=(LogLevel other) => value >= other.value;
  bool operator <=(LogLevel other) => value <= other.value;
}
