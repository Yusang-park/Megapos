import 'package:flutter/material.dart';

/* 재사용 가능한 버튼 2개를 가진 Dialog입니다. */

class ConfirmDialog extends StatelessWidget {
  ConfirmDialog({
    Key key,
    this.width,
    this.height,
    this.bodyText,
  }) : super(key: key);
  final double width;
  final double height;
  final String bodyText;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      child: SizedBox(
        height: height * 0.4,
        width: width * 0.5,
        child: Padding(
          padding: EdgeInsets.all(width * 0.02),
          child: Column(
            children: <Widget>[
              Text('알림'),
              Divider(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(width * 0.02),
                  child: Text(
                    bodyText,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                      child: Text('확인'),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.03,
                  ),
                  ButtonTheme(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                      child: Text('취소'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
