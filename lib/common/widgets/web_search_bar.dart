import 'package:flutter/material.dart';
import 'package:my_chat/colors.dart';

class WebSearchBar extends StatelessWidget {
  const WebSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 30,
      height: MediaQuery.of(context).size.height * 0.08,
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        border: Border(right: BorderSide(color: dividerColor)),
        color: backgroundColor,
      ),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Container(
          height: 40,
          width: MediaQuery.of(context).size.width * 0.25,
          child: TextField(
                  decoration: InputDecoration(
          filled: true,
          fillColor: searchBarColor,
          prefixIcon: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.search,
              size: 20,
            ),
          ),
          hintStyle: const TextStyle(fontSize: 14),
          hintText: 'Search contacts',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
          contentPadding: const EdgeInsets.all(7),
                  ),
                ),
        ),
        const Icon(
          Icons.filter_alt_outlined,
          color: Colors.grey,
        )
      ]),
    );
  }
}
