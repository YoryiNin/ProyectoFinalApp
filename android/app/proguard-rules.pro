# Flutter específico
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Para cached_network_image
-keep class com.bumptech.glide.** { *; }
-keep class com.bumptech.glide.load.resource.bitmap.** { *; }

# Para imágenes y assets
-keep class androidx.lifecycle.** { *; }
-keep class com.google.android.material.** { *; }