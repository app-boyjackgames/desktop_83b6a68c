#!/bin/bash
# start-desktop.sh
# Скрипт запуска кастомного рабочего стола "BoyJack OS"

# --- 1. Установка Plymouth и необходимых пакетов ---
echo "Установка Plymouth и темы BoyJack OS..."
sudo apt update
sudo apt install -y plymouth plymouth-themes fluxbox xfce4-terminal firefox pcmanfm

# --- 2. Настройка кастомного Boot Splash ---
echo "Настройка кастомного Boot Screen..."
sudo plymouth-set-default-theme boyjack --rebuild-initrd
# Примечание: Файлы темы должны быть в /usr/share/plymouth/themes/boyjack/

# --- 3. Настройка рабочего стола Fluxbox ---
echo "Настройка Fluxbox..."
mkdir -p ~/.fluxbox
cat > ~/.fluxbox/startup <<'EOF'
#!/bin/sh
# Запуск основных приложений на старте Fluxbox
xfce4-terminal &
# Запуск панели или системного трея можно добавить здесь
exec fluxbox
EOF

chmod +x ~/.fluxbox/startup

# --- 4. Создание рабочего меню Power в Fluxbox ---
echo "Создаем меню Power (Shutdown/Restart)..."
cat > ~/.fluxbox/menu <<'EOF'
[begin] (Fluxbox)
    [exec] (Terminal) {xfce4-terminal}
    [exec] (File Manager) {pcmanfm}
    [exec] (Firefox) {firefox}
    [separator]
    [submenu] (Power)
        [exec] (Shutdown) {sudo shutdown -h now}
        [exec] (Restart) {sudo reboot}
    [end]
[end]
EOF

# --- 5. Запуск рабочего стола ---
echo "Запуск рабочего стола BoyJack OS..."
startx
