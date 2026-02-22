import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:lasitrade/theme.dart';
import 'package:lasitrade/extensions.dart';
import 'package:lasitrade/widgets/buttons/gesture_button.dart';

class AppTextField extends StatefulWidget {
  final String title;
  final String placeholder;
  final TextStyle? placeholderStyle;
  final TextEditingController ctrl;
  final String error;
  final Function(String value)? onChanged;
  final VoidCallback? onFocus;
  final VoidCallback? onFocusLost;
  final VoidCallback? onClear;
  final bool capitalization;
  final bool autofocus;
  final double fontSize;
  final FocusNode? focusNode;
  final double? height;
  final TextCapitalization? textCapitalization;
  final List<TextInputFormatter> inputFormatters;

  const AppTextField({
    super.key,
    this.title = '',
    this.placeholder = '',
    this.placeholderStyle,
    required this.ctrl,
    this.error = '',
    this.onChanged,
    this.onFocus,
    this.onFocusLost,
    this.onClear,
    this.capitalization = false,
    this.autofocus = false,
    this.fontSize = 16,
    this.focusNode,
    this.height,
    this.textCapitalization,
    this.inputFormatters = const [],
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final GlobalKey _gkey;

  @override
  void initState() {
    _gkey = GlobalKey();

    widget.ctrl.value = TextEditingValue(
      text: widget.ctrl.text,
      selection: TextSelection.collapsed(offset: widget.ctrl.text.length),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _gkey,
      child: SizedBox(
        width: context.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.title.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 14,
                    letterSpacing: 0.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              4.h,
            ],
            SizedBox(
              height: widget.height ?? AppTheme.appTextFieldHeight,
              child: Focus(
                onFocusChange: (bool value) {
                  (value ? widget.onFocus : widget.onFocusLost)?.call();
                },
                child: CupertinoTextField(
                  focusNode: widget.focusNode,
                  controller: widget.ctrl,
                  keyboardType: TextInputType.text,
                  keyboardAppearance: Brightness.dark,
                  autocorrect: false,
                  autofocus: widget.autofocus,
                  cursorColor: AppTheme.clText,
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  inputFormatters: widget.inputFormatters,
                  textCapitalization:
                      widget.textCapitalization ?? TextCapitalization.none,
                  decoration: BoxDecoration(
                    color: AppTheme.clTransparent,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(AppTheme.appBtnRadius),
                    ),
                    border: Border.all(
                      width: 1,
                      color: (widget.error.isNotEmpty)
                          ? AppTheme.clRed08
                          : AppTheme.clTransparent,
                    ),
                  ),
                  style: TextStyle(
                    // fontFamily: AppTheme.ffLight,
                    fontSize: widget.fontSize,
                    letterSpacing: 0.2,
                    color: AppTheme.clText,
                  ),
                  placeholder: widget.placeholder,
                  placeholderStyle: widget.placeholderStyle ??
                      TextStyle(
                        fontSize: widget.fontSize,
                        // letterSpacing: 0.2,
                        color: AppTheme.clText03,
                      ),
                  onChanged: widget.onChanged,
                  suffix: widget.onClear != null && widget.ctrl.text.isNotEmpty
                      ? AppGestureButton(
                          onTap: widget.onClear,
                          child: Container(
                            padding: const EdgeInsets.only(right: 8),
                            child: const Icon(
                              Icons.cancel_outlined,
                              color: AppTheme.clText04,
                              size: 18,
                            ),
                          ),
                        )
                      : Container(),
                ),
              ),
            ),
            if (widget.error.isNotEmpty) ...[
              4.h,
              Container(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  widget.error,
                  style: const TextStyle(
                    color: AppTheme.clRed,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class AppTextFieldUpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.composing.isValid && !newValue.composing.isCollapsed) {
      return newValue;
    }

    final upper = newValue.text.toUpperCase();

    return newValue.copyWith(
      text: upper,
      selection: newValue.selection,
      composing: TextRange.empty,
    );
  }
}
