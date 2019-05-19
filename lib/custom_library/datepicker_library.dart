import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:codingroomevents/custom_library/datepicker_library_cupertino.dart';

const List<String> monthNames = const <String>[
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

DateTime _date = DateTime.now();

int _selectedMonth = _date.month - 1;
int _selectedDate = _date.day - 1;
int _selectedYear = _date.year - 2016;
String _dobMonth = monthNames[_date.month - 1];
FixedExtentScrollController scrollDate = new FixedExtentScrollController(
  initialItem: _selectedDate,
);
FixedExtentScrollController scrollMonth = new FixedExtentScrollController(
  initialItem: _selectedMonth,
);
FixedExtentScrollController scrollYear = new FixedExtentScrollController(
  initialItem: _selectedYear,
);

FixedExtentScrollController get scrollControlDate => scrollDate;
FixedExtentScrollController get scrollControlMonth => scrollMonth;
FixedExtentScrollController get scrollControlYear => scrollYear;

int get dobMonth => _selectedMonth;
String get month =>
    _selectedMonth < 9 ? "0${_selectedMonth + 1}" : "${_selectedMonth + 1}";

String get dobDate =>
    _selectedDate + 1 < 10 ? '0${_selectedDate + 1}' : '${_selectedDate + 1}';
int get dobYear => (_date.year - 3) + _selectedYear;
String get dobStrMonth => _dobMonth;

const LinearGradient zGradient =
    const LinearGradient(begin: Alignment(-0.5, 1.0), colors: [
  Color(0xFFF98495),
  Color(0xFF595DC2),
]);

/// Color of the item background
const Color zItemColor = const Color(0xFFF98495);

/// Shape of the item
const ShapeBorder zShape = const BeveledRectangleBorder(
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(15.0),
    bottomRight: Radius.circular(15.0),
  ),
);

///Global key to access the getters
final dobKey = GlobalKey<DatePickerState>();

class DatePicker extends StatefulWidget {
  DatePicker({
    Key key,
    @required this.setDate,
    this.customItemColor = zItemColor,
    this.customShape = zShape,
    this.customGradient = zGradient,
  }) : super(key: key);

  /// Function to get the data
  final Function setDate;

  /// Custom LinerGradient for the submit button
  final LinearGradient customGradient;

  /// BackgroundColor for the selected item (Month/date/year)
  final Color customItemColor;

  /// Custom shape for the selected item
  final ShapeBorder customShape;

  @override
  DatePickerState createState() => DatePickerState();
}

class DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(left: 18.0),
                height: 100.0,
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(
                      color: themeData.disabledColor,
                    )),
                    color: Colors.white),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                  child: CustomCupertinoPicker(
                    customShape: widget.customShape,
                    customColor: widget.customItemColor,
                    backgroundColor: Colors.white,
                    scrollController: scrollMonth,
                    itemExtent: 35.0,
                    diameterRatio: 1.2,
                    onSelectedItemChanged: (int index) {
                      setState(() {
                        _selectedMonth = index;
                        _dobMonth = monthNames[index];
                      });
                    },
                    children:
                        List<Widget>.generate(monthNames.length, (int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Text(
                          monthNames[index],
                          style: TextStyle(
                            color: _selectedMonth == index
                                ? Colors.white
                                : widget.customItemColor.withOpacity(0.6),
                            fontSize: 18.0,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: 18.0),
                  height: 100.0,
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                        color: themeData.disabledColor,
                      )),
                      color: Colors.white),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomCupertinoPicker(
                      customShape: widget.customShape,
                      customColor: widget.customItemColor,
                      backgroundColor: Colors.white,
                      scrollController: scrollDate,
                      itemExtent: 35.0,
                      diameterRatio: 1.2,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedDate = index;
                        });
                      },
                      children: List<Widget>.generate(31, (int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            "${index + 1}",
                            style: TextStyle(
                              color: _selectedDate == index
                                  ? Colors.white
                                  : widget.customItemColor.withOpacity(0.6),
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        );
                      }),
                    ),
                  )),
            ),
            Expanded(
              flex: 1,
              child: Container(
                  padding: EdgeInsets.only(left: 18.0),
                  height: 100.0,
                  decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: themeData.disabledColor)),
                    color: Colors.white,
                  ),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10.0),
                    child: CustomCupertinoPicker(
                      customShape: widget.customShape,
                      customColor: widget.customItemColor,
                      backgroundColor: Colors.white,
                      scrollController: scrollYear,
                      itemExtent: 35.0,
                      diameterRatio: 1.2,
                      onSelectedItemChanged: (int index) {
                        setState(() {
                          _selectedYear = index;
                        });
                      },
                      children: List<Widget>.generate(15, (int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Text(
                            '${(_date.year - 3) + index}',
                            style: TextStyle(
                              color: _selectedYear == index
                                  ? Colors.white
                                  : widget.customItemColor.withOpacity(0.6),
                              fontSize: 18.0,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        );
                      }),
                    ),
                  )),
            ),

            /// Submit button
            Expanded(
              flex: 1,
              child: Container(
                height: 100.0,
                decoration: BoxDecoration(
                    border:
                        Border(top: BorderSide(color: themeData.disabledColor)),
                    color: Colors.white),
                child: Center(
                  child: ClipOval(
                    child: Container(
                      width: 50.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        border: Border(
                            top: BorderSide(
                          color: themeData.disabledColor,
                        )),
                        gradient: widget.customGradient ?? zGradient,
                      ),
                      child: IconButton(
                        color: Colors.white,
                        icon: Icon(
                          Icons.send,
                          size: 20.0,
                        ),
                        onPressed: () {
                          widget.setDate();
                        },
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
