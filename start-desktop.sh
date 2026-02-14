#!/bin/bash
set -eux

echo "Установка Plymouth и необходимых пакетов..."
sudo apt update
sudo apt install -y plymouth plymouth-themes fluxbox xfce4-terminal firefox pcmanfm xserver-xorg xinit

echo "Настройка кастомного Boot Screen..."
if [ -d "/usr/share/plymouth/themes/boyjack" ]; then
    sudo plymouth-set-default-theme boyjack --rebuild-initrd
else
    echo "Тема boyjack не найдена, используем дефолтную spinner"
    sudo plymouth-set-default-theme spinner --rebuild-initrd
fi

echo "Настройка Fluxbox..."
mkdir -p ~/.fluxbox
cat > ~/.fluxbox/startup <<'EOF'
#!/bin/sh
xfce4-terminal &
pcmanfm &
firefox &
exec fluxbox
EOF
chmod +x ~/.fluxbox/startup

echo "Создаем меню Power (Shutdown/Restart)..."
cat > ~/.fluxbox/menu <<'EOF'
[begin] (Fluxbox)
    [exec] (Terminal) {xfce4-terminal}
    [exec] (File Manager) {pcmanfm}
    [exec] (Firefox) {firefox}
    [separator]
    [submenu] (Power)
        [exec] (Shutdown) {systemctl poweroff}
        [exec] (Restart) {systemctl reboot}
    [end]
[end]
EOF

echo "Запуск рабочего стола BoyJack OS..."
if command -v startx >/dev/null 2>&1; then
    startx
else
    echo "X-сервер не найден. Установите xserver-xorg и xinit."
fi
