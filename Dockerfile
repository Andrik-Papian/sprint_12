# Используйте официальный образ Go как базовый
FROM golang:1.22 AS builder

# Установите рабочую директорию
WORKDIR /app

# Копируйте go.mod и go.sum файлы
COPY go.mod go.sum ./

# Загрузите зависимости
RUN go mod download

# Копируйте исходный код
COPY . .

# Постройте бинарный файл приложения
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Используйте официальный образ Alpine для финального образа
FROM alpine:latest

# Установите необходимые зависимости для выполнения Go-бинарника
RUN apk --no-cache add ca-certificates sqlite

# Установите рабочую директорию
WORKDIR /root/

# Копируйте бинарный файл из предыдущего этапа
COPY --from=builder /app/main .

# Установите команду для выполнения при запуске контейнера
CMD ["./main"]
