# Keep OkHttp3 classes (required by image_cropper/ucrop)
-dontwarn okhttp3.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Keep Okio classes (dependency of OkHttp3)
-dontwarn okio.**
-keep class okio.** { *; }

# Keep UCrop classes
-keep class com.yalantis.ucrop.** { *; }
-keepclassmembers class com.yalantis.ucrop.** { *; }
