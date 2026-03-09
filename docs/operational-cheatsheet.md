# Щоденна пам'ятка для `upstream-sync-review`

Це fork-side гілка для синхронізації з `upstream/main` і швидкого розуміння, що саме змінив maintainer.

- `origin/main` тут лишається дзеркалом `upstream/main`
- локальна робота, нотатки і перевірка змін ідуть у `upstream-sync-review`
- README прямо каже, що maintainer не приймає зовнішні contributions напряму, тому ця гілка потрібна саме для локального review/sync workflow

## 10 команд

1. Переключитися в робочу sync-гілку
   ```bash
   git checkout upstream-sync-review
   ```

2. Перевірити гілку і робоче дерево
   ```bash
   git status --short --branch
   ```

3. Підтягнути стан свого форку
   ```bash
   git fetch origin
   ```

4. Підтягнути апстрім і теги
   ```bash
   git fetch upstream --tags
   ```

5. Побачити, наскільки ця гілка відстає від maintainer'а
   ```bash
   git rev-list --left-right --count HEAD...upstream/main
   ```

6. Переглянути нові коміти maintainer'а
   ```bash
   git log --oneline --decorate --no-merges HEAD..upstream/main
   ```

7. Подивитися, які файли реально зміняться
   ```bash
   git diff --stat HEAD..upstream/main
   ```

8. Підтягнути зміни fast-forward'ом, коли все зрозуміло
   ```bash
   git merge --ff-only upstream/main
   ```

9. Перевірити, що репо збирається після синку
   ```bash
   go build ./...
   ```

10. Прогнати базову валідацію після синку
    ```bash
    go test ./... && go vet ./...
    ```

## Після успішного синку

```bash
git push -u origin upstream-sync-review
```

## Нотатки

- Якщо треба розібрати окремий коміт глибше: `git show --stat <sha>`.
- Якщо merge торкнувся Go-коду, додатково корисно прогнати `ubs <changed-files>`.
- Для агентних перевірок стану проєкту використовуй тільки `bv --robot-*`; bare `bv` запускає TUI.
