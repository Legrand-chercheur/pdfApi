# 1
FROM dart:stable AS pdf_build

# 2
ENV PORT=8080
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get

# 3
COPY . .
RUN dart pub get --offline
RUN dart compile exe main.dart -o main

# 4
FROM scratch
COPY --from=pdf_build /runtime/ /
COPY --from=pdf_build /app/main /app/

# 5
EXPOSE $PORT
CMD ["/app/main"]

