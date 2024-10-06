import 'package:flutter/material.dart';
import 'package:language_picker/languages.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';

class LanguageButton extends StatefulWidget {
  const LanguageButton({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LanguageButtonState createState() => _LanguageButtonState();
}

class _LanguageButtonState extends State<LanguageButton> {
  Language _selectedLanguage = Languages.english; // Default language

  final List<Language> _languages = Languages.defaultLanguages;

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.48,
          minChildSize: 0.2,
          maxChildSize: 1.0,
          expand: false,
          builder: (context, scrollController) {
            return ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Scaffold(
                backgroundColor: context.theme.barcolor,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(70.0),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: context.theme.barcolor,
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Container(
                          height: 4,
                          width: 25,
                          decoration: BoxDecoration(
                            color: context.theme.greyColor!.withOpacity(.4),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.of(context).pop(),
                              icon: const Icon(Icons.close),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'App Language',
                                style: TextStyle(
                                  color: context.theme.authAppbarTextColor,
                                  fontFamily: 'Arial',
                                  fontSize: 20,
                                  letterSpacing: 0,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                body: ScrollConfiguration(
                  behavior: NoStretchScrollBehavior(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(
                          color: context.theme.greyColor!.withOpacity(0.3),
                          thickness: .5,
                        ),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: _languages.length,
                            itemBuilder: (context, index) {
                              return RadioListTile<Language>(
                                value: _languages[index],
                                groupValue: _selectedLanguage,
                                onChanged: (Language? language) {
                                  setState(() {
                                    _selectedLanguage = language!;
                                  });
                                  Navigator.of(context).pop();
                                },
                                activeColor: Coloors.greenDark,
                                title: Text(
                                  _languages[index].name,
                                  style: const TextStyle(
                                    fontFamily: 'Arial',
                                    fontSize: 16,
                                    letterSpacing: 0,
                                  ),
                                ),
                                subtitle: Text(
                                  "(${_languages[index].isoCode})",
                                  style: TextStyle(
                                    color: context.theme.greyColor,
                                    fontFamily: 'Arial',
                                    fontSize: 14,
                                    letterSpacing: 0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.theme.langBgColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => showBottomSheet(context),
        borderRadius: BorderRadius.circular(20),
        splashFactory: NoSplash.splashFactory,
        highlightColor: context.theme.langHightlightColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8.0,
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            const Icon(
              Icons.language,
              color: Coloors.greenDark,
              size: 22,
            ),
            const SizedBox(width: 10),
            Text(
              _selectedLanguage.name,
              style: const TextStyle(
                color: Coloors.greenDark,
                fontFamily: 'Arial',
                letterSpacing: 0,
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Coloors.greenDark,
              size: 22,
            ),
          ]),
        ),
      ),
    );
  }
}

class NoStretchScrollBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child; // Removes the stretching effect
  }

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const ClampingScrollPhysics(); // Removes the iOS-style bouncing effect
  }
}
