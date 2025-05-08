import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  List<DateTime> _getDaysInMonth(DateTime date) {
    final first = DateTime(date.year, date.month, 1);
    final last = DateTime(date.year, date.month + 1, 0);
    final days = <DateTime>[];

    for (int i = 0; i < first.weekday % 7; i++) {
      days.add(first.subtract(Duration(days: first.weekday % 7 - i)));
    }
    for (int i = 0; i < last.day; i++) {
      days.add(DateTime(date.year, date.month, i + 1));
    }
    while (days.length % 7 != 0) {
      days.add(days.last.add(const Duration(days: 1)));
    }

    return days;
  }

  void _goToPreviousMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month - 1);
    });
  }

  void _goToNextMonth() {
    setState(() {
      _focusedDay = DateTime(_focusedDay.year, _focusedDay.month + 1);
    });
  }

  void _selectYear(int year) {
    setState(() {
      _focusedDay = DateTime(year, _focusedDay.month, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final days = _getDaysInMonth(_focusedDay);
    final accent = Colors.indigoAccent;
    final darkBg = const Color(0xFF121212); // base dark background
    final cardBg = const Color(0xFF1E1E1E); // container background

    return Scaffold(
      backgroundColor: darkBg,
      appBar: AppBar(
        backgroundColor: darkBg,
        elevation: 0,
        title: Text(
          'Calendar',
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white70),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              )
            ],
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28, color: Colors.white),
                      onPressed: _goToPreviousMonth,
                    ),
                    Row(
                      children: [
                        Text(
                          DateFormat.MMMM().format(_focusedDay),
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 8),
                        DropdownButton<int>(
                          dropdownColor: cardBg,
                          style: const TextStyle(color: Colors.white),
                          value: _focusedDay.year,
                          items: List.generate(100, (i) => 2000 + i)
                              .map((y) => DropdownMenuItem(
                                    value: y,
                                    child: Text('$y', style: const TextStyle(color: Colors.white)),
                                  ))
                              .toList(),
                          onChanged: (y) => y != null ? _selectYear(y) : null,
                          underline: const SizedBox(),
                          iconEnabledColor: Colors.white,
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 28, color: Colors.white),
                      onPressed: _goToNextMonth,
                    ),
                  ],
                ),
              ),

              // Weekdays
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
                      .map((e) => Expanded(
                            child: Center(
                              child: Text(
                                e,
                                style: GoogleFonts.inter(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),

              const SizedBox(height: 8),

              // Calendar Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: GridView.builder(
                    itemCount: days.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final day = days[index];
                      final isCurrentMonth = day.month == _focusedDay.month;
                      final isToday = DateTime.now().day == day.day &&
                          DateTime.now().month == day.month &&
                          DateTime.now().year == day.year;
                      final isSelected = _selectedDay != null &&
                          _selectedDay!.day == day.day &&
                          _selectedDay!.month == day.month &&
                          _selectedDay!.year == day.year;

                      return GestureDetector(
                        onTap: () => setState(() => _selectedDay = day),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? accent.withOpacity(0.9)
                                : isCurrentMonth
                                    ? const Color(0xFF2C2C2E)
                                    : const Color(0xFF1A1A1C),
                            borderRadius: BorderRadius.circular(12),
                            border: isToday
                                ? Border.all(color: accent, width: 2)
                                : null,
                          ),
                          child: Center(
                            child: Text(
                              '${day.day}',
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : isCurrentMonth
                                        ? Colors.white70
                                        : Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
