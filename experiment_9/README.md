# Experiment 9

A Flutter student-records UI that calls the Supabase REST API.

## Configure Supabase

Run [supabase/schema.sql](supabase/schema.sql) in the Supabase SQL Editor. The
sample policies allow anonymous read, insert, and delete access for demonstration
only; do not use them for production data.

From this directory, run the app with the project URL and publishable key:

```sh
flutter pub get
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://your-project.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=your-publishable-key
```

The application also displays configuration and request errors in the UI.
