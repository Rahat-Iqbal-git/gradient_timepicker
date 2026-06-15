# Changelog

## 0.3.0

- Added `TimePickerGradient.moonrise` preset — blush lavender AM, slate-charcoal PM
- Added `TimePickerGradient.mystic` preset — hazy grey-blue AM, deep slate PM
- Added `TimePickerGradient.opal` preset — pale lime-yellow AM, olive-green PM

## 0.2.1

- Internalized `TimePickerSheet` widget — use `showTimePickerSheet` to open the picker
- Added `buttonText` parameter to customize the confirm button label
- Added `gradient` parameter with `TimePickerGradient` presets for custom color schemes
- Animated text color smoothly between AM and PM gradient schemes

## 0.2.0

- Added `use24Hour` parameter to `showTimePickerSheet` for 24-hour clock support
- 24-hour mode showed hours `00–23` and hid the AM/PM wheel

## 0.1.0+2

- Added demo GIF to Showcase section in README

## 0.1.0+1

- Initial release
- Added gradient bottom-sheet time picker with hour, minute, and AM/PM wheel selection
- Animated gradient background transitioned between AM (blue) and PM (dark) colour schemes
- Added `showTimePickerSheet` convenience function that returned the selected `TimeOfDay` or `null` on dismiss
- Supported optional `initialTime`; defaulted to `TimeOfDay.now()`
