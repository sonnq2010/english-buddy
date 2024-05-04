import 'package:flutter/material.dart';

class CustomizeDropdownButton<T> extends StatefulWidget {
  const CustomizeDropdownButton({
    super.key,
    required this.values,
    required this.onChanged,
    this.initialValue,
  });

  final Map<T, String> values;
  final void Function(T? value) onChanged;
  final T? initialValue;

  @override
  State<CustomizeDropdownButton> createState() =>
      _CustomizeDropdownButtonState<T>();
}

class _CustomizeDropdownButtonState<T>
    extends State<CustomizeDropdownButton<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant CustomizeDropdownButton<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedValue = widget.initialValue;
  }

  void _onChanged(T? value) {
    setState(() {
      selectedValue = value;
    });

    widget.onChanged(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<T>(
        value: selectedValue,
        items: widget.values.entries.map((e) {
          return DropdownMenuItem<T>(
            value: e.key,
            child: Text(e.value.toString()),
          );
        }).toList(),
        onChanged: _onChanged,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        borderRadius: BorderRadius.circular(8),
        underline: const SizedBox.shrink(),
      ),
    );
  }
}
