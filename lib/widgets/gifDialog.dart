import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trinetraflutter/theme_provider.dart';

gifDialog(BuildContext context, String path, String name, Function navigation,
    Function nav2) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      clipBehavior: Clip.antiAlias,
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(path),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text(
                    name,
                    style: const TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: value.themeMode == ThemeMode.light
                            ? Colors.grey.shade500
                            : Colors.grey.shade500,
                      ),
                      onPressed: () {
                        navigation();
                      },
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: value.themeMode == ThemeMode.light
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey.shade800,
                      ),
                      onPressed: () {
                        nav2();
                      },
                      child: const Text(
                        "Ok",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}
