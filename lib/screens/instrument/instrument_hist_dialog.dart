import 'package:lasitrade/extensions.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class InstrumentHistDialog extends StatefulWidget {
  const InstrumentHistDialog({super.key});

  @override
  State<InstrumentHistDialog> createState() => _InstrumentHistDialogState();
}

class _InstrumentHistDialogState extends State<InstrumentHistDialog> {
  @override
  Widget build(BuildContext context) {
    return ModalContainer(
      child: SizedBox(
        width: 300,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Set the dimensions for the layer.').muted(),
            10.h,
            //
            10.h,
            SecondaryButton(
              onPressed: () {
                closeOverlay(context);
              },
              child: const Text('No'),
            ),
            PrimaryButton(
              onPressed: () {
                closeOverlay(context);
              },
              child: const Text('Yes'),
            ),
          ],
        ),
      ),
    );
  }
}
