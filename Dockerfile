# Use the official Dart image as the base image
FROM dart:stable AS build

# Set the working directory in the container
WORKDIR /app

# Copy the pubspec files and download dependencies
COPY pubspec.* ./
RUN dart pub get

# Copy the entire application to the container
COPY . .

# Build the flutter project
RUN flutter build apk --release

# Create a new stage to reduce the final image size
FROM scratch AS production

# Copy the built application from the build stage
COPY --from=build /app/build/app/outputs/flutter-apk/app-release.apk /app/

# Set the entry point to run the application
ENTRYPOINT ["sh", "-c", "echo Flutter build is complete. APK is located at /app/app-release.apk"]
