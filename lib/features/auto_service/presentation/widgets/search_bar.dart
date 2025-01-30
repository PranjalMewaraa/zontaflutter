import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String, String)? onSearch;

  const CustomSearchBar({Key? key, this.onSearch}) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  String _selectedOption = "Where to?";
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          DropdownButton<String>(
            value: _selectedOption,
            underline: const SizedBox(), // Remove the underline
            items: ["Where to?", "From"].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (newValue) {
              setState(() {
                _selectedOption = newValue!;
                _controller.clear(); // Clear the input when the option changes
              });
            },
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (text) {
                if (widget.onSearch != null) {
                  widget.onSearch!(_selectedOption, text);
                }
              },
              decoration: InputDecoration(
                hintText: _selectedOption,
                border: InputBorder.none,
                prefixIcon: const Icon(Icons.location_on),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    if (widget.onSearch != null) {
                      widget.onSearch!(_selectedOption, "");
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
