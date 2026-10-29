# signup_app

A new Flutter project.

## Reflection

1. Trace the local tip feature from button tap to displayed text. Which widget/state changes during the simulated loading state, and how does the user recover from the local error case?

Tapping the button calls _getTip(). setState() sets _loading to true, changes the button text, disables the button, and shows a loading indicator. After 700 milliseconds, it displays a tip or a local error. Pressing Retry runs the function again and displays a tip because the simulated failure was already reset.

3. Which fixed local category selects the tip, and what form information does the feature deliberately ignore? Why?

The feature uses the fixed local category password_help to select its list of preset tips. It uses _nextTip % matchingTips.length to cycle through the tips, returning to the first tip after reaching the end. It deliberately ignores all form information, including the name, email, and password, because the tips provide general guidance and should not determine whether signup is valid.
