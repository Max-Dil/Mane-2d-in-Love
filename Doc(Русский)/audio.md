# Документация модуля `mane.audio`
Модуль `mane.audio` предоставляет функционал для работы со звуками в движке `mane`.

---

## `audio.loadSound(filename, options)`

Загружает аудиофайл и сохраняет его в хранилище звуков.

### Параметры
- `filename` (string): Путь к аудиофайлу (например, `"assets/sound.wav"`). Поддерживаются форматы `.wav`, `.ogg`, `.mp3`.
- `options` (table, необязательно): Таблица настроек:
  - `stream` (boolean): Если `true`, загружает как поток (для длинных файлов, например, музыки). По умолчанию `false` (статический звук).

### Возвращает
- `soundId` (string): Уникальный идентификатор звука (в данном случае совпадает с `filename`).

### Пример
```lua
local soundId = mane.audio.loadSound("assets/explosion.wav")
```

---

## `audio.play(soundId, options)`

Проигрывает загруженный звук с заданными настройками.

### Параметры
- `soundId` (string): Идентификатор звука, полученный из `loadSound`.
- `options` (table, необязательно): Таблица настроек:
  - `loop` (boolean): Включает/выключает зацикливание.
  - `volume` (number): Громкость от 0.0 до 1.0.
  - `pitch` (number): Скорость воспроизведения (1.0 — нормальная).
  - `position` (table): Пространственная позиция `{ x, y, z }`.
  - `clone` (boolean): Если `true`, создаёт копию звука для одновременного воспроизведения.

### Возвращает
- `instance` (Source): Объект `Source` из LÖVE для дальнейшего управления звуком (или `nil`, если звук не найден).

### Пример
```lua
mane.audio.play("assets/explosion.wav", { volume = 0.8, loop = false })
```

---

## `audio.stop(soundIdOrInstance)`

Останавливает воспроизведение звука.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.stop("assets/explosion.wav")
-- или
local instance = mane.audio.play("assets/explosion.wav")
mane.audio.stop(instance)
```

---

## `audio.pause(soundIdOrInstance)`

Ставит звук на паузу.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.pause("assets/explosion.wav")
```

---

## `audio.resume(soundIdOrInstance)`

Возобновляет воспроизведение звука после паузы.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.resume("assets/explosion.wav")
```

---

## `audio.setVolume(volume)`

Устанавливает глобальную громкость для всех звуков.

### Параметры
- `volume` (number): Громкость от 0.0 до 1.0.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.setVolume(0.5) -- 50% громкости для всех звуков
```

---

## `audio.setSoundVolume(soundIdOrInstance, volume)`

Устанавливает громкость для конкретного звука.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.
- `volume` (number): Громкость от 0.0 до 1.0.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.setSoundVolume("assets/explosion.wav", 0.7)
```

---

## `audio.isPlaying(soundIdOrInstance)`

Проверяет, играет ли звук.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.

### Возвращает
- `boolean`: `true`, если звук воспроизводится, иначе `false`.

### Пример
```lua
if mane.audio.isPlaying("assets/explosion.wav") then
    print("Звук играет!")
end
```

---

## `audio.setListenerPosition(x, y, z)`

Устанавливает позицию слушателя для пространственного звука.

### Параметры
- `x` (number): Координата X.
- `y` (number): Координата Y.
- `z` (number): Координата Z.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.setListenerPosition(0, 0, 0) -- Слушатель в центре
```

---

## `audio.setPitch(soundIdOrInstance, pitch)`

Устанавливает скорость воспроизведения звука.

### Параметры
- `soundIdOrInstance` (string или Source): Идентификатор звука или объект `Source`.
- `pitch` (number): Скорость (1.0 — нормальная, >1.0 — быстрее, <1.0 — медленнее).

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.setPitch("assets/explosion.wav", 1.5) -- Ускоряем в 1.5 раза
```

---

## `audio.dispose(soundId)`

Освобождает звук из памяти.

### Параметры
- `soundId` (string): Идентификатор звука.

### Возвращает
- Ничего.

### Пример
```lua
mane.audio.dispose("assets/explosion.wav")
```

---

## Примечания
- Все функции, принимающие `soundIdOrInstance`, могут работать как с идентификатором звука (строкой), так и с объектом `Source`, возвращённым из `audio.play`.
- Звуки автоматически сохраняются в `mane.sounds` и `audio.sounds` для общего доступа.
- Поддерживаются все возможности `love.audio`, включая 3D-звук и управление экземплярами.