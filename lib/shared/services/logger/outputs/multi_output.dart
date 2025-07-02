import 'package:logger/logger.dart';

class MultiOutput extends LogOutput {
  final List<LogOutput> _outputs;

  MultiOutput(this._outputs);

  @override
  Future<void> init() async{
    super.init();
    for (final output in _outputs) {
      output.init();
    }
  }

  @override
  void output(OutputEvent event) {
    for (final output in _outputs) {
      try {
        output.output(event);
      } catch (e) {
        print('Error in log output: $e');
      }
    }
  }

  @override
  Future<void> destroy() async{
    for (final output in _outputs) {
      output.destroy();
    }
    super.destroy();
  }
}
