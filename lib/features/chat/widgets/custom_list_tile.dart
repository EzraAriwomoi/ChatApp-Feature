import 'package:flutter/material.dart';
import 'package:ult_whatsapp/common/extension/custom_theme_extension.dart';
import 'package:ult_whatsapp/common/utils/coloors.dart';

class CustomListTile extends StatefulWidget {
  const CustomListTile({
    super.key,
    required this.title,
    required this.leading,
    this.subTitle,
    this.trailing,
  });

  final String title;
  final IconData leading;
  final String? subTitle;
  final Widget? trailing;

  @override
  // ignore: library_private_types_in_public_api
  _CustomListTileState createState() => _CustomListTileState();
}

class _CustomListTileState extends State<CustomListTile> {
  bool _switchValue = false;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (widget.trailing is Switch) {
          setState(() {
            _switchValue = !_switchValue;
          });
        }
      },
      contentPadding: const EdgeInsets.fromLTRB(25, 0, 10, 0),
      title: Text(
        widget.title,
        style: const TextStyle(
          fontFamily: 'Arial',
          fontSize: 17,
          letterSpacing: 0,
        ),
      ),
      subtitle: widget.subTitle != null
          ? Text(
              widget.subTitle!,
              style: TextStyle(
                color: context.theme.greyColor,
                fontFamily: 'Arial',
                fontSize: 15,
                letterSpacing: 0,
              ),
            )
          : null,
      leading: Icon(widget.leading),
      trailing: widget.trailing is Switch
          ? Switch(
              value: _switchValue,
              onChanged: (value) {
                setState(() {
                  _switchValue = value;
                });
              },
              activeColor: Colors.black,
              inactiveThumbColor: context.theme.greyColor,
              inactiveTrackColor: context.theme.barcolor,
              activeTrackColor: Coloors.greenDark,
            )
          : widget.trailing,
    );
  }
}
