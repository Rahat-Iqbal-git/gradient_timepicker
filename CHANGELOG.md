# Changelog

## 0.2.1

- Internalize `TimePickerSheet` widget — use `showTimePickerSheet` to open the picker

## 0.2.0

- Add `use24Hour` parameter to `showTimePickerSheet` and `TimePickerSheet` for 24-hour clock support
- 24-hour mode shows hours `00–23` and hides the AM/PM wheel

## 0.1.0+2

- Add demo GIF to Showcase section in README


## 0.1.0+1

- Initial release
- Gradient bottom-sheet time picker with hour, minute, and AM/PM wheel selection
- Animated gradient background transitions between AM (blue) and PM (dark) colour schemes
- `showTimePickerSheet` convenience function returns the selected `TimeOfDay` or `null` on dismiss
- Supports optional `initialTime`; defaults to `TimeOfDay.now()`
