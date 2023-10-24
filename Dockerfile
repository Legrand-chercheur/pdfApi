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
RUN dart compile exe main.dart -o bin/pdf
# 4
FROM scratch
COPY --from=pdf_build /runtime/ /
COPY --from=pdf_build /app/bin/pdf /app/bin/
# 5
EXPOSE $PORT
CMD ["/app/bin/pdf"]
